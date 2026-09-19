<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="AI_Travel_Planner.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sign In - Travel Planner</title>

    <!-- Google Fonts, FontAwesome & Bootstrap -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        :root {
            --primary-blue: #2563eb;
            --primary-hover: #1d4ed8;
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --border-color: #cbd5e1;
            --focus-ring: rgba(37, 99, 235, 0.15);
        }

        body {
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: #f8fafc;
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .auth-container {
            width: 100%;
            max-width: 1000px;
            background: #ffffff;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.06);
            border: 1px solid #e2e8f0;
            overflow: hidden;
            display: flex;
            min-height: 640px;
        }

        /* Left Side: Auth Form */
        .auth-form-section {
            flex: 1;
            padding: 48px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .brand-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 800;
            font-size: 1.1rem;
            color: var(--text-dark);
            text-decoration: none;
            margin-bottom: 24px;
        }

        .brand-icon {
            width: 38px;
            height: 38px;
            background: #eff6ff;
            color: var(--primary-blue);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            box-shadow: 0 2px 6px rgba(37, 99, 235, 0.1);
        }

        .auth-tabs {
            display: flex;
            background: #f1f5f9;
            padding: 4px;
            border-radius: 12px;
            margin-bottom: 24px;
        }

        .auth-tab-btn {
            flex: 1;
            border: none;
            background: transparent;
            padding: 10px 16px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.88rem;
            color: var(--text-muted);
            cursor: pointer;
            transition: all 0.25s ease;
        }

        .auth-tab-btn.active {
            background: #ffffff;
            color: var(--text-dark);
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        /* Enhanced Floating Input Groups */
        .input-group-modern {
            position: relative;
            margin-bottom: 18px;
        }

        .input-group-modern .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 1rem;
            transition: color 0.2s ease;
            z-index: 4;
        }

        .input-group-modern input.form-control-modern {
            width: 100%;
            height: 50px;
            padding-left: 48px;
            padding-right: 48px;
            border-radius: 14px;
            border: 1.5px solid var(--border-color);
            background-color: #fafafa;
            font-size: 0.95rem;
            font-weight: 500;
            color: var(--text-dark);
            transition: all 0.2s ease;
        }

        .input-group-modern input.form-control-modern:focus {
            background-color: #ffffff;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 4px var(--focus-ring);
            outline: none;
        }

        .input-group-modern input.form-control-modern:focus ~ .input-icon {
            color: var(--primary-blue);
        }

        .toggle-password {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            cursor: pointer;
            z-index: 4;
            font-size: 1rem;
            transition: color 0.2s ease;
        }

        .toggle-password:hover {
            color: var(--text-dark);
        }

        /* Caps Lock Warning Badge */
        .caps-lock-warning {
            font-size: 0.75rem;
            color: #d97706;
            background: #fffbeb;
            border: 1px solid #fde68a;
            padding: 4px 10px;
            border-radius: 6px;
            display: none;
            align-items: center;
            gap: 6px;
            margin-top: 6px;
            font-weight: 600;
        }

        .btn-auth-submit {
            background: var(--primary-blue);
            color: #ffffff;
            border: none;
            height: 50px;
            border-radius: 14px;
            font-weight: 700;
            font-size: 0.95rem;
            width: 100%;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
        }

        .btn-auth-submit:hover {
            background: var(--primary-hover);
            box-shadow: 0 6px 16px rgba(37, 99, 235, 0.3);
            transform: translateY(-1px);
        }

        /* Right Side: Hero Visual Banner */
        .auth-hero-section {
            flex: 1;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.75) 0%, rgba(37, 99, 235, 0.65) 100%), 
                        url('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1000') center/cover;
            padding: 48px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            color: #ffffff;
            position: relative;
        }

        .hero-badge-pill {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(8px);
            padding: 6px 16px;
            border-radius: 30px;
            font-size: 0.8rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            width: fit-content;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .hero-stats-card {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(12px);
            border-radius: 16px;
            padding: 20px;
            border: 1px solid rgba(255, 255, 255, 0.25);
        }

        @media (max-width: 768px) {
            .auth-hero-section { display: none; }
            .auth-form-section { padding: 32px 20px; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="auth-container">
            <!-- Left Side: Login / Register Form -->
            <div class="auth-form-section">
                <a href="#" class="brand-logo">
                    <div class="brand-icon">
                        <i class="fa-solid fa-plane-up"></i>
                    </div>
                    <span>TRAVEL PLANNER</span>
                </a>

                <!-- Alert Message Area -->
                <asp:Panel ID="pnlErrorMessage" runat="server" Visible="false" CssClass="alert alert-danger py-2 px-3 mb-3 fs-8 fw-semibold rounded-3" role="alert">
                    <asp:Label ID="lblError" runat="server"></asp:Label>
                </asp:Panel>

                <!-- Auth Tabs Toggle -->
                <div class="auth-tabs">
                    <button type="button" class="auth-tab-btn active" id="tabSignIn" onclick="switchTab('signin')">Sign In</button>
                    <button type="button" class="auth-tab-btn" id="tabSignUp" onclick="switchTab('signup')">Create Account</button>
                </div>

                <asp:HiddenField ID="hfAuthMode" runat="server" Value="signin" />

                <!-- Login Fields Container -->
                <div id="sectionSignIn">
                    <div class="input-group-modern">
                        <i class="fa-regular fa-envelope input-icon"></i>
                        <asp:TextBox ID="txtLoginEmail" runat="server" CssClass="form-control-modern" Placeholder="Email or Username" autocomplete="username"></asp:TextBox>
                    </div>

                    <div class="input-group-modern mb-2">
                        <i class="fa-solid fa-lock input-icon"></i>
                        <asp:TextBox ID="txtLoginPassword" runat="server" TextMode="Password" CssClass="form-control-modern" Placeholder="Password" autocomplete="current-password" onkeypress="checkCapsLock(event)"></asp:TextBox>
                        <i class="fa-regular fa-eye toggle-password" id="toggleLoginEye" onclick="togglePasswordVisibility('<%: txtLoginPassword.ClientID %>', 'toggleLoginEye')"></i>
                    </div>
                    
                    <!-- Caps Lock Warning for Login Password -->
                    <div id="loginCapsLockWarning" class="caps-lock-warning">
                        <i class="fa-solid fa-triangle-exclamation"></i> Caps Lock is ON
                    </div>

                    <div class="d-flex justify-content-between align-items-center mb-4 mt-2">
                        <div class="form-check">
                            <asp:CheckBox ID="chkRememberMe" runat="server" CssClass="form-check-input" Checked="true" />
                            <label class="form-check-label fs-8 text-muted fw-semibold" for="chkRememberMe">Remember me</label>
                        </div>
                        <a href="#" class="fs-8 text-primary fw-semibold text-decoration-none">Forgot password?</a>
                    </div>

                    <asp:Button ID="btnSignIn" runat="server" Text="Sign In to Account" CssClass="btn-auth-submit" OnClick="btnSignIn_Click" />
                </div>

                <!-- Registration Fields Container (Hidden by Default) -->
                <div id="sectionSignUp" style="display: none;">
                    <div class="input-group-modern">
                        <i class="fa-regular fa-user input-icon"></i>
                        <asp:TextBox ID="txtRegName" runat="server" CssClass="form-control-modern" Placeholder="Full Name" autocomplete="name"></asp:TextBox>
                    </div>

                    <div class="input-group-modern">
                        <i class="fa-regular fa-envelope input-icon"></i>
                        <asp:TextBox ID="txtRegEmail" runat="server" TextMode="Email" CssClass="form-control-modern" Placeholder="Email Address" autocomplete="email"></asp:TextBox>
                    </div>

                    <div class="input-group-modern mb-2">
                        <i class="fa-solid fa-lock input-icon"></i>
                        <asp:TextBox ID="txtRegPassword" runat="server" TextMode="Password" CssClass="form-control-modern" Placeholder="Create Password (min 6 chars)" autocomplete="new-password" onkeypress="checkRegCapsLock(event)"></asp:TextBox>
                        <i class="fa-regular fa-eye toggle-password" id="toggleRegEye" onclick="togglePasswordVisibility('<%: txtRegPassword.ClientID %>', 'toggleRegEye')"></i>
                    </div>

                    <!-- Caps Lock Warning for Register Password -->
                    <div id="regCapsLockWarning" class="caps-lock-warning mb-3">
                        <i class="fa-solid fa-triangle-exclamation"></i> Caps Lock is ON
                    </div>

                    <asp:Button ID="btnSignUp" runat="server" Text="Create Free Account" CssClass="btn-auth-submit mt-2" OnClick="btnSignUp_Click" />
                </div>
            </div>

            <!-- Right Side: Travel Hero Showcase -->
            <div class="auth-hero-section">
                <div class="hero-badge-pill">
                    <i class="fa-solid fa-sparkles text-warning"></i> SMART ITINERARIES & STAYS
                </div>

                <div>
                    <h2 class="fw-extrabold display-6 mb-3" style="font-weight: 800;">Plan your dream vacation in seconds.</h2>
                    <p class="fs-7 opacity-75 mb-4">Discover personalized itineraries, track budgets, save top destinations, and book hotels all in one place.</p>

                    <div class="hero-stats-card d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="fw-bold mb-0">10,000+</h5>
                            <span class="fs-8 opacity-75">Trips Planned</span>
                        </div>
                        <div class="border-end border-white opacity-25" style="height: 30px;"></div>
                        <div>
                            <h5 class="fw-bold mb-0">4.9 ★★★★★</h5>
                            <span class="fs-8 opacity-75">User Rating</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        function switchTab(mode) {
            const tabSignIn = document.getElementById('tabSignIn');
            const tabSignUp = document.getElementById('tabSignUp');
            const sectionSignIn = document.getElementById('sectionSignIn');
            const sectionSignUp = document.getElementById('sectionSignUp');
            const hfAuthMode = document.getElementById('<%: hfAuthMode.ClientID %>');

            if (mode === 'signup') {
                tabSignIn.classList.remove('active');
                tabSignUp.classList.add('active');
                sectionSignIn.style.display = 'none';
                sectionSignUp.style.display = 'block';
                if (hfAuthMode) hfAuthMode.value = 'signup';
            } else {
                tabSignUp.classList.remove('active');
                tabSignIn.classList.add('active');
                sectionSignUp.style.display = 'none';
                sectionSignIn.style.display = 'block';
                if (hfAuthMode) hfAuthMode.value = 'signin';
            }
        }

        // Improved Password Visibility Toggle with Eye Icon Animation
        function togglePasswordVisibility(fieldId, iconId) {
            const field = document.getElementById(fieldId);
            const icon = document.getElementById(iconId);
            if (field && icon) {
                if (field.type === "password") {
                    field.type = "text";
                    icon.classList.remove("fa-eye");
                    icon.classList.add("fa-eye-slash");
                } else {
                    field.type = "password";
                    icon.classList.remove("fa-eye-slash");
                    icon.classList.add("fa-eye");
                }
            }
        }

        // Caps Lock Detection Logic
        function checkCapsLock(event) {
            const warning = document.getElementById('loginCapsLockWarning');
            if (warning && event.getModifierState) {
                warning.style.display = event.getModifierState('CapsLock') ? 'inline-flex' : 'none';
            }
        }

        function checkRegCapsLock(event) {
            const warning = document.getElementById('regCapsLockWarning');
            if (warning && event.getModifierState) {
                warning.style.display = event.getModifierState('CapsLock') ? 'inline-flex' : 'none';
            }
        }

        // Restore active tab after postback if registration failed or triggered
        window.onload = function () {
            const hfAuthMode = document.getElementById('<%: hfAuthMode.ClientID %>');
            if (hfAuthMode && hfAuthMode.value === 'signup') {
                switchTab('signup');
            }
        };
    </script>
</body>
</html>