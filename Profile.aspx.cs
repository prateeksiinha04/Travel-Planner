using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

namespace AI_Travel_Planner
{
    public partial class Profile : Page
    {
        [Serializable]
        public class UserProfileSettings
        {
            public string UserName { get; set; }
            public string Email { get; set; }
            public string AvatarUrl { get; set; }
            public string TravelStyle { get; set; }
            public string Pace { get; set; }
            public string Dietary { get; set; }
            public string Currency { get; set; }
            public string HomeCity { get; set; }
            public bool PriceAlerts { get; set; }
            public bool TripReminders { get; set; }
            public bool Newsletter { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUserPreferences();
            }
        }

        private void LoadUserPreferences()
        {
            UserProfileSettings settings = Session["UserProfile"] as UserProfileSettings;

            if (settings == null)
            {
                string activeUserName = Session["UserName"] != null ? Session["UserName"].ToString() : "Traveler";
                string activeEmail = Session["UserEmail"] != null ? Session["UserEmail"].ToString() : "traveler@example.com";
                string activeAvatar = Session["UserProfilePic"] != null ? Session["UserProfilePic"].ToString() : GetGravatarUrl(activeEmail);

                settings = new UserProfileSettings
                {
                    UserName = activeUserName,
                    Email = activeEmail,
                    AvatarUrl = activeAvatar,
                    TravelStyle = "Balanced",
                    Pace = "Moderate",
                    Dietary = "None",
                    Currency = "INR",
                    HomeCity = "New Delhi (DEL)",
                    PriceAlerts = true,
                    TripReminders = true,
                    Newsletter = false
                };
                Session["UserProfile"] = settings;
            }

            txtUserName.Text = settings.UserName;
            txtEmail.Text = settings.Email;
            imgAvatarPreview.ImageUrl = settings.AvatarUrl;

            // Safely assign dropdown values if they exist in the list items
            SetDropdownSafe(ddlTravelStyle, settings.TravelStyle);
            SetDropdownSafe(ddlPace, settings.Pace);
            SetDropdownSafe(ddlDietary, settings.Dietary);
            SetDropdownSafe(ddlCurrency, settings.Currency);

            txtHomeCity.Text = settings.HomeCity;
            chkPriceAlerts.Checked = settings.PriceAlerts;
            chkTripReminders.Checked = settings.TripReminders;
            chkNewsletter.Checked = settings.Newsletter;
        }

        private void SetDropdownSafe(System.Web.UI.WebControls.DropDownList ddl, string value)
        {
            var item = ddl.Items.FindByValue(value);
            if (item != null)
            {
                ddl.ClearSelection();
                item.Selected = true;
            }
        }

        protected void btnSavePreferences_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string avatarUrl = imgAvatarPreview.ImageUrl;

            // Handle Custom Image File Upload
            if (fileAvatarUpload.HasFile)
            {
                try
                {
                    string extension = Path.GetExtension(fileAvatarUpload.FileName).ToLower();
                    if (extension == ".jpg" || extension == ".jpeg" || extension == ".png" || extension == ".gif")
                    {
                        string folderPath = Server.MapPath("~/Uploads/Avatars/");
                        if (!Directory.Exists(folderPath))
                        {
                            Directory.CreateDirectory(folderPath);
                        }

                        string fileName = "avatar_" + Guid.NewGuid().ToString("N").Substring(0, 8) + extension;
                        string savePath = Path.Combine(folderPath, fileName);
                        fileAvatarUpload.SaveAs(savePath);

                        avatarUrl = ResolveUrl("~/Uploads/Avatars/" + fileName);
                    }
                }
                catch (Exception)
                {
                    // Fallback to existing photo safely
                }
            }

            var settings = new UserProfileSettings
            {
                UserName = txtUserName.Text.Trim(),
                Email = email,
                AvatarUrl = avatarUrl,
                TravelStyle = ddlTravelStyle.SelectedValue,
                Pace = ddlPace.SelectedValue,
                Dietary = ddlDietary.SelectedValue,
                Currency = ddlCurrency.SelectedValue,
                HomeCity = txtHomeCity.Text.Trim(),
                PriceAlerts = chkPriceAlerts.Checked,
                TripReminders = chkTripReminders.Checked,
                Newsletter = chkNewsletter.Checked
            };

            // 1. Sync Profile Object in Session
            Session["UserProfile"] = settings;
            Session["UserProfilePic"] = avatarUrl;

            // 2. Sync Display Name & Email with Master Session
            if (!string.IsNullOrEmpty(settings.UserName))
            {
                Session["UserName"] = settings.UserName;
            }
            if (!string.IsNullOrEmpty(settings.Email))
            {
                Session["UserEmail"] = settings.Email;
            }

            imgAvatarPreview.ImageUrl = avatarUrl;
            pnlSuccessAlert.Visible = true;
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