using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AI_Travel_Planner
{
    public partial class SavedPlaces : Page
    {
        [Serializable]
        public class SavedPlaceItem
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string City { get; set; }
            public string Category { get; set; } // Attraction, Restaurant, Hotel, Beach
            public string Rating { get; set; }
            public string Notes { get; set; }
            public string ImageUrl { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserSavedPlaces"] == null)
                {
                    Session["UserSavedPlaces"] = GetInitialIndianPlaces();
                }

                ViewState["CurrentCategoryFilter"] = "All";
                BindPlacesView("All", string.Empty);
            }
        }

        private void BindPlacesView(string categoryFilter, string searchQuery)
        {
            List<SavedPlaceItem> places = Session["UserSavedPlaces"] as List<SavedPlaceItem> ?? new List<SavedPlaceItem>();

            // Category Filter
            if (!categoryFilter.Equals("All", StringComparison.OrdinalIgnoreCase))
            {
                places = places.Where(p => p.Category.Equals(categoryFilter, StringComparison.OrdinalIgnoreCase)).ToList();
            }

            // Search Query Filter
            if (!string.IsNullOrEmpty(searchQuery))
            {
                places = places.Where(p =>
                    p.Name.IndexOf(searchQuery, StringComparison.OrdinalIgnoreCase) >= 0 ||
                    p.City.IndexOf(searchQuery, StringComparison.OrdinalIgnoreCase) >= 0 ||
                    p.Category.IndexOf(searchQuery, StringComparison.OrdinalIgnoreCase) >= 0
                ).ToList();
            }

            if (places.Count > 0)
            {
                rptPlaces.DataSource = places;
                rptPlaces.DataBind();
                pnlPlacesGrid.Visible = true;
                pnlEmptyState.Visible = false;
            }
            else
            {
                pnlPlacesGrid.Visible = false;
                pnlEmptyState.Visible = true;
            }
        }

        // Search Button Click Handler
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearchDestination.Text.Trim();
            string category = ViewState["CurrentCategoryFilter"]?.ToString() ?? "All";
            BindPlacesView(category, query);
        }

        // Add Place Modal Click Handler
        protected void btnSavePlace_Click(object sender, EventArgs e)
        {
            string name = txtName.Text.Trim();
            string city = txtCity.Text.Trim();
            string category = ddlCategory.SelectedValue;
            string rating = txtRating.Text.Trim();
            string notes = txtNotes.Text.Trim();
            string imageUrl = txtImageUrl.Text.Trim();

            if (string.IsNullOrEmpty(name))
                return;

            if (string.IsNullOrEmpty(imageUrl))
            {
                imageUrl = GetFallbackImage(category, name);
            }

            var newPlace = new SavedPlaceItem
            {
                Id = new Random().Next(1000, 9999),
                Name = name,
                City = string.IsNullOrEmpty(city) ? "India" : city,
                Category = category,
                Rating = string.IsNullOrEmpty(rating) ? "4.8" : rating,
                Notes = string.IsNullOrEmpty(notes) ? "Top recommendation" : notes,
                ImageUrl = imageUrl
            };

            List<SavedPlaceItem> currentPlaces = Session["UserSavedPlaces"] as List<SavedPlaceItem> ?? new List<SavedPlaceItem>();
            currentPlaces.Insert(0, newPlace);
            Session["UserSavedPlaces"] = currentPlaces;

            txtName.Text = "";
            txtCity.Text = "";
            txtRating.Text = "";
            txtNotes.Text = "";
            txtImageUrl.Text = "";

            string currentFilter = ViewState["CurrentCategoryFilter"]?.ToString() ?? "All";
            BindPlacesView(currentFilter, txtSearchDestination.Text.Trim());
        }

        // Removed standard ItemCommand in favor of the custom Bootstrap modal click handler below
        // protected void rptPlaces_ItemCommand(object source, RepeaterCommandEventArgs e) { ... }

        // Custom Bootstrap Modal Delete Confirmation Handler
        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hfDeleteId.Value, out int placeId))
            {
                List<SavedPlaceItem> places = Session["UserSavedPlaces"] as List<SavedPlaceItem>;

                if (places != null)
                {
                    var itemToRemove = places.FirstOrDefault(p => p.Id == placeId);
                    if (itemToRemove != null)
                    {
                        places.Remove(itemToRemove);
                        Session["UserSavedPlaces"] = places;
                    }
                }

                string currentFilter = ViewState["CurrentCategoryFilter"]?.ToString() ?? "All";
                BindPlacesView(currentFilter, txtSearchDestination.Text.Trim());
            }
        }

        protected void Filter_Click(object sender, EventArgs e)
        {
            var clickedBtn = (LinkButton)sender;
            string category = clickedBtn.CommandArgument;

            btnFilterAll.CssClass = "tab-btn";
            btnFilterAttractions.CssClass = "tab-btn";
            btnFilterRestaurants.CssClass = "tab-btn";
            btnFilterHotels.CssClass = "tab-btn";
            btnFilterBeaches.CssClass = "tab-btn";

            clickedBtn.CssClass = "tab-btn active";
            ViewState["CurrentCategoryFilter"] = category;

            BindPlacesView(category, txtSearchDestination.Text.Trim());
        }

        private string GetFallbackImage(string category, string name = "")
        {
            string lowerName = name.ToLower();
            if (lowerName.Contains("taj mahal"))
                return "https://images.unsplash.com/photo-1564507592333-c60657eea523?w=600";
            if (lowerName.Contains("goa") || lowerName.Contains("beach"))
                return "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=600";
            if (lowerName.Contains("jaipur") || lowerName.Contains("fort"))
                return "https://images.unsplash.com/photo-1599661046289-e31897846e41?w=600";
            if (lowerName.Contains("kerala"))
                return "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=600";

            switch (category.ToLower())
            {
                case "attraction": return "https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=600";
                case "restaurant": return "https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=600";
                case "hotel": return "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=600";
                case "beach": return "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600";
                default: return "https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=600";
            }
        }

        private List<SavedPlaceItem> GetInitialIndianPlaces()
        {
            return new List<SavedPlaceItem>
            {
                new SavedPlaceItem
                {
                    Id = 1,
                    Name = "Taj Mahal",
                    City = "Agra, Uttar Pradesh",
                    Category = "Attraction",
                    Rating = "4.9",
                    Notes = "Sunrise entry gives best photos",
                    ImageUrl = "https://images.unsplash.com/photo-1564507592333-c60657eea523?w=600"
                },
                new SavedPlaceItem
                {
                    Id = 2,
                    Name = "Palolem & Baga Beaches",
                    City = "Goa",
                    Category = "Beach",
                    Rating = "4.8",
                    Notes = "Sunset shacks & water sports",
                    ImageUrl = "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=600"
                },
                new SavedPlaceItem
                {
                    Id = 3,
                    Name = "Amber Palace & Fort",
                    City = "Jaipur, Rajasthan",
                    Category = "Attraction",
                    Rating = "4.8",
                    Notes = "Magnificent hilltop palace",
                    ImageUrl = "https://images.unsplash.com/photo-1599661046289-e31897846e41?w=600"
                },
                new SavedPlaceItem
                {
                    Id = 4,
                    Name = "Taj Lake Palace",
                    City = "Udaipur, Rajasthan",
                    Category = "Hotel",
                    Rating = "4.9",
                    Notes = "Luxury heritage stay in Lake Pichola",
                    ImageUrl = "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=600"
                }
            };
        }
    }
}