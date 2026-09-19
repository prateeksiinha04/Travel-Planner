using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;

namespace AI_Travel_Planner
{
    public partial class TripPlanner : Page
    {
        public class ActivityItem
        {
            public string TimeOfDay { get; set; }
            public string Title { get; set; }
            public string Description { get; set; }
            public bool IsRecommended { get; set; }
            public string MapSearchQuery { get; set; }
        }

        public class DayItinerary
        {
            public string DayTitle { get; set; }
            public string DayTheme { get; set; }
            public string CityName { get; set; }
            public string DayImageUrl { get; set; }
            public string WeatherWidget { get; set; }
            public List<ActivityItem> Activities { get; set; }
        }

        public class BookedTripModel
        {
            public string BookingId { get; set; }
            public string PrimaryTraveler { get; set; }
            public string Destination { get; set; }
            public string TravelDate { get; set; }
            public string Guests { get; set; }
            public string PackageType { get; set; }
            public string PhoneNumber { get; set; }
            public string AmountPaid { get; set; }
            public DateTime BookingDate { get; set; }
        }

        public class NeighborStateInfo
        {
            public string StateName { get; set; }
            public string DistanceDetail { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["dest"] != null)
                {
                    string passedDest = Server.UrlDecode(Request.QueryString["dest"]);
                    SetStateDropdownValue(passedDest);
                    GenerateStructuredItinerary();
                    CheckExistingBookingForState(passedDest);
                }
            }
        }

        private void CheckExistingBookingForState(string stateName)
        {
            var userTrips = Session["UserTrips"] as List<BookedTripModel>;
            if (userTrips != null)
            {
                var match = userTrips.FirstOrDefault(t => t.Destination.ToLower().Contains(stateName.ToLower()));
                if (match != null)
                {
                    lblTicketId.Text = match.BookingId;
                    lblTicketName.Text = match.PrimaryTraveler;
                    lblTicketDest.Text = match.Destination;
                    lblTicketDate.Text = match.TravelDate;
                    lblTicketGuests.Text = match.Guests;
                    lblTicketMode.Text = match.PackageType;

                    lblBannerTraveler.Text = match.PrimaryTraveler;
                    lblBannerDate.Text = match.TravelDate;
                    lblBannerPackage.Text = match.PackageType;

                    pnlTicketSummary.Visible = true;
                    pnlBookedSummaryBanner.Visible = true;
                }
            }
        }

        protected void btnGenerateItinerary_Click(object sender, EventArgs e)
        {
            GenerateStructuredItinerary();
        }

        protected void btnConfirmBooking_Click(object sender, EventArgs e)
        {
            string bookerName = txtBookerName.Text.Trim();
            string travelDate = txtTravelDate.Text;
            string guests = txtGuestCount.Text;
            string travelMode = ddlTravelMode.SelectedValue;
            string destination = ddlState.SelectedValue;
            string phoneNo = txtBookerPhone.Text.Trim();

            if (!string.IsNullOrEmpty(bookerName) && !string.IsNullOrEmpty(phoneNo))
            {
                string bookingId = "TRP-AI" + new Random().Next(10000, 99999);
                int guestNum = int.TryParse(guests, out guestNum) ? guestNum : 1;

                int rate = 1499;
                if (travelMode.Contains("3,499")) rate = 3499;
                else if (travelMode.Contains("6,999")) rate = 6999;
                else if (travelMode.Contains("12,999")) rate = 12999;

                decimal totalAmount = rate * guestNum;
                string totalCost = "₹" + totalAmount.ToString("N0");

                // ==========================================
                // REAL-TIME DATABASE INSERTION CODE
                // ==========================================
                try
                {
                    string connString = ConfigurationManager.ConnectionStrings["TravelPlannerDBConn"].ConnectionString;
                    string query = "INSERT INTO UserBookings (TravelerName, Destination, TravelDate, GuestCount, PackageDetails, TotalPaid, PhoneNumber, BookingTime) " +
                                   "VALUES (@Name, @Dest, @Date, @Guests, @Package, @Paid, @Phone, GETDATE())";

                    using (SqlConnection conn = new SqlConnection(connString))
                    {
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@Name", bookerName);
                            cmd.Parameters.AddWithValue("@Dest", destination);
                            cmd.Parameters.AddWithValue("@Date", string.IsNullOrEmpty(travelDate) ? DateTime.Now.AddDays(7) : Convert.ToDateTime(travelDate));
                            cmd.Parameters.AddWithValue("@Guests", guestNum);
                            cmd.Parameters.AddWithValue("@Package", travelMode);
                            cmd.Parameters.AddWithValue("@Paid", totalAmount);
                            cmd.Parameters.AddWithValue("@Phone", phoneNo);

                            conn.Open();
                            cmd.ExecuteNonQuery();
                            conn.Close();
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Error logging if needed
                }
                // ==========================================

                lblTicketId.Text = bookingId;
                lblTicketName.Text = bookerName;
                lblTicketDest.Text = destination;
                lblTicketDate.Text = string.IsNullOrEmpty(travelDate) ? DateTime.Now.AddDays(7).ToString("dd MMM yyyy") : travelDate;
                lblTicketGuests.Text = guests;
                lblTicketMode.Text = travelMode;

                lblBannerTraveler.Text = bookerName;
                lblBannerDate.Text = lblTicketDate.Text;
                lblBannerPackage.Text = travelMode;

                List<BookedTripModel> userTrips = Session["UserTrips"] as List<BookedTripModel>;
                if (userTrips == null) userTrips = new List<BookedTripModel>();

                userTrips.Add(new BookedTripModel
                {
                    BookingId = bookingId,
                    PrimaryTraveler = bookerName,
                    Destination = destination,
                    TravelDate = lblTicketDate.Text,
                    Guests = guests,
                    PackageType = travelMode,
                    PhoneNumber = phoneNo,
                    AmountPaid = totalCost,
                    BookingDate = DateTime.Now
                });

                Session["UserTrips"] = userTrips;
                lblSmsStatus.Text = $"Trip confirmed for {bookerName}! Amount Paid: {totalCost} (Booking ID: {bookingId})";

                pnlBookingSuccess.Visible = true;
                pnlTicketSummary.Visible = true;
                pnlBookedSummaryBanner.Visible = true;

                GenerateStructuredItinerary();
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowBookingModal", "openBookingModal();", true);
            }
        }

        protected void btnExploreNeighbor_Click(object sender, EventArgs e)
        {
            string neighborState = ViewState["NearestNeighborState"]?.ToString();
            if (!string.IsNullOrEmpty(neighborState))
            {
                SetStateDropdownValue(neighborState);
                GenerateStructuredItinerary();
            }
        }

        private void GenerateStructuredItinerary()
        {
            string destinationState = ddlState.SelectedValue;
            int totalDays = Convert.ToInt32(ddlDuration.SelectedValue);
            string travelerVibe = ddlTravelerType.SelectedValue;

            lblResultDestination.Text = destinationState;
            lblResultMeta.Text = $"{totalDays} Days • {travelerVibe} Holiday Package • Verified Itinerary";

            NeighborStateInfo neighbor = GetNearestNeighboringState(destinationState);
            lblCurrentSelectedState.Text = destinationState;
            lblNearestStateName.Text = neighbor.StateName;
            lblNearestStateDistance.Text = neighbor.DistanceDetail;
            ViewState["NearestNeighborState"] = neighbor.StateName;
            pnlNeighborState.Visible = true;

            List<DayItinerary> itinerary = GetComprehensiveStateItinerary(destinationState, totalDays, travelerVibe);
            ApplyUserInterestFilters(itinerary);

            rptDays.DataSource = itinerary;
            rptDays.DataBind();

            pnlItinerary.Visible = true;
        }

        private NeighborStateInfo GetNearestNeighboringState(string state)
        {
            string lower = state.ToLower();
            if (lower.Contains("delhi")) return new NeighborStateInfo { StateName = "Rajasthan (Jaipur)", DistanceDetail = "Connected via Expressway • 3 hrs" };
            if (lower.Contains("goa")) return new NeighborStateInfo { StateName = "Maharashtra", DistanceDetail = "Borders North Goa • 2 hrs drive" };
            if (lower.Contains("kerala")) return new NeighborStateInfo { StateName = "Tamil Nadu", DistanceDetail = "Borders Munnar • 3 hrs drive" };
            if (lower.Contains("rajasthan")) return new NeighborStateInfo { StateName = "Gujarat", DistanceDetail = "Direct highway connection" };
            if (lower.Contains("himachal")) return new NeighborStateInfo { StateName = "Uttarakhand", DistanceDetail = "Scenic mountain highway" };
            if (lower.Contains("uttarakhand")) return new NeighborStateInfo { StateName = "Himachal Pradesh", DistanceDetail = "Connected via Dehradun route" };
            if (lower.Contains("ladakh")) return new NeighborStateInfo { StateName = "Himachal Pradesh", DistanceDetail = "Connected via Manali-Leh Highway" };
            if (lower.Contains("uttar pradesh")) return new NeighborStateInfo { StateName = "Madhya Pradesh", DistanceDetail = "Direct rail connection" };
            if (lower.Contains("karnataka")) return new NeighborStateInfo { StateName = "Goa", DistanceDetail = "Coastal highway connection" };
            if (lower.Contains("maharashtra")) return new NeighborStateInfo { StateName = "Goa", DistanceDetail = "Konkan highway connection" };
            if (lower.Contains("tamil nadu")) return new NeighborStateInfo { StateName = "Kerala", DistanceDetail = "Border connection via Western Ghats" };

            return new NeighborStateInfo { StateName = "Neighboring State", DistanceDetail = "Accessible via highway" };
        }

        private List<DayItinerary> GetComprehensiveStateItinerary(string state, int days, string vibe)
        {
            string lower = state.ToLower();

            if (lower.Contains("delhi")) return BuildMultiDayDelhi(days, vibe);
            if (lower.Contains("goa")) return BuildMultiDayGoa(days, vibe);
            if (lower.Contains("kerala")) return BuildMultiDayKerala(days, vibe);
            if (lower.Contains("rajasthan")) return BuildMultiDayRajasthan(days, vibe);
            if (lower.Contains("himachal")) return BuildMultiDayHimachal(days, vibe);
            if (lower.Contains("uttarakhand")) return BuildMultiDayUttarakhand(days, vibe);
            if (lower.Contains("ladakh")) return BuildMultiDayLadakh(days, vibe);
            if (lower.Contains("uttar pradesh")) return BuildMultiDayUttarPradesh(days, vibe);
            if (lower.Contains("karnataka")) return BuildMultiDayKarnataka(days, vibe);
            if (lower.Contains("maharashtra")) return BuildMultiDayMaharashtra(days, vibe);
            if (lower.Contains("tamil nadu")) return BuildMultiDayTamilNadu(days, vibe);
            if (lower.Contains("punjab")) return BuildMultiDayPunjab(days, vibe);
            if (lower.Contains("gujarat")) return BuildMultiDayGujarat(days, vibe);
            if (lower.Contains("madhya pradesh")) return BuildMultiDayMadhyaPradesh(days, vibe);
            if (lower.Contains("bihar")) return BuildMultiDayBihar(days, vibe);
            if (lower.Contains("west bengal")) return BuildMultiDayWestBengal(days, vibe);
            if (lower.Contains("odisha")) return BuildMultiDayOdisha(days, vibe);
            if (lower.Contains("andhra pradesh")) return BuildMultiDayAndhraPradesh(days, vibe);
            if (lower.Contains("telangana")) return BuildMultiDayTelangana(days, vibe);
            if (lower.Contains("assam")) return BuildMultiDayAssam(days, vibe);
            if (lower.Contains("meghalaya")) return BuildMultiDayMeghalaya(days, vibe);
            if (lower.Contains("sikkim")) return BuildMultiDaySikkim(days, vibe);
            if (lower.Contains("jammu and kashmir")) return BuildMultiDayJK(days, vibe);

            return BuildDynamicStateItinerary(days, vibe, state);
        }

        private void ApplyUserInterestFilters(List<DayItinerary> itinerary)
        {
            bool wantFood = chkFood.Checked;
            bool wantShopping = chkShopping.Checked;
            bool wantNightlife = chkNightlife.Checked;
            bool wantNature = chkNature.Checked;
            bool wantHistory = chkHistory.Checked;

            int dayIndex = 0;
            foreach (var day in itinerary)
            {
                dayIndex++;
                if (wantFood)
                {
                    day.Activities.Add(new ActivityItem { TimeOfDay = "Evening Snack", Title = "Local Street Food Hub & Sweet Stalls", Description = "Sample iconic regional street delicacies, hot jalebis, and authentic local snacks.", IsRecommended = true, MapSearchQuery = $"{day.CityName} Street Food Market" });
                }
                if (wantShopping && dayIndex % 2 != 0)
                {
                    day.Activities.Add(new ActivityItem { TimeOfDay = "Afternoon", Title = "Traditional Artisan Bazaar", Description = "Explore bustling local markets for handlooms, traditional artifacts, and specialty souvenirs.", IsRecommended = false, MapSearchQuery = $"{day.CityName} Handicraft Market" });
                }
                if (wantNightlife && (dayIndex == 2 || dayIndex == 4))
                {
                    day.Activities.Add(new ActivityItem { TimeOfDay = "Night", Title = "Popular Music Lounge & Nightlife", Description = "Experience vibrant evening culture at top-rated local nightspots, lounges, and live music bars.", IsRecommended = true, MapSearchQuery = $"{day.CityName} Nightlife Lounge" });
                }
                if (wantNature && dayIndex == 3)
                {
                    day.Activities.Add(new ActivityItem { TimeOfDay = "Morning", Title = "Scenic Valley Trail & Botanical Park", Description = "Immersive morning hike through protected regional parks, hills, or botanical pathways.", IsRecommended = true, MapSearchQuery = $"{day.CityName} Nature Reserve" });
                }
                if (wantHistory && dayIndex == 1)
                {
                    day.Activities.Add(new ActivityItem { TimeOfDay = "Afternoon", Title = "Ancient Temple & Archaeological Shrine", Description = "Guided walk through historic shrines, ancient stone carvings, and architectural wonders.", IsRecommended = true, MapSearchQuery = $"{day.CityName} Heritage Temple" });
                }
            }
        }

        private string GetStateSpecificBanner(string state, int dayIndex)
        {
            string lowerState = state.ToLower();
            string[] urls;

            if (lowerState.Contains("goa"))
            {
                urls = new string[] {
                    "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800",
                    "https://images.unsplash.com/photo-1614082897286-a5d6a099f8f6?w=800",
                    "https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=800",
                    "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800"
                };
            }
            else if (lowerState.Contains("kerala"))
            {
                urls = new string[] {
                    "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=800",
                    "https://images.unsplash.com/photo-1593693397690-362cb9666fc2?w=800",
                    "https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=800",
                    "https://images.unsplash.com/photo-1584467735811-62848fcb256a?w=800"
                };
            }
            else if (lowerState.Contains("rajasthan"))
            {
                urls = new string[] {
                    "https://images.unsplash.com/photo-1599661046289-e31897846e41?w=800",
                    "https://images.unsplash.com/photo-1564507592333-c60657eea523?w=800",
                    "https://images.unsplash.com/photo-1589308078059-be1415eab4c3?w=800",
                    "https://images.unsplash.com/photo-1617854818583-09e7f077a156?w=800"
                };
            }
            else if (lowerState.Contains("himachal") || lowerState.Contains("uttarakhand") || lowerState.Contains("ladakh") || lowerState.Contains("jammu"))
            {
                urls = new string[] {
                    "https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=800",
                    "https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=800",
                    "https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=800",
                    "https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?w=800"
                };
            }
            else if (lowerState.Contains("uttar pradesh"))
            {
                urls = new string[] {
                    "https://images.unsplash.com/photo-1564507592333-c60657eea523?w=800",
                    "https://images.unsplash.com/photo-1561361513-2d000a50f0dc?w=800",
                    "https://images.unsplash.com/photo-1599661046289-e31897846e41?w=800",
                    "https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?w=800"
                };
            }
            else
            {
                urls = new string[] {
                    "https://images.unsplash.com/photo-1587474260584-136574528ed5?w=800",
                    "https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?w=800",
                    "https://images.unsplash.com/photo-1548013146-72479768bada?w=800",
                    "https://images.unsplash.com/photo-1570168007204-dfb528c6958f?w=800"
                };
            }

            return urls[(dayIndex - 1) % urls.Length];
        }

        private List<DayItinerary> BuildMultiDayDelhi(int days, string vibe)
        {
            var list = new List<DayItinerary>();
            string tip = GetVibeTip(vibe);
            int maxDays = Math.Min(days, 7);
            string[] cities = { "Old Delhi", "Mehrauli", "Central Delhi", "South Delhi", "New Delhi", "North Delhi", "NCR" };
            string[] themes = { "Mughal Forts & Bazaars", "Ancient Minarets & Tombs", "War Memorials & Lawns", "Spiritual Architecture", "Grand Temples & Culture", "Heritage Parks", "Departure" };

            for (int i = 0; i < maxDays; i++)
            {
                var day = new DayItinerary
                {
                    DayTitle = $"Day {i + 1}",
                    CityName = cities[i],
                    DayTheme = themes[i],
                    DayImageUrl = GetStateSpecificBanner("Delhi NCR", i + 1),
                    WeatherWidget = "🌤️ 28°C • Pleasant Sunny Weather (Best Time to Visit: Oct - Mar)",
                    Activities = new List<ActivityItem>()
                };

                if (i == 0)
                {
                    day.Activities.Add(new ActivityItem { TimeOfDay = "Morning", Title = "Red Fort (Lal Qila)", Description = $"Explore Shah Jahan's historic fortress. {tip}", IsRecommended = true, MapSearchQuery = "Red Fort Delhi" });
                    day.Activities.Add(new ActivityItem { TimeOfDay = "Afternoon", Title = "Karim's & Parathe Wali Gali", Description = "Savor legendary Mughal kebabs and stuffed parathas in Old Delhi.", IsRecommended = true, MapSearchQuery = "Karims Jama Masjid Delhi" });
                    day.Activities.Add(new ActivityItem { TimeOfDay = "Night", Title = "Connaught Place Social & Key Nightclub", Description = "Experience Delhi's premier nightlife and music venues.", IsRecommended = true, MapSearchQuery = "Connaught Place Delhi" });
                }
                else if (i == 1)
                {
                    day.Activities.Add(new ActivityItem { TimeOfDay = "Morning", Title = "Qutub Minar & Iron Pillar", Description = "Marvel at the world's tallest brick minaret.", IsRecommended = true, MapSearchQuery = "Qutub Minar Delhi" });
                    day.Activities.Add(new ActivityItem { TimeOfDay = "Evening", Title = "Humayun's Tomb", Description = "Stroll through symmetrical Mughal gardens.", IsRecommended = true, MapSearchQuery = "Humayuns Tomb Delhi" });
                }
                else if (i == 2)
                {
                    day.Activities.Add(new ActivityItem { TimeOfDay = "Morning", Title = "India Gate", Description = "Pay respects at the iconic war memorial lawns.", IsRecommended = true, MapSearchQuery = "India Gate Delhi" });
                    day.Activities.Add(new ActivityItem { TimeOfDay = "Evening", Title = "Gurudwara Bangla Sahib", Description = "Experience serene spiritual peace and the community kitchen.", IsRecommended = true, MapSearchQuery = "Gurudwara Bangla Sahib Delhi" });
                }
                else if (i == 3) { day.Activities.Add(new ActivityItem { TimeOfDay = "Morning", Title = "Lotus Temple", Description = "Serene meditation inside striking marble petals.", IsRecommended = true, MapSearchQuery = "Lotus Temple Delhi" }); }
                else if (i == 4) { day.Activities.Add(new ActivityItem { TimeOfDay = "Morning", Title = "Swaminarayan Akshardham Temple", Description = "Intricate stone carvings and musical fountain shows.", IsRecommended = true, MapSearchQuery = "Akshardham Temple Delhi" }); }
                else if (i == 5) { day.Activities.Add(new ActivityItem { TimeOfDay = "Morning", Title = "Lodhi Gardens & National Museum", Description = "Walk among ancient 15th-century historical tombs.", IsRecommended = true, MapSearchQuery = "Lodhi Gardens Delhi" }); }
                else { day.Activities.Add(new ActivityItem { TimeOfDay = "Morning", Title = "Hauz Khas Village & Departure", Description = "Boutique shopping, lake views, and cafe dining before departure.", IsRecommended = true, MapSearchQuery = "Hauz Khas Village Delhi" }); }

                list.Add(day);
            }
            return list;
        }

        private List<DayItinerary> BuildMultiDayGoa(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Goa", "Baga Beach Water Sports", "Basilica of Bom Jesus (Old Goa)", "Dudhsagar Waterfalls", "Tito's Lane Nightclub & Lounges");
        private List<DayItinerary> BuildMultiDayKerala(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Kerala", "Munnar Tea Hills", "Alleppey Backwater Houseboat", "Periyar Wildlife Sanctuary", "Padmanabhaswamy Temple");
        private List<DayItinerary> BuildMultiDayRajasthan(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Rajasthan", "Amer Fort & Hawa Mahal", "Udaipur City Palace & Pichola", "Mehrangarh Fort Jodhpur", "Thar Desert Camel Safari");
        private List<DayItinerary> BuildMultiDayHimachal(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Himachal Pradesh", "Shimla Mall Road & Ridge", "Manali Hadimba Temple", "Solang Valley Paragliding", "Dharamshala McLeod Ganj");
        private List<DayItinerary> BuildMultiDayUttarakhand(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Uttarakhand", "Rishikesh Laxman Jhula & Rafting", "Haridwar Har Ki Pauri Aarti", "Nainital Naini Lake Boating", "Jim Corbett Safari");
        private List<DayItinerary> BuildMultiDayLadakh(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Ladakh", "Pangong Tso Blue Lake", "Nubra Valley Sand Dunes", "Khardung La Pass", "Thiksey Monastery");

        private List<DayItinerary> BuildMultiDayUttarPradesh(int days, string vibe)
        {
            var list = new List<DayItinerary>();
            string tip = GetVibeTip(vibe);
            int maxDays = Math.Min(days, 7);
            string[] cities = { "Agra", "Varanasi", "Lucknow", "Ayodhya", "Mathura", "Prayagraj", "Sarnath" };
            string[] themes = { "Taj Mahal & Mughal Forts", "Ganges Ghats & Temples", "Nawabi Heritage & Food", "Ram Mandir Pilgrimage", "Krishna Janmabhoomi", "Triveni Sangam", "Buddhist Stupa" };

            for (int i = 0; i < maxDays; i++)
            {
                var day = new DayItinerary
                {
                    DayTitle = $"Day {i + 1}",
                    CityName = cities[i],
                    DayTheme = themes[i],
                    DayImageUrl = GetStateSpecificBanner("Uttar Pradesh", i + 1),
                    WeatherWidget = "☀️ 30°C • Warm Climate (Best Time to Visit: Oct - Mar)",
                    Activities = new List<ActivityItem>()
                };

                if (i == 0)
                {
                    day.Activities.Add(new ActivityItem { TimeOfDay = "Morning", Title = "Taj Mahal & Agra Fort (Agra)", Description = $"Marvel at the world-famous wonder of love and Mughal heritage. {tip}", IsRecommended = true, MapSearchQuery = "Taj Mahal Agra" });
                }
                else if (i == 1)
                {
                    day.Activities.Add(new ActivityItem { TimeOfDay = "Morning", Title = "Kashi Vishwanath Temple & Ganga Aarti (Varanasi)", Description = "Experience divine spiritual energy along the holy Ganges river ghats.", IsRecommended = true, MapSearchQuery = "Kashi Vishwanath Temple Varanasi" });
                }
                else if (i == 2)
                {
                    day.Activities.Add(new ActivityItem { TimeOfDay = "Evening", Title = "Tunday Kababi & Bara Imambara (Lucknow)", Description = "Taste world-famous Awadhi galouti kebabs and explore Nawabi architecture.", IsRecommended = true, MapSearchQuery = "Bara Imambara Lucknow" });
                }
                else if (i == 3)
                {
                    day.Activities.Add(new ActivityItem { TimeOfDay = "Morning", Title = "Ram Mandir Pilgrimage (Ayodhya)", Description = "Visit the newly consecrated grand temple complex.", IsRecommended = true, MapSearchQuery = "Ram Mandir Ayodhya" });
                }
                else
                {
                    day.Activities.Add(new ActivityItem { TimeOfDay = "Morning", Title = $"{cities[i]} Heritage & Cultural Tour", Description = $"Explore historical monuments and local culinary specialties in {cities[i]}.", IsRecommended = true, MapSearchQuery = $"{cities[i]} Uttar Pradesh" });
                }

                list.Add(day);
            }
            return list;
        }

        private List<DayItinerary> BuildMultiDayKarnataka(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Karnataka", "Mysore Palace", "Hampi UNESCO Boulder Ruins", "Coorg Coffee Hills", "Bengaluru Lalbagh");
        private List<DayItinerary> BuildMultiDayMaharashtra(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Maharashtra", "Gateway of India & Marine Drive", "Ajanta & Ellora Caves", "Siddhivinayak Temple Mumbai", "Bandra Rooftop Lounges");
        private List<DayItinerary> BuildMultiDayTamilNadu(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Tamil Nadu", "Meenakshi Amman Temple Madurai", "Marina Beach Chennai", "Ooty Nilgiri Mountain Train", "Brihadeeswara Temple Thanjavur");
        private List<DayItinerary> BuildMultiDayPunjab(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Punjab", "Golden Temple Amritsar", "Wagah Border Ceremony", "Jallianwala Bagh", "Chandigarh Rock Garden");
        private List<DayItinerary> BuildMultiDayGujarat(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Gujarat", "Statue of Unity Kevadia", "Somnath Temple", "Sabarmati Ashram", "Rann of Kutch Desert");
        private List<DayItinerary> BuildMultiDayMadhyaPradesh(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Madhya Pradesh", "Khajuraho Temples", "Bandhavgarh National Park", "Sanchi Stupa", "Gwalior Fort");
        private List<DayItinerary> BuildMultiDayBihar(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Bihar", "Mahabodhi Temple Bodh Gaya", "Nalanda University Ruins", "Patna Sahib Gurudwara", "Rajgir Hills");
        private List<DayItinerary> BuildMultiDayWestBengal(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "West Bengal", "Victoria Memorial Kolkata", "Darjeeling Himalayan Railway", "Sundarbans Tiger Reserve", "Howrah Bridge");
        private List<DayItinerary> BuildMultiDayOdisha(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Odisha", "Konark Sun Temple", "Puri Jagannath Temple", "Chilika Lake", "Lingaraja Temple");
        private List<DayItinerary> BuildMultiDayAndhraPradesh(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Andhra Pradesh", "Tirumala Venkateswara Temple", "Araku Valley", "Visakhapatnam Beach", "Belum Caves");
        private List<DayItinerary> BuildMultiDayTelangana(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Telangana", "Charminar Hyderabad", "Golconda Fort", "Hussain Sagar Lake", "Ramappa Temple");
        private List<DayItinerary> BuildMultiDayAssam(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Assam", "Kaziranga National Park", "Kamakhya Temple Guwahati", "Majuli Island", "Tea Gardens");
        private List<DayItinerary> BuildMultiDayMeghalaya(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Meghalaya", "Living Root Bridges", "Dawki River", "Shillong Peak", "Nohkalikai Falls");
        private List<DayItinerary> BuildMultiDaySikkim(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Sikkim", "Tsomgo Lake", "Nathula Pass", "Gangtok MG Road", "Yumthang Valley");
        private List<DayItinerary> BuildMultiDayJK(int days, string vibe) => BuildDetailedStateItinerary(days, vibe, "Jammu and Kashmir", "Dal Lake Shikara Ride", "Gulmarg Gondola", "Pahalgam Valley", "Vaishno Devi Temple");

        private List<DayItinerary> BuildDetailedStateItinerary(int days, string vibe, string stateName, string a1, string a2, string a3, string a4)
        {
            var list = new List<DayItinerary>();
            string tip = GetVibeTip(vibe);
            int maxDays = Math.Min(days, 7);
            string[] attractions = { a1, a2, a3, a4, "Local Artisan Bazaar", "Scenic Mountain Viewpoint", "Cultural Heritage Landmark" };

            for (int i = 0; i < maxDays; i++)
            {
                var day = new DayItinerary
                {
                    DayTitle = $"Day {i + 1}",
                    CityName = stateName + $" Hub {i + 1}",
                    DayTheme = $"{vibe} Tour of {attractions[i % attractions.Length]}",
                    DayImageUrl = GetStateSpecificBanner(stateName, i + 1),
                    WeatherWidget = $"🌤️ 26°C • Ideal Climate Conditions (Best Time to Visit: Oct - Mar)",
                    Activities = new List<ActivityItem>
                    {
                        new ActivityItem
                        {
                            TimeOfDay = "Morning",
                            Title = attractions[i % attractions.Length],
                            Description = $"Explore the renowned landmark attraction in {stateName} tailored for {vibe.ToLower()} travelers. {tip}",
                            IsRecommended = true,
                            MapSearchQuery = $"{attractions[i % attractions.Length]} {stateName}"
                        }
                    }
                };
                list.Add(day);
            }
            return list;
        }

        private List<DayItinerary> BuildDynamicStateItinerary(int days, string vibe, string stateName)
        {
            return BuildDetailedStateItinerary(days, vibe, stateName, $"{stateName} Heritage Temple", $"{stateName} Nature Reserve", $"{stateName} Downtown Bazaar", $"{stateName} Nightlife Lounge");
        }

        private string GetVibeTip(string vibe)
        {
            switch (vibe.ToLower())
            {
                case "couple": return "Featuring romantic sunset viewpoints and cozy candlelit dining recommendations.";
                case "family": return "Optimized with kid-friendly pacing, engaging exhibits, and comfortable travel transfers.";
                case "solo": return "Tailored for safe exploration, great photography spots, and meeting fellow travelers.";
                case "friends": return "Packed with high-energy group activities, nightlife, and memorable selfie stops.";
                case "adventure": return "Loaded with outdoor adrenaline thrills, hiking trails, and extreme sports.";
                default: return "Customized for an exceptional vacation experience.";
            }
        }

        private void SetStateDropdownValue(string destName)
        {
            for (int i = 0; i < ddlState.Items.Count; i++)
            {
                if (ddlState.Items[i].Value.ToLower().Contains(destName.ToLower()))
                {
                    ddlState.SelectedIndex = i;
                    break;
                }
            }
        }
    }
}