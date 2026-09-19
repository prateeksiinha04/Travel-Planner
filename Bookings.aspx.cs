using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AI_Travel_Planner
{
    public partial class Bookings : Page
    {
        [Serializable]
        public class BookingItem
        {
            public string Category { get; set; }
            public string Title { get; set; }
            public string BookingRef { get; set; }
            public string Status { get; set; }
            public string BookingDate { get; set; }
            public string Provider { get; set; }
            public string GuestDetails { get; set; }
            public string Price { get; set; }
            public string IconClass { get; set; }
            public string IconStyle { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserBookings"] == null)
                {
                    Session["UserBookings"] = GetInitialBookings();
                }

                BindBookingsData("All");
            }
        }

        private string GetActiveFilterCategory()
        {
            if (btnFilterFlights.CssClass.Contains("active")) return "Flight";
            if (btnFilterHotels.CssClass.Contains("active")) return "Hotel";
            if (btnFilterTransfers.CssClass.Contains("active")) return "Transfer";
            return "All";
        }

        private void BindBookingsData(string filterCategory)
        {
            List<BookingItem> allBookings = Session["UserBookings"] as List<BookingItem> ?? new List<BookingItem>();

            List<BookingItem> filteredList = filterCategory == "All"
                ? allBookings
                : allBookings.Where(b => b.Category.Equals(filterCategory, StringComparison.OrdinalIgnoreCase)).ToList();

            if (filteredList.Count > 0)
            {
                rptBookings.DataSource = filteredList;
                rptBookings.DataBind();
                rptBookings.Visible = true;
                pnlEmptyState.Visible = false;
            }
            else
            {
                rptBookings.Visible = false;
                pnlEmptyState.Visible = true;
            }
        }

        protected void Filter_Click(object sender, EventArgs e)
        {
            var clickedBtn = (LinkButton)sender;
            string category = clickedBtn.CommandArgument;

            btnFilterAll.CssClass = "tab-btn";
            btnFilterFlights.CssClass = "tab-btn";
            btnFilterHotels.CssClass = "tab-btn";
            btnFilterTransfers.CssClass = "tab-btn";

            clickedBtn.CssClass = "tab-btn active";

            BindBookingsData(category);
        }

        protected void btnSaveBooking_Click(object sender, EventArgs e)
        {
            string category = ddlCategory.SelectedValue;
            string source = txtSource.Text.Trim();
            string destination = txtDestination.Text.Trim();
            string rawDate = txtDate.Text.Trim();
            string provider = txtProvider.Text.Trim();
            string price = txtPrice.Text.Trim();

            // Validate that destination/title is provided
            if (string.IsNullOrEmpty(destination) && string.IsNullOrEmpty(source))
            {
                return;
            }

            // Automatically format the title from Source → Destination
            string title = string.IsNullOrEmpty(source) ? destination : $"{source} → {destination}";

            if (category == "Hotel" && !string.IsNullOrEmpty(destination))
            {
                title = destination.StartsWith("Hotel", StringComparison.OrdinalIgnoreCase) ? destination : $"Stay at {destination}";
            }

            // Format date if selected via HTML5 datepicker
            string formattedDate = DateTime.Now.ToString("dd MMM yyyy");
            if (DateTime.TryParse(rawDate, out DateTime parsedDate))
            {
                formattedDate = parsedDate.ToString("dd MMM yyyy");
            }

            // Set styling icon based on booking type
            string iconClass = "fa-solid fa-plane";
            string iconStyle = "background:#eff6ff; color:#2563eb;";

            if (category == "Hotel")
            {
                iconClass = "fa-solid fa-hotel";
                iconStyle = "background:#f0fdf4; color:#16a34a;";
            }
            else if (category == "Transfer")
            {
                iconClass = "fa-solid fa-car";
                iconStyle = "background:#faf5ff; color:#9333ea;";
            }

            // Create new entry
            var newBooking = new BookingItem
            {
                Category = category,
                Title = title,
                BookingRef = "Ref: #BOOK-" + new Random().Next(10000, 99999),
                Status = "Confirmed",
                BookingDate = formattedDate,
                Provider = string.IsNullOrEmpty(provider) ? "Direct Booking" : provider,
                GuestDetails = "1 - 2 Guests",
                Price = string.IsNullOrEmpty(price) ? "₹0" : (price.StartsWith("₹") ? price : "₹" + price),
                IconClass = iconClass,
                IconStyle = iconStyle
            };

            // Prepend new booking to top of session list
            List<BookingItem> currentBookings = Session["UserBookings"] as List<BookingItem> ?? new List<BookingItem>();
            currentBookings.Insert(0, newBooking);
            Session["UserBookings"] = currentBookings;

            // Clear inputs
            txtSource.Text = "";
            txtDestination.Text = "";
            txtDate.Text = "";
            txtProvider.Text = "";
            txtPrice.Text = "";

            // Refresh view keeping the current active filter tab selected
            string activeFilter = GetActiveFilterCategory();
            BindBookingsData(activeFilter);
        }

        protected string GetStatusBadgeCss(string status)
        {
            switch (status.ToLower())
            {
                case "confirmed":
                    return "badge-status badge-confirmed";
                case "pending":
                    return "badge-status badge-pending";
                case "cancelled":
                    return "badge-status badge-cancelled";
                default:
                    return "badge-status badge-confirmed";
            }
        }

        private List<BookingItem> GetInitialBookings()
        {
            return new List<BookingItem>
            {
                new BookingItem
                {
                    Category = "Flight",
                    Title = "Delhi (DEL), Delhi NCR → Mumbai (BOM), Maharashtra",
                    BookingRef = "Ref: #6E-48210",
                    Status = "Confirmed",
                    BookingDate = "15 Oct 2026",
                    Provider = "IndiGo (6E-642)",
                    GuestDetails = "1 Passenger (Economy)",
                    Price = "₹5,400",
                    IconClass = "fa-solid fa-plane",
                    IconStyle = "background:#eff6ff; color:#2563eb;"
                },
                new BookingItem
                {
                    Category = "Hotel",
                    Title = "Stay at The Taj Mahal Palace",
                    BookingRef = "Ref: #TAJ-90214",
                    Status = "Confirmed",
                    BookingDate = "15 Oct 2026",
                    Provider = "Mumbai, Maharashtra",
                    GuestDetails = "Luxury Room • 2 Guests",
                    Price = "₹18,500",
                    IconClass = "fa-solid fa-hotel",
                    IconStyle = "background:#f0fdf4; color:#16a34a;"
                }
            };
        }
    }
}