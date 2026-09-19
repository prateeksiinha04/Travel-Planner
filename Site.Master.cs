using System;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.Security;
using System.Web.UI;

namespace AI_Travel_Planner
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 1. Retrieve logged-in user's display name
                string currentUser = Session["UserName"] != null ? Session["UserName"].ToString() : "Traveler";
                if (lblMasterUserName != null)
                {
                    lblMasterUserName.Text = currentUser;
                }

                // 2. Retrieve logged-in user's profile photo
                string currentAvatar = Session["UserProfilePic"] != null
                    ? Session["UserProfilePic"].ToString()
                    : "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150";

                if (imgMasterProfilePic != null)
                {
                    imgMasterProfilePic.ImageUrl = currentAvatar;
                }

                Page.DataBind();
            }
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetChatResponse(string userPrompt)
        {
            if (string.IsNullOrWhiteSpace(userPrompt))
            {
                return "Please enter a valid question or travel query.";
            }

            string text = userPrompt.ToLower().Trim();

            if (ContainsAny(text, "hi", "hello", "hey", "hola", "start"))
            {
                return "👋 Hello! I am your AI Travel Assistant. Ask me about destinations (Taj Mahal, Goa, Jaipur, Udaipur, Paris, Bali), packing tips, flight savings, or budget advice!";
            }
            if (ContainsAny(text, "who are you", "what can you do", "help"))
            {
                return "🤖 I can help you with travel recommendations, flight hacks, packing advice, and finding top places to visit! Which destination are you planning to visit?";
            }

            if (ContainsAny(text, "taj mahal", "agra"))
            {
                return "🕌 **Taj Mahal Highlights**: Visit at sunrise for fewer crowds and great lighting! Combine with Agra Fort and Mehtab Bagh for stunning photos across the Yamuna River.";
            }
            if (ContainsAny(text, "goa", "beach"))
            {
                return "🏖️ **Goa Highlights**: North Goa (Baga, Calangute, Anjuna) is famous for water sports and nightlife. South Goa (Palolem, Agonda) offers serene beaches and relaxed shacks!";
            }
            if (ContainsAny(text, "jaipur", "rajasthan"))
            {
                return "🏰 **Jaipur Highlights**: Explore Amber Fort, photograph the honeycomb facade of Hawa Mahal, and enjoy Rajasthani thali at Chokhi Dhani.";
            }
            if (ContainsAny(text, "udaipur"))
            {
                return "⛵ **Udaipur Highlights**: Take a sunset boat ride on Lake Pichola, tour the grandeur of City Palace, and visit Jagdish Temple.";
            }

            if (ContainsAny(text, "pack", "packing", "luggage", "bag"))
            {
                return "🧳 **Packing Hack**: Roll your clothes instead of folding to save 30% space and reduce wrinkles! Always keep a power bank and medication in your carry-on.";
            }
            if (ContainsAny(text, "flight", "plane", "ticket", "cheaper"))
            {
                return "✈️ **Flight Savings**: Tuesdays and Wednesdays are statistically 15-20% cheaper to fly. Booking 3-6 weeks in advance yields the best prices.";
            }

            return "✨ That sounds like a wonderful trip idea! Use the **AI Trip Planner** tab in the sidebar to generate a complete custom itinerary, or ask me about packing, flights, or cities like Goa, Jaipur, or Agra.";
        }

        private static bool ContainsAny(string source, params string[] keywords)
        {
            return keywords.Any(keyword => Regex.IsMatch(source, @"\b" + Regex.Escape(keyword) + @"\b", RegexOptions.IgnoreCase));
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            if (Request.Cookies[FormsAuthentication.FormsCookieName] != null)
            {
                HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, "");
                authCookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(authCookie);
            }

            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                HttpCookie sessionCookie = new HttpCookie("ASP.NET_SessionId", "");
                sessionCookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(sessionCookie);
            }

            Response.Redirect("Login.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected string GetActiveCssClass(string pageName)
        {
            string currentPage = Request.Url.AbsolutePath;

            if (currentPage.EndsWith("/") && pageName.Equals("Dashboard.aspx", StringComparison.OrdinalIgnoreCase))
            {
                return "nav-link active";
            }

            if (currentPage.EndsWith(pageName, StringComparison.OrdinalIgnoreCase))
            {
                return "nav-link active";
            }

            return "nav-link";
        }
    }
}