using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AI_Travel_Planner
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Redirect to Dashboard if session already exists
                if (Session["UserName"] != null)
                {
                    Response.Redirect("Dashboard.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                }
            }
        }

        /// <summary>
        /// Handles Simplified Form Sign In
        /// </summary>
        protected void btnSignIn_Click(object sender, EventArgs e)
        {
            string emailOrUser = (txtLoginEmail.Text ?? string.Empty).Trim();
            string password = (txtLoginPassword.Text ?? string.Empty).Trim();

            hfAuthMode.Value = "signin";

            if (string.IsNullOrEmpty(emailOrUser) || string.IsNullOrEmpty(password))
            {
                ShowError("Please enter both email/username and password.");
                return;
            }

            string displayName = emailOrUser.Contains("@") ? emailOrUser.Split('@')[0] : emailOrUser;
            string email = emailOrUser.Contains("@") ? emailOrUser.ToLowerInvariant() : emailOrUser + "@example.com";
            string profilePic = GetGravatarUrl(email);

            Session["UserName"] = displayName;
            Session["UserEmail"] = email;
            Session["UserProfilePic"] = profilePic;

            SyncUserProfileSession(displayName, email, profilePic);

            FormsAuthentication.SetAuthCookie(displayName, chkRememberMe.Checked);
            Response.Redirect("Dashboard.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        /// <summary>
        /// Handles Simplified Account Registration
        /// </summary>
        protected void btnSignUp_Click(object sender, EventArgs e)
        {
            hfAuthMode.Value = "signup";

            string name = (txtRegName.Text ?? string.Empty).Trim();
            string email = (txtRegEmail.Text ?? string.Empty).Trim().ToLowerInvariant();
            string password = (txtRegPassword.Text ?? string.Empty).Trim();

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ShowError("Please fill out all fields to create your account.");
                return;
            }

            if (password.Length < 6)
            {
                ShowError("Password must be at least 6 characters long.");
                return;
            }

            string profilePic = GetGravatarUrl(email);

            Session["UserName"] = name;
            Session["UserEmail"] = email;
            Session["UserProfilePic"] = profilePic;

            SyncUserProfileSession(name, email, profilePic);

            FormsAuthentication.SetAuthCookie(name, false);
            Response.Redirect("Dashboard.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        /// <summary>
        /// Synchronizes session profile object with full name, email, avatar, and travel persona.
        /// </summary>
        private void SyncUserProfileSession(string name, string email, string avatarUrl)
        {
            Profile.UserProfileSettings existingProfile = Session["UserProfile"] as Profile.UserProfileSettings;

            if (existingProfile != null)
            {
                existingProfile.UserName = name;
                existingProfile.Email = email;
                existingProfile.AvatarUrl = avatarUrl;
                Session["UserProfile"] = existingProfile;
            }
            else
            {
                var newProfile = new Profile.UserProfileSettings
                {
                    UserName = name,
                    Email = email,
                    AvatarUrl = avatarUrl,
                    TravelStyle = "Balanced",
                    Pace = "Moderate",
                    Dietary = "None",
                    Currency = "INR",
                    HomeCity = "New Delhi (DEL)",
                    PriceAlerts = true,
                    TripReminders = true,
                    Newsletter = false
                };
                Session["UserProfile"] = newProfile;
            }
        }

        private void ShowError(string message)
        {
            lblError.Text = HttpUtility.HtmlEncode(message);
            pnlErrorMessage.Visible = true;
        }

        private string GetGravatarUrl(string email)
        {
            if (string.IsNullOrEmpty(email))
                return "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150";

            using (MD5 md5 = MD5.Create())
            {
                byte[] hashBytes = md5.ComputeHash(Encoding.UTF8.GetBytes(email.Trim().ToLower()));
                StringBuilder sb = new StringBuilder();
                foreach (byte b in hashBytes)
                {
                    sb.Append(b.ToString("x2"));
                }
                return "https://www.gravatar.com/avatar/" + sb.ToString() + "?d=mp&s=150";
            }
        }
    }
}