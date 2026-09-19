using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AI_Travel_Planner
{
    public partial class MyTrips : Page
    {
        public class TripViewModel
        {
            public string TripId { get; set; }
            public string TripTitle { get; set; }
            public string Destination { get; set; }
            public string Dates { get; set; }
            public string Travelers { get; set; }
            public string Status { get; set; } // Upcoming, Active, Completed
            public string ImageUrl { get; set; }
            public string BookingType { get; set; }
            public string BookingDetails { get; set; }
            public string PnrCode { get; set; }
            public string EstimatedBudget { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitializeDefaultTrips();
                BindTrips("All");
            }
        }

        private void InitializeDefaultTrips()
        {
            if (Session["UserTrips"] == null)
            {
                List<TripPlanner.BookedTripModel> initialTrips = new List<TripPlanner.BookedTripModel>
                {
                    new TripPlanner.BookedTripModel
                    {
                        BookingId = "TRIP9901",
                        PrimaryTraveler = "John Doe",
                        Destination = "Delhi NCR",
                        TravelDate = "15 Aug 2026 - 20 Aug 2026",
                        Guests = "2",
                        PackageType = "Hotel + Sightseeing Pass",
                        PhoneNumber = "9876543210",
                        AmountPaid = "₹6,999",
                        BookingDate = DateTime.Now.AddDays(-2)
                    },
                    new TripPlanner.BookedTripModel
                    {
                        BookingId = "TRIP9902",
                        PrimaryTraveler = "John Doe",
                        Destination = "Goa",
                        TravelDate = "01 Jul 2026 - 05 Jul 2026",
                        Guests = "4",
                        PackageType = "Flight + Beach Shack Stay",
                        PhoneNumber = "9876543210",
                        AmountPaid = "₹14,999",
                        BookingDate = DateTime.Now.AddDays(-10)
                    }
                };

                Session["UserTrips"] = initialTrips;
            }
        }

        protected void Filter_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string category = btn.CommandArgument;

            btnFilterAll.CssClass = "tab-btn";
            btnFilterUpcoming.CssClass = "tab-btn";
            btnFilterActive.CssClass = "tab-btn";
            btnFilterCompleted.CssClass = "tab-btn";

            btn.CssClass = "tab-btn active";

            BindTrips(category);
        }

        private void BindTrips(string filterCategory)
        {
            List<TripViewModel> allTrips = GetCombinedUserTrips();

            if (!string.Equals(filterCategory, "All", StringComparison.OrdinalIgnoreCase))
            {
                allTrips = allTrips.Where(t => t.Status.Equals(filterCategory, StringComparison.OrdinalIgnoreCase)).ToList();
            }

            if (allTrips.Count > 0)
            {
                rptTrips.DataSource = allTrips;
                rptTrips.DataBind();
                pnlTripsGrid.Visible = true;
                pnlEmptyState.Visible = false;
            }
            else
            {
                pnlTripsGrid.Visible = false;
                pnlEmptyState.Visible = true;
            }
        }

        private List<TripViewModel> GetCombinedUserTrips()
        {
            List<TripViewModel> list = new List<TripViewModel>();

            // 1. Fetch from SQL Database Real-Time
            try
            {
                string connString = ConfigurationManager.ConnectionStrings["TravelPlannerDBConn"].ConnectionString;
                string query = "SELECT BookingId, TravelerName, Destination, TravelDate, GuestCount, PackageDetails, TotalPaid, PhoneNumber FROM UserBookings ORDER BY BookingId DESC";

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string bookingId = reader["BookingId"].ToString();
                                string dest = reader["Destination"].ToString();
                                string dateStr = reader["TravelDate"].ToString();
                                string guests = reader["GuestCount"].ToString();
                                string package = reader["PackageDetails"].ToString();
                                string phone = reader["PhoneNumber"].ToString();
                                string paid = "₹" + Convert.ToDecimal(reader["TotalPaid"]).ToString("N0");

                                list.Add(new TripViewModel
                                {
                                    TripId = "TRP-" + bookingId,
                                    TripTitle = "Trip to " + dest,
                                    Destination = dest,
                                    Dates = dateStr,
                                    Travelers = guests + " Guests",
                                    Status = "Upcoming",
                                    ImageUrl = GetImageForDestination(dest),
                                    BookingType = package,
                                    BookingDetails = "Confirmed Pass • Phone: " + phone,
                                    PnrCode = "TRP-" + bookingId,
                                    EstimatedBudget = paid
                                });
                            }
                        }
                    }
                }
            }
            catch (Exception)
            {
                // Fallback to Session if DB fetch fails
            }

            // 2. Fallback / Combine with Session Trips if any exist
            var sessionTrips = Session["UserTrips"] as List<TripPlanner.BookedTripModel>;
            if (sessionTrips != null && sessionTrips.Count > 0)
            {
                foreach (var b in sessionTrips)
                {
                    // Check if already added from DB to avoid duplicates
                    if (!list.Any(x => x.PnrCode == b.BookingId || x.PnrCode == "TRP-" + b.BookingId))
                    {
                        string status = "Upcoming";
                        if (b.BookingId == "TRIP9902") status = "Completed";

                        list.Add(new TripViewModel
                        {
                            TripId = b.BookingId,
                            TripTitle = "Trip to " + b.Destination,
                            Destination = b.Destination,
                            Dates = b.TravelDate,
                            Travelers = b.Guests + " Guests",
                            Status = status,
                            ImageUrl = GetImageForDestination(b.Destination),
                            BookingType = b.PackageType,
                            BookingDetails = "Confirmed Pass • Phone: " + b.PhoneNumber,
                            PnrCode = b.BookingId,
                            EstimatedBudget = b.AmountPaid
                        });
                    }
                }
            }

            return list;
        }

        private string GetImageForDestination(string destination)
        {
            string destLower = destination.ToLower();
            if (destLower.Contains("delhi")) return "https://images.unsplash.com/photo-1587474260584-136574528ed5?w=600";
            if (destLower.Contains("goa")) return "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=600";
            if (destLower.Contains("kerala")) return "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=600";
            if (destLower.Contains("rajasthan")) return "https://images.unsplash.com/photo-1599661046289-e31897846e41?w=600";
            if (destLower.Contains("himachal")) return "https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=600";

            return "https://images.unsplash.com/photo-1561361513-2d000a50f0dc?w=600";
        }

        protected string GetStatusBadgeCss(string status)
        {
            switch (status.ToLower())
            {
                case "upcoming": return "trip-status-badge status-upcoming";
                case "active": return "trip-status-badge status-active";
                case "completed": return "trip-status-badge status-completed";
                default: return "trip-status-badge status-upcoming";
            }
        }

        // CONFIRM DELETE CLICKED FROM CUSTOM POPUP MODAL (DATABASE + SESSION DELETE)
        protected void btnConfirmDeleteServer_Click(object sender, EventArgs e)
        {
            string tripIdToDelete = hfDeleteTripId.Value;

            if (!string.IsNullOrEmpty(tripIdToDelete))
            {
                // 1. Remove from SQL Database
                try
                {
                    string connString = ConfigurationManager.ConnectionStrings["TravelPlannerDBConn"].ConnectionString;
                    string cleanId = tripIdToDelete.Replace("TRP-", "");

                    string query = "DELETE FROM UserBookings WHERE BookingId = @Id OR BookingId = @CleanId OR CAST(BookingId AS NVARCHAR) = @CleanId";

                    using (SqlConnection conn = new SqlConnection(connString))
                    {
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@Id", tripIdToDelete);
                            cmd.Parameters.AddWithValue("@CleanId", cleanId);

                            conn.Open();
                            cmd.ExecuteNonQuery();
                            conn.Close();
                        }
                    }
                }
                catch (Exception)
                {
                    // Handle or log deletion error if needed
                }

                // 2. Remove from Trips Session
                var sessionTrips = Session["UserTrips"] as List<TripPlanner.BookedTripModel>;
                if (sessionTrips != null)
                {
                    sessionTrips.RemoveAll(t => string.Equals(t.BookingId, tripIdToDelete, StringComparison.OrdinalIgnoreCase) ||
                                               string.Equals("TRP-" + t.BookingId, tripIdToDelete, StringComparison.OrdinalIgnoreCase) ||
                                               string.Equals(t.BookingId.Replace("TRP-", ""), tripIdToDelete.Replace("TRP-", ""), StringComparison.OrdinalIgnoreCase));
                    Session["UserTrips"] = sessionTrips;
                }

                hfDeleteTripId.Value = "";
                BindTrips("All");
            }
        }
    }
}