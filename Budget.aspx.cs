using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AI_Travel_Planner
{
    public partial class Budget : Page
    {
        public class ExpenseModel
        {
            public string Id { get; set; }
            public string Title { get; set; }
            public string Category { get; set; }
            public decimal Amount { get; set; }
            public string FormattedAmount => "₹" + Amount.ToString("N0");
            public string ExpenseDate { get; set; }
            public string PaymentMethod { get; set; }
            public string IconClass { get; set; }
            public string IconStyle { get; set; }
        }

        public class DealModel
        {
            public string Title { get; set; }
            public string Location { get; set; }
            public string Price { get; set; }
            public string ImageUrl { get; set; }
            public string DiscountTag { get; set; }
            public string Inclusions { get; set; }
            public string DestinationQuery { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitializeExpensesSession();
                SyncLatestBookingsToExpenses();

                decimal totalBudget = GetCurrentBudget();
                txtCustomBudget.Text = totalBudget.ToString("F0");

                BindBudgetData("All");
                BindDealsForBudget(totalBudget);
            }
        }

        protected void btnUpdateBudget_Click(object sender, EventArgs e)
        {
            if (decimal.TryParse(txtCustomBudget.Text.Trim(), out decimal newBudget) && newBudget > 0)
            {
                Session["UserTotalBudget"] = newBudget;
                BindBudgetData("All");
                BindDealsForBudget(newBudget);
            }
        }

        private decimal GetCurrentBudget()
        {
            if (Session["UserTotalBudget"] != null)
            {
                return Convert.ToDecimal(Session["UserTotalBudget"]);
            }
            return 50000m; // Default ₹50,000
        }

        private void InitializeExpensesSession()
        {
            if (Session["UserExpenses"] == null)
            {
                List<ExpenseModel> initialExpenses = new List<ExpenseModel>
                {
                    CreateExpenseObject("EXP101", "Indigo Flight Ticket", "Flight", 4999m, "2026-08-01", "Card"),
                    CreateExpenseObject("EXP102", "Heritage Hotel Booking", "Stay", 3499m, "2026-08-02", "UPI"),
                    CreateExpenseObject("EXP103", "Street Food Tour", "Food", 850m, "2026-08-02", "Cash")
                };

                Session["UserExpenses"] = initialExpenses;
            }
        }

        private void SyncLatestBookingsToExpenses()
        {
            var userExpenses = Session["UserExpenses"] as List<ExpenseModel> ?? new List<ExpenseModel>();
            var bookedTrips = Session["UserTrips"] as List<TripPlanner.BookedTripModel>;

            if (bookedTrips != null && bookedTrips.Count > 0)
            {
                foreach (var trip in bookedTrips)
                {
                    if (!userExpenses.Any(x => x.Id == trip.BookingId))
                    {
                        decimal parsedAmount = ExtractAmountFromText(trip.AmountPaid);

                        string cat = "Stay";
                        if (trip.PackageType.ToLower().Contains("flight")) cat = "Flight";
                        else if (trip.PackageType.ToLower().Contains("bus") || trip.PackageType.ToLower().Contains("train")) cat = "Transit";

                        userExpenses.Insert(0, CreateExpenseObject(
                            trip.BookingId,
                            $"Trip Booking: {trip.Destination} ({trip.Guests} Guests)",
                            cat,
                            parsedAmount,
                            string.IsNullOrEmpty(trip.TravelDate) ? DateTime.Now.ToString("dd MMM yyyy") : trip.TravelDate,
                            "UPI"
                        ));
                    }
                }

                Session["UserExpenses"] = userExpenses;
            }
        }

        protected void Filter_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string selectedCategory = btn.CommandArgument;

            btnFilterAll.CssClass = "tab-btn";
            btnFilterFlight.CssClass = "tab-btn";
            btnFilterStay.CssClass = "tab-btn";
            btnFilterFood.CssClass = "tab-btn";
            btnFilterActivities.CssClass = "tab-btn";
            btnFilterShopping.CssClass = "tab-btn";
            btnFilterTransit.CssClass = "tab-btn";

            btn.CssClass = "tab-btn active";

            BindBudgetData(selectedCategory);
        }

        private void BindBudgetData(string filterCategory)
        {
            List<ExpenseModel> allExpenses = Session["UserExpenses"] as List<ExpenseModel> ?? new List<ExpenseModel>();
            decimal totalBudget = GetCurrentBudget();

            List<ExpenseModel> filteredExpenses = allExpenses;
            if (!string.Equals(filterCategory, "All", StringComparison.OrdinalIgnoreCase))
            {
                filteredExpenses = allExpenses.Where(x => string.Equals(x.Category, filterCategory, StringComparison.OrdinalIgnoreCase)).ToList();
            }

            if (filteredExpenses.Count > 0)
            {
                rptExpenses.DataSource = filteredExpenses;
                rptExpenses.DataBind();
                rptExpenses.Visible = true;
                pnlEmptyState.Visible = false;
            }
            else
            {
                rptExpenses.Visible = false;
                pnlEmptyState.Visible = true;
            }

            decimal totalSpent = allExpenses.Sum(x => x.Amount);
            decimal remainingBudget = totalBudget - totalSpent;
            decimal dailyAvg = totalSpent / 5m;

            int percentageSpent = (int)Math.Min(100, Math.Round((totalSpent / totalBudget) * 100));

            lblTotalBudget.Text = "₹" + totalBudget.ToString("N0");
            lblTotalSpent.Text = "₹" + totalSpent.ToString("N0");
            lblRemaining.Text = "₹" + Math.Max(0, remainingBudget).ToString("N0");
            lblDailyAvg.Text = "₹" + dailyAvg.ToString("N0");
            lblProgressPercent.Text = percentageSpent + "%";

            pnlProgressBarFill.Style["width"] = percentageSpent + "%";
            if (percentageSpent >= 90)
                pnlProgressBarFill.Style["background-color"] = "#ef4444";
            else if (percentageSpent >= 70)
                pnlProgressBarFill.Style["background-color"] = "#f59e0b";
            else
                pnlProgressBarFill.Style["background-color"] = "#22c55e";
        }

        private void BindDealsForBudget(decimal budget)
        {
            lblDealCategory.Text = "Budget Range: ₹" + budget.ToString("N0");

            List<DealModel> deals = new List<DealModel>();

            if (budget <= 10000)
            {
                deals.Add(new DealModel
                {
                    Title = "Backpacker Hostel & Bus Pass",
                    Location = "Jaipur, Rajasthan",
                    Price = "₹1,499 / person",
                    ImageUrl = "https://images.unsplash.com/photo-1599661046289-e31897846e41?w=400",
                    DiscountTag = "30% OFF",
                    Inclusions = "Dorm Bed Stay, Sleeper Bus Voucher, Complimentary Chai & Breakfast, City Walking Map.",
                    DestinationQuery = "Rajasthan"
                });
                deals.Add(new DealModel
                {
                    Title = "Beach Shack & Scooter Rental",
                    Location = "Anjuna, Goa",
                    Price = "₹1,999 / night",
                    ImageUrl = "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=400",
                    DiscountTag = "Budget Pick",
                    Inclusions = "Beachfront Bamboo Shack, 24-hr Scooter Rental, Welcome Drink, Free Wi-Fi.",
                    DestinationQuery = "Goa"
                });
                deals.Add(new DealModel
                {
                    Title = "Riverside Camp Stay & Rafting",
                    Location = "Rishikesh, Uttarakhand",
                    Price = "₹1,250 / night",
                    ImageUrl = "https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?w=400",
                    DiscountTag = "Top Value",
                    Inclusions = "Riverside Tent Accommodation, 16km Ganga Rafting Session, Bonfire & Dinner.",
                    DestinationQuery = "Uttarakhand"
                });
            }
            else if (budget <= 30000)
            {
                deals.Add(new DealModel
                {
                    Title = "3★ Boutique Hotel + Breakfast",
                    Location = "South Delhi NCR",
                    Price = "₹3,499 / night",
                    ImageUrl = "https://images.unsplash.com/photo-1587474260584-136574528ed5?w=400",
                    DiscountTag = "Popular",
                    Inclusions = "Deluxe AC Room, Buffet Breakfast, Free Airport Pickup, Qutub Minar Entry Coupons.",
                    DestinationQuery = "Delhi NCR"
                });
                deals.Add(new DealModel
                {
                    Title = "Train + Heritage Haveli Stay",
                    Location = "Udaipur, Rajasthan",
                    Price = "₹4,999 / person",
                    ImageUrl = "https://images.unsplash.com/photo-1564507592333-c60657eea523?w=400",
                    DiscountTag = "Best Seller",
                    Inclusions = "Express Train Ticket (3AC), Lakeview Haveli Room, Sunset Pichola Boat Pass.",
                    DestinationQuery = "Rajasthan"
                });
                deals.Add(new DealModel
                {
                    Title = "Mountain View Cottage",
                    Location = "Manali, Himachal",
                    Price = "₹2,999 / night",
                    ImageUrl = "https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=400",
                    DiscountTag = "25% OFF",
                    Inclusions = "Wooden Pine Cottage, Breakfast & Dinner, Solang Valley Zipline Pass.",
                    DestinationQuery = "Himachal Pradesh"
                });
            }
            else
            {
                deals.Add(new DealModel
                {
                    Title = "Flight + 4★ Beach Resort Combo",
                    Location = "Panjim, Goa",
                    Price = "₹12,999 / package",
                    ImageUrl = "https://images.unsplash.com/photo-1548013146-72479768bada?w=400",
                    DiscountTag = "Luxury Deal",
                    Inclusions = "Return Flight Ticket, 4★ Pool Resort Stay, Mandovi River Sunset Dinner Cruise.",
                    DestinationQuery = "Goa"
                });
                deals.Add(new DealModel
                {
                    Title = "Private Backwater Houseboat",
                    Location = "Alleppey, Kerala",
                    Price = "₹8,499 / night",
                    ImageUrl = "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=400",
                    DiscountTag = "Inclusive",
                    Inclusions = "Full Private Houseboat Stay, Traditional Kerala Cuisine (All Meals), Canoe Ride.",
                    DestinationQuery = "Kerala"
                });
                deals.Add(new DealModel
                {
                    Title = "Royal Palace Hotel Stay",
                    Location = "Jaipur, Rajasthan",
                    Price = "₹9,999 / night",
                    ImageUrl = "https://images.unsplash.com/photo-1599661046289-e31897846e41?w=400",
                    DiscountTag = "5★ Experience",
                    Inclusions = "Heritage Suite Room, Cultural Folk Dance Dinner, Amber Fort Light Show Tickets.",
                    DestinationQuery = "Rajasthan"
                });
            }

            rptDeals.DataSource = deals;
            rptDeals.DataBind();
        }

        protected void btnSaveExpense_Click(object sender, EventArgs e)
        {
            string title = txtDescription.Text.Trim();
            string category = ddlCategory.SelectedValue;
            string amountText = txtAmount.Text.Trim();
            string dateText = txtDate.Text;
            string paymentMethod = ddlPaymentMethod.SelectedValue;

            if (!string.IsNullOrEmpty(title) && decimal.TryParse(amountText, out decimal amount))
            {
                List<ExpenseModel> expenses = Session["UserExpenses"] as List<ExpenseModel> ?? new List<ExpenseModel>();

                string newId = "EXP" + new Random().Next(1000, 9999);
                string formattedDate = string.IsNullOrEmpty(dateText) ? DateTime.Now.ToString("dd MMM yyyy") : DateTime.Parse(dateText).ToString("dd MMM yyyy");

                expenses.Insert(0, CreateExpenseObject(newId, title, category, amount, formattedDate, paymentMethod));

                Session["UserExpenses"] = expenses;

                txtDescription.Text = "";
                txtAmount.Text = "";
                txtDate.Text = "";

                BindBudgetData("All");
            }
        }

        protected void rptExpenses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteExpense")
            {
                string expenseId = e.CommandArgument.ToString();
                List<ExpenseModel> expenses = Session["UserExpenses"] as List<ExpenseModel>;

                if (expenses != null)
                {
                    expenses.RemoveAll(x => x.Id == expenseId);
                    Session["UserExpenses"] = expenses;
                    BindBudgetData("All");
                }
            }
        }

        private ExpenseModel CreateExpenseObject(string id, string title, string category, decimal amount, string date, string method)
        {
            var exp = new ExpenseModel
            {
                Id = id,
                Title = title,
                Category = category,
                Amount = amount,
                ExpenseDate = date,
                PaymentMethod = method
            };

            switch (category.ToLower())
            {
                case "flight":
                    exp.IconClass = "fa-solid fa-plane";
                    exp.IconStyle = "background-color: #eff6ff; color: #2563eb;";
                    break;
                case "stay":
                    exp.IconClass = "fa-solid fa-hotel";
                    exp.IconStyle = "background-color: #f0fdf4; color: #16a34a;";
                    break;
                case "food":
                    exp.IconClass = "fa-solid fa-utensils";
                    exp.IconStyle = "background-color: #fff7ed; color: #ea580c;";
                    break;
                case "activity":
                    exp.IconClass = "fa-solid fa-ticket";
                    exp.IconStyle = "background-color: #faf5ff; color: #9333ea;";
                    break;
                case "shopping":
                    exp.IconClass = "fa-solid fa-bag-shopping";
                    exp.IconStyle = "background-color: #fdf2f8; color: #db2777;";
                    break;
                case "transit":
                    exp.IconClass = "fa-solid fa-taxi";
                    exp.IconStyle = "background-color: #fefce8; color: #ca8a04;";
                    break;
                default:
                    exp.IconClass = "fa-solid fa-receipt";
                    exp.IconStyle = "background-color: #f1f5f9; color: #64748b;";
                    break;
            }

            return exp;
        }

        private decimal ExtractAmountFromText(string text)
        {
            if (string.IsNullOrEmpty(text)) return 1499m;
            string clean = new string(text.Where(char.IsDigit).ToArray());
            return decimal.TryParse(clean, out decimal res) ? res : 1499m;
        }
    }
}