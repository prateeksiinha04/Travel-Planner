<%@ Page Title="Dashboard | Travel Planner" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="AI_Travel_Planner.Dashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* Hero Header Flexbox Container */
        .header-hero-card {
            background-color: var(--card-bg);
            border-radius: 20px;
            padding: 24px 28px;
            border: 1px solid var(--border-color);
            margin-bottom: 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.02);
            transition: background-color 0.25s ease, border-color 0.25s ease;
        }

        .header-hero-content {
            flex-grow: 1;
            max-width: 620px;
        }

        .welcome-title { 
            font-weight: 800; 
            font-size: 1.8rem; 
            margin-bottom: 4px; 
            color: var(--text-dark); 
        }
        
        .welcome-subtitle { 
            color: var(--text-muted); 
            font-size: 0.95rem; 
            margin-bottom: 20px; 
        }

        /* Fixed Search Bar Pill Container */
        .search-bar-container {
            background: var(--bg-light);
            border-radius: 14px;
            padding: 4px 4px 4px 18px;
            display: flex;
            align-items: center;
            border: 1px solid var(--border-color);
            width: 100%;
            box-sizing: border-box;
        }

        .search-bar-container i {
            color: var(--text-muted);
            font-size: 1.1rem;
            margin-right: 14px;
        }

        .search-bar-container input[type="text"] {
            border: none !important;
            outline: none !important;
            box-shadow: none !important;
            flex-grow: 1;
            font-size: 0.95rem;
            color: var(--text-dark);
            background: transparent;
            padding: 8px 0;
            width: 100%;
        }

        .search-btn {
            background: #2563eb;
            color: #ffffff;
            border: none;
            padding: 10px 28px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.9rem;
            cursor: pointer;
            transition: background 0.2s ease;
            white-space: nowrap;
        }
        .search-btn:hover { background: #1d4ed8; }

        /* Corner Mountain Art */
        .header-hero-art {
            width: 240px;
            height: 125px;
            min-width: 240px;
            border-radius: 14px;
            object-fit: cover;
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
        }

        /* Metric Stat Cards */
        .metric-card {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 18px 20px;
            border: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 16px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            transition: background-color 0.25s ease;
        }

        .metric-icon {
            width: 46px;
            height: 46px;
            min-width: 46px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.15rem;
        }

        .metric-icon.blue { background: #eff6ff; color: #2563eb; }
        .metric-icon.green { background: #f0fdf4; color: #16a34a; }
        .metric-icon.purple { background: #faf5ff; color: #9333ea; }
        .metric-icon.orange { background: #fff7ed; color: #ea580c; }

        .metric-val { font-size: 1.45rem; font-weight: 800; line-height: 1.2; color: var(--text-dark); }
        .metric-label { font-size: 0.8rem; color: var(--text-muted); font-weight: 600; }
        .metric-sub { font-size: 0.75rem; color: var(--text-muted); margin-top: 2px; }

        /* Section Headers */
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }
        .section-header h5 { font-weight: 800; font-size: 1.1rem; margin: 0; color: var(--text-dark); }
        .view-all-link { color: #2563eb; text-decoration: none; font-weight: 700; font-size: 0.85rem; }

        /* Upcoming Trip Items */
        .trip-item-card {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 14px 16px;
            border: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 12px;
            transition: background-color 0.25s ease;
        }

        .trip-thumb {
            width: 80px;
            height: 64px;
            min-width: 80px;
            border-radius: 10px;
            object-fit: cover;
        }

        .badge-upcoming {
            background: #dcfce7;
            color: #15803d;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
        }

        /* Hero AI Recommendation (Jaipur Fort) */
        .ai-recommend-card {
            border-radius: 16px;
            overflow: hidden;
            position: relative;
            height: 220px;
            background: url('https://images.unsplash.com/photo-1599661046289-e31897846e41?w=800') center/cover;
            color: #ffffff;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
        }

        .ai-recommend-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(to top, rgba(0,0,0,0.85) 0%, rgba(0,0,0,0.1) 100%);
        }

        .ai-recommend-content { position: relative; z-index: 2; }
        .badge-recommended {
            background: rgba(255,255,255,0.25);
            backdrop-filter: blur(8px);
            color: #fff;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 700;
            margin-bottom: 8px;
            display: inline-block;
        }

        /* Quick Action Buttons */
        .quick-action-btn {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 14px;
            padding: 14px 10px;
            text-align: center;
            display: block;
            text-decoration: none;
            color: var(--text-dark);
            transition: all 0.2s ease;
        }
        .quick-action-btn:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .action-icon {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            margin: 0 auto 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
        }

        /* AI Banner */
        .ai-banner-card {
            background: linear-gradient(135deg, #eff6ff 0%, #e0f2fe 100%);
            border-radius: 16px;
            padding: 22px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        body.dark-mode .ai-banner-card {
            background: linear-gradient(135deg, #1e3a8a 0%, #0f172a 100%);
            border: 1px solid #1e40af;
        }

        /* Recent Bookings List */
        .booking-row {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 12px 16px;
            border: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 10px;
            transition: background-color 0.25s ease;
        }

        .booking-icon {
            width: 38px;
            height: 38px;
            min-width: 38px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        @media (max-width: 992px) {
            .header-hero-art {
                display: none;
            }
        }
    </style>

    <!-- Header Section with Mountain Illustration -->
    <div class="header-hero-card">
        <div class="header-hero-content">
            <h1 class="welcome-title">
                Welcome back, <asp:Label ID="lblUserName" runat="server"></asp:Label>! 👋
            </h1>
            <p class="welcome-subtitle">Where would you like to explore today?</p>

            <!-- Search Bar -->
            <div class="search-bar-container">
                <i class="fa-solid fa-magnifying-glass"></i>
                <asp:TextBox ID="txtSearch" runat="server" Placeholder="Search destinations, attractions, activities..."></asp:TextBox>
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="search-btn" OnClick="btnSearch_Click" />
            </div>
        </div>

        <!-- Corner Mountain Art -->
        <img src="https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=600" class="header-hero-art" alt="Mountain Landscape" />
    </div>

    <!-- Metrics Summary Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="metric-card">
                <div class="metric-icon blue"><i class="fa-solid fa-suitcase"></i></div>
                <div>
                    <div class="metric-label">Trips Planned</div>
                    <div class="metric-val"><asp:Label ID="lblTripsPlanned" runat="server"></asp:Label></div>
                    <div class="metric-sub"><i class="fa-solid fa-chart-simple me-1"></i>All Time</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="metric-card">
                <div class="metric-icon green"><i class="fa-solid fa-location-dot"></i></div>
                <div>
                    <div class="metric-label">Places Visited</div>
                    <div class="metric-val"><asp:Label ID="lblPlacesVisited" runat="server"></asp:Label></div>
                    <div class="metric-sub"><i class="fa-solid fa-chart-simple me-1"></i>All Time</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="metric-card">
                <div class="metric-icon purple"><i class="fa-regular fa-calendar"></i></div>
                <div>
                    <div class="metric-label">Upcoming Trips</div>
                    <div class="metric-val"><asp:Label ID="lblUpcomingTripsCount" runat="server"></asp:Label></div>
                    <div class="metric-sub"><i class="fa-regular fa-calendar me-1"></i>Next 30 Days</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="metric-card">
                <div class="metric-icon orange"><i class="fa-solid fa-wallet"></i></div>
                <div>
                    <div class="metric-label">Total Saved</div>
                    <div class="metric-val"><asp:Label ID="lblTotalSaved" runat="server"></asp:Label></div>
                    <div class="metric-sub"><i class="fa-solid fa-receipt me-1"></i>On Bookings</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content Grid -->
    <div class="row g-4">
        <!-- Left Column: Upcoming Trips, Quick Actions & AI Banner -->
        <div class="col-lg-7">
            <div class="section-header">
                <h5>Upcoming Trips</h5>
                <a href="MyTrips.aspx" class="view-all-link">View All</a>
            </div>

            <!-- Repeater for Upcoming Trips -->
            <asp:Repeater ID="rptUpcomingTrips" runat="server">
                <ItemTemplate>
                    <div class="trip-item-card">
                        <img src='<%# Eval("ImageUrl") %>' class="trip-thumb" alt='<%# Eval("Destination") %>' />
                        <div class="flex-grow-1">
                            <h6 class="fw-bold mb-1" style="color: var(--text-dark);"><%# Eval("Title") %> <%# Eval("Flag") %></h6>
                            <p class="text-muted small mb-1"><%# Eval("DateRange") %></p>
                            <span class="text-muted fs-8"><%# Eval("Details") %></span>
                        </div>
                        <div>
                            <span class="badge-upcoming"><%# Eval("Status") %></span>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <!-- Quick Actions Grid -->
            <div class="section-header mt-4">
                <h5>Quick Actions</h5>
            </div>
            <div class="row g-2 mb-4">
                <div class="col">
                    <a href="TripPlanner.aspx" class="quick-action-btn">
                        <div class="action-icon" style="background:#eff6ff; color:#2563eb;"><i class="fa-solid fa-plane"></i></div>
                        <span class="fw-bold fs-8">Plan a Trip</span>
                    </a>
                </div>
                <div class="col">
                    <a href="SavedPlaces.aspx" class="quick-action-btn">
                        <div class="action-icon" style="background:#f0fdf4; color:#16a34a;"><i class="fa-solid fa-location-dot"></i></div>
                        <span class="fw-bold fs-8">Explore Places</span>
                    </a>
                </div>
                <div class="col">
                    <a href="TripPlanner.aspx" class="quick-action-btn">
                        <div class="action-icon" style="background:#faf5ff; color:#9333ea;"><i class="fa-solid fa-wand-magic-sparkles"></i></div>
                        <span class="fw-bold fs-8">Trip Itinerary</span>
                    </a>
                </div>
                <div class="col">
                    <a href="Budget.aspx" class="quick-action-btn">
                        <div class="action-icon" style="background:#fff7ed; color:#ea580c;"><i class="fa-solid fa-wallet"></i></div>
                        <span class="fw-bold fs-8">Budget Planner</span>
                    </a>
                </div>
                <div class="col">
                    <a href="SavedPlaces.aspx" class="quick-action-btn">
                        <div class="action-icon" style="background:#fef2f2; color:#ef4444;"><i class="fa-solid fa-tag"></i></div>
                        <span class="fw-bold fs-8">Find Deals</span>
                    </a>
                </div>
            </div>

            <!-- Assistant Builder Banner -->
            <div class="ai-banner-card">
                <div>
                    <h5 class="fw-bold text-dark mb-1">Let Assistant Build Your Perfect Trip</h5>
                    <p class="text-muted fs-8 mb-3">Tell us your preferences and our planner will create a personalized itinerary just for you.</p>
                    <a href="TripPlanner.aspx" class="btn btn-primary font-weight-bold px-4">Start Planning</a>
                </div>
                <div class="text-end d-none d-sm-block">
                    <i class="fa-solid fa-compass text-primary" style="font-size: 4rem; opacity: 0.8;"></i>
                </div>
            </div>
        </div>

        <!-- Right Column: Recommendations & Recent Bookings -->
        <div class="col-lg-5">
            <div class="section-header">
                <h5>Featured Recommendation for You</h5>
                <a href="SavedPlaces.aspx" class="view-all-link">View All</a>
            </div>

            <!-- Updated Indian Location: Jaipur Fort, Rajasthan -->
            <div class="ai-recommend-card mb-4">
                <div class="ai-recommend-content">
                    <span class="badge-recommended">Top Heritage Spot</span>
                    <h4 class="fw-bold mb-1">Jaipur Fort, Rajasthan</h4>
                    <p class="small text-light mb-3">Majestic Amber Fort architecture, royal palaces, and panoramic desert valley views.</p>
                    <a href="TripPlanner.aspx?dest=Rajasthan" class="btn btn-light btn-sm fw-bold px-3">Explore Trip</a>
                </div>
            </div>

            <div class="section-header">
                <h5>Recent Bookings</h5>
                <a href="MyTrips.aspx" class="view-all-link">View All</a>
            </div>

            <!-- Repeater for Recent Bookings -->
            <asp:Repeater ID="rptRecentBookings" runat="server">
                <ItemTemplate>
                    <div class="booking-row">
                        <div class="d-flex align-items-center gap-3">
                            <div class="booking-icon" style='<%# Eval("IconStyle") %>'>
                                <i class='<%# Eval("IconClass") %>'></i>
                            </div>
                            <div>
                                <h6 class="fw-bold mb-0 fs-8" style="color: var(--text-dark);"><%# Eval("Title") %></h6>
                                <span class="text-muted fs-8"><%# Eval("Subtitle") %></span>
                            </div>
                        </div>
                        <span class="badge bg-success-subtle text-success fw-bold fs-8"><%# Eval("Status") %></span>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>