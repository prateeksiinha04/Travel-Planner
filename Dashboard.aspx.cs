using System;
using System.Collections.Generic;
using System.Web.UI;

namespace AI_Travel_Planner
{
    public partial class Dashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardData();
            }
        }

        private void LoadDashboardData()
        {
            // 1. Load User Name safely from Session profile without falling back to a hardcoded personal name
            string userName = "Traveler";

            if (Session["UserProfile"] is Profile.UserProfileSettings userProfile && !string.IsNullOrEmpty(userProfile.UserName))
            {
                userName = userProfile.UserName;
            }
            else if (Session["UserName"] != null)
            {
                userName = Session["UserName"].ToString();
            }

            lblUserName.Text = userName;

            // 2. Load Metrics
            lblTripsPlanned.Text = "12";
            lblPlacesVisited.Text = "28";
            lblUpcomingTripsCount.Text = "3";
            lblTotalSaved.Text = "₹24,500";

            // 3. Load Upcoming Trips Repeater
            var upcomingTrips = new List<TripItem>
            {
                new TripItem
                {
                    ImageUrl = "https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=300",
                    Title = "Taj Mahal Heritage Tour",
                    Destination = "Agra",
                    Flag = "🇮🇳",
                    DateRange = "Oct 12 - Oct 15, 2026",
                    Details = "Agra, Uttar Pradesh • 4 Days",
                    Status = "Confirmed"
                },
                new TripItem
                {
                    ImageUrl = "https://images.unsplash.com/photo-1598091383028-de0ea0adc7d0?w=300",
                    Title = "Goa Beach Getaway",
                    Destination = "Goa",
                    Flag = "🇮🇳",
                    DateRange = "Nov 04 - Nov 08, 2026",
                    Details = "North Goa • 5 Days",
                    Status = "Upcoming"
                }
            };

            rptUpcomingTrips.DataSource = upcomingTrips;
            rptUpcomingTrips.DataBind();

            // 4. Load Recent Bookings Repeater
            var recentBookings = new List<BookingItem>
            {
                new BookingItem
                {
                    IconStyle = "background: #eff6ff; color: #2563eb;",
                    IconClass = "fa-solid fa-plane-departure",
                    Title = "Flight: New Delhi (DEL) to Jaipur (JAI)",
                    Subtitle = "Air India • Economy • Booked via App",
                    Status = "Booked"
                },
                new BookingItem
                {
                    IconStyle = "background: #f0fdf4; color: #16a34a;",
                    IconClass = "fa-solid fa-hotel",
                    Title = "Hotel: The Oberoi Amarvilas",
                    Subtitle = "Agra • Deluxe Room (2 Nights)",
                    Status = "Confirmed"
                }
            };

            rptRecentBookings.DataSource = recentBookings;
            rptRecentBookings.DataBind();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(query))
            {
                Response.Redirect($"~/TripPlanner.aspx?q={Server.UrlEncode(query)}");
            }
        }

        // View Models for Repeaters
        public class TripItem
        {
            public string ImageUrl { get; set; }
            public string Title { get; set; }
            public string Destination { get; set; }
            public string Flag { get; set; }
            public string DateRange { get; set; }
            public string Details { get; set; }
            public string Status { get; set; }
        }

        public class BookingItem
        {
            public string IconStyle { get; set; }
            public string IconClass { get; set; }
            public string Title { get; set; }
            public string Subtitle { get; set; }
            public string Status { get; set; }
        }
    }
}