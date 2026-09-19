<%@ Page Title="Preferences & Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="AI_Travel_Planner.Profile" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            --card-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.04), 0 0 1px 1px rgba(0, 0, 0, 0.02);
            --card-shadow-hover: 0 20px 40px -10px rgba(37, 99, 235, 0.08), 0 0 1px 1px rgba(37, 99, 235, 0.05);
            --transition-smooth: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .page-header {
            margin-bottom: 32px;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            flex-wrap: wrap;
            gap: 12px;
        }

        .page-title {
            font-weight: 800;
            font-size: 2.1rem;
            margin-bottom: 6px;
            color: var(--text-dark, #0f172a);
            letter-spacing: -0.03em;
        }

        .page-subtitle {
            color: var(--text-muted, #64748b);
            font-size: 1rem;
            margin: 0;
            font-weight: 400;
        }

        /* Profile Layout Cards */
        .settings-card {
            background: var(--card-bg, #ffffff);
            border-radius: 24px;
            padding: 36px;
            border: 1px solid var(--border-color, #f1f5f9);
            box-shadow: var(--card-shadow);
            margin-bottom: 28px;
            transition: var(--transition-smooth);
            position: relative;
            overflow: hidden;
        }

        .settings-card:hover {
            box-shadow: var(--card-shadow-hover);
            border-color: rgba(37, 99, 235, 0.15);
            transform: translateY(-2px);
        }

        .card-section-title {
            font-weight: 800;
            font-size: 1.2rem;
            color: var(--text-dark, #0f172a);
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 12px;
            letter-spacing: -0.01em;
        }

        .card-section-title i {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            background: rgba(37, 99, 235, 0.08);
            color: #2563eb;
            border-radius: 10px;
            font-size: 0.95rem;
        }

        .card-section-subtitle {
            color: var(--text-muted, #64748b);
            font-size: 0.9rem;
            margin-bottom: 28px;
            line-height: 1.5;
        }

        /* Avatar Section */
        .avatar-section {
            display: flex;
            align-items: center;
            gap: 28px;
            margin-bottom: 32px;
            padding-bottom: 28px;
            border-bottom: 1px solid var(--border-color, #f1f5f9);
        }

        .profile-avatar-wrapper {
            position: relative;
            display: inline-block;
        }

        .profile-avatar-preview {
            width: 104px;
            height: 104px;
            min-width: 104px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--bg-light, #ffffff);
            box-shadow: 0 10px 25px rgba(37, 99, 235, 0.15);
        }

        .btn-upload-label {
            background: var(--hover-bg, #f8fafc);
            color: var(--text-dark, #0f172a);
            border: 1px solid var(--border-color, #e2e8f0);
            padding: 10px 18px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 0.85rem;
            cursor: pointer;
            transition: var(--transition-smooth);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.01);
        }

        .btn-upload-label:hover {
            background: var(--primary-blue, #2563eb);
            color: #ffffff;
            border-color: var(--primary-blue, #2563eb);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
            transform: translateY(-1px);
        }

        /* Form Styling Overrides */
        .form-label {
            font-weight: 700;
            font-size: 0.84rem;
            color: var(--text-dark, #1e293b);
            margin-bottom: 8px;
            letter-spacing: -0.01em;
        }

        .form-control, .form-select {
            background-color: var(--bg-light, #f8fafc);
            border: 1.5px solid var(--border-color, #e2e8f0);
            color: var(--text-dark, #0f172a);
            padding: 12px 16px;
            font-size: 0.92rem;
            border-radius: 14px;
            transition: var(--transition-smooth);
            font-weight: 500;
        }

        .form-control:hover, .form-select:hover {
            border-color: #cbd5e1;
        }

        .form-control:focus, .form-select:focus {
            background-color: var(--card-bg, #ffffff);
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        /* Modern Notification Toggle Switch Items */
        .notification-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 20px;
            background: #f8fafc;
            border: 1.5px solid #f1f5f9;
            border-radius: 16px;
            margin-bottom: 16px;
            transition: var(--transition-smooth);
        }

        .notification-item:hover {
            background: #ffffff;
            border-color: #e2e8f0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.02);
        }

        .notification-item:last-child {
            margin-bottom: 0;
        }

        /* Custom Toggle Switch Style */
        .form-switch .form-check-input {
            width: 3.2em;
            height: 1.6em;
            cursor: pointer;
            background-color: #cbd5e1;
            border-color: #cbd5e1;
            transition: var(--transition-smooth);
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='-4 -4 8 8'%3e%3ccircle r='3' fill='%23fff'/%3e%3csvg%3e");
        }

        .form-switch .form-check-input:focus {
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.12);
            border-color: #2563eb;
        }

        .form-switch .form-check-input:checked {
            background-color: #2563eb;
            border-color: #2563eb;
        }

        /* Save Bar Component */
        .save-bar {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 16px;
            margin-top: 12px;
            background: var(--card-bg, #ffffff);
            padding: 24px 32px;
            border-radius: 20px;
            border: 1px solid var(--border-color, #f1f5f9);
            box-shadow: var(--card-shadow);
            position: sticky;
            bottom: 24px;
            z-index: 10;
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.95);
        }

        .btn-save-pref {
            background: var(--primary-gradient);
            color: #ffffff;
            border: none;
            padding: 14px 36px;
            border-radius: 14px;
            font-weight: 700;
            font-size: 0.95rem;
            cursor: pointer;
            transition: var(--transition-smooth);
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.35);
            letter-spacing: -0.01em;
        }

        .btn-save-pref:hover {
            box-shadow: 0 6px 22px rgba(37, 99, 235, 0.45);
            transform: translateY(-2px);
            filter: brightness(1.05);
        }

        .alert-toast {
            border-radius: 16px;
            font-size: 0.92rem;
            font-weight: 600;
            border: none;
            box-shadow: 0 10px 25px rgba(16, 185, 129, 0.15);
            background-color: #ecfdf5;
            color: #065f46;
            padding: 16px 20px;
        }
    </style>

    <!-- Page Header -->
    <div class="page-header">
        <div>
            <h1 class="page-title">User Preferences ⚙️</h1>
            <p class="page-subtitle">Customize your profile photo, travel persona, currency, and app notification settings.</p>
        </div>
    </div>

    <!-- Alert Notification Message -->
    <asp:Panel ID="pnlSuccessAlert" runat="server" Visible="false" CssClass="alert alert-success alert-dismissible fade show alert-toast mb-4" role="alert">
        <i class="fa-solid fa-circle-check me-2 fs-5 align-middle"></i> Your preferences and profile photo have been saved successfully!
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close" style="top: 50%; transform: translateY(-50%);"></button>
    </asp:Panel>

    <div class="row">
        <!-- Left Column: Personal Profile & Travel Persona -->
        <div class="col-lg-7">
            <!-- Card 1: Personal Details & Avatar Upload -->
            <div class="settings-card">
                <div class="card-section-title">
                    <i class="fa-solid fa-user-gear"></i> Profile & Identity
                </div>
                <div class="card-section-subtitle">Manage your profile picture, display name, and registered email address.</div>

                <div class="avatar-section">
                    <div class="profile-avatar-wrapper">
                        <asp:Image ID="imgAvatarPreview" runat="server" ClientIDMode="Static" CssClass="profile-avatar-preview" ImageUrl="https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150" />
                    </div>
                    <div>
                        <h6 class="fw-bold mb-1" style="color:var(--text-dark, #0f172a); font-size:1.055rem;">Profile Picture</h6>
                        <span class="text-muted fs-8 d-block mb-3">Upload a high-resolution image to customize your account</span>
                        
                        <div class="d-flex align-items-center gap-3 flex-wrap">
                            <label for="fileAvatarUpload" class="btn-upload-label mb-0">
                                <i class="fa-solid fa-camera"></i> Upload Custom Photo
                            </label>
                            <asp:FileUpload ID="fileAvatarUpload" runat="server" ClientIDMode="Static" style="display:none;" onchange="previewImage(this);" />
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Display Name</label>
                        <asp:TextBox ID="txtUserName" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Email Address</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                    </div>
                </div>
            </div>

            <!-- Card 2: Travel Persona Settings -->
            <div class="settings-card">
                <div class="card-section-title">
                    <i class="fa-solid fa-compass"></i> Travel Persona
                </div>
                <div class="card-section-subtitle">Tailor your preferences for custom multi-day historical, cultural, or scenic trips.</div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Preferred Travel Style</label>
                        <asp:DropDownList ID="ddlTravelStyle" runat="server" CssClass="form-select">
                            <asp:ListItem Value="Balanced">Balanced (Culture & Chill)</asp:ListItem>
                            <asp:ListItem Value="Adventure">Adventure & Outdoor Exploration</asp:ListItem>
                            <asp:ListItem Value="Luxury">Luxury & Heritage Stays</asp:ListItem>
                            <asp:ListItem Value="Budget">Backpacker & Budget Friendly</asp:ListItem>
                            <asp:ListItem Value="Foodie">Culinary & Street Food Tours</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Pace Preference</label>
                        <asp:DropDownList ID="ddlPace" runat="server" CssClass="form-select">
                            <asp:ListItem Value="Moderate">Moderate (2-3 spots per day)</asp:ListItem>
                            <asp:ListItem Value="Fast">Fast-Paced (Cover as much as possible)</asp:ListItem>
                            <asp:ListItem Value="Relaxed">Slow & Relaxed (1-2 main spots)</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="mb-0">
                    <label class="form-label">Dietary Preferences / Restrictions</label>
                    <asp:DropDownList ID="ddlDietary" runat="server" CssClass="form-select">
                        <asp:ListItem Value="None">No Restrictions (Anything)</asp:ListItem>
                        <asp:ListItem Value="Vegetarian">Pure Vegetarian</asp:ListItem>
                        <asp:ListItem Value="Vegan">Vegan</asp:ListItem>
                        <asp:ListItem Value="Halal">Halal</asp:ListItem>
                        <asp:ListItem Value="Jain">Jain Food Options</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
        </div>

        <!-- Right Column: Regional & Notifications -->
        <div class="col-lg-5">
            <!-- Card 3: Currency & Location -->
            <div class="settings-card">
                <div class="card-section-title">
                    <i class="fa-solid fa-globe"></i> Region & Currency
                </div>
                <div class="card-section-subtitle">Set your home currency for budget calculations.</div>

                <div class="mb-3">
                    <label class="form-label">Default Display Currency</label>
                    <asp:DropDownList ID="ddlCurrency" runat="server" CssClass="form-select">
                        <asp:ListItem Value="INR">₹ INR - Indian Rupee</asp:ListItem>
                        <asp:ListItem Value="USD">$ USD - US Dollar</asp:ListItem>
                        <asp:ListItem Value="EUR">€ EUR - Euro</asp:ListItem>
                        <asp:ListItem Value="AED">AED - UAE Dirham</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="mb-0">
                    <label class="form-label">Home Airport / City</label>
                    <asp:TextBox ID="txtHomeCity" runat="server" CssClass="form-control" Placeholder="e.g. New Delhi (DEL)"></asp:TextBox>
                </div>
            </div>

            <!-- Card 4: Notifications & Email -->
            <div class="settings-card">
                <div class="card-section-title">
                    <i class="fa-solid fa-bell"></i> Notifications & Alerts
                </div>
                <div class="card-section-subtitle">Choose what alerts you want to receive.</div>

                <div class="notification-item">
                    <div>
                        <label class="form-label mb-1 d-block" for="chkPriceAlerts" style="cursor: pointer;">Flight Price Drop Alerts</label>
                        <span class="text-muted fs-8 d-block">Notify when tracked flight prices drop</span>
                    </div>
                    <div class="form-check form-switch ps-0 m-0">
                        <asp:CheckBox ID="chkPriceAlerts" runat="server" CssClass="form-check-input float-none m-0" Checked="true" />
                    </div>
                </div>

                <div class="notification-item">
                    <div>
                        <label class="form-label mb-1 d-block" for="chkTripReminders" style="cursor: pointer;">Upcoming Trip Reminders</label>
                        <span class="text-muted fs-8 d-block">Receive packing & hotel check-in prompts</span>
                    </div>
                    <div class="form-check form-switch ps-0 m-0">
                        <asp:CheckBox ID="chkTripReminders" runat="server" CssClass="form-check-input float-none m-0" Checked="true" />
                    </div>
                </div>

                <div class="notification-item">
                    <div>
                        <label class="form-label mb-1 d-block" for="chkNewsletter" style="cursor: pointer;">Weekly Travel Hacks</label>
                        <span class="text-muted fs-8 d-block">Get travel tips delivered to your inbox</span>
                    </div>
                    <div class="form-check form-switch ps-0 m-0">
                        <asp:CheckBox ID="chkNewsletter" runat="server" CssClass="form-check-input float-none m-0" Checked="false" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bottom Sticky Save Action Bar -->
    <div class="save-bar mb-3">
        <asp:Button ID="btnSavePreferences" runat="server" Text="Save Preferences" CssClass="btn-save-pref" OnClick="btnSavePreferences_Click" />
    </div>

    <!-- Client-side Image Preview Script -->
    <script type="text/javascript">
        function previewImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    var img = document.getElementById('imgAvatarPreview');
                    if (img) {
                        img.src = e.target.result;
                    }
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</asp:Content>