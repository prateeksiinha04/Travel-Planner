<%@ Page Title="Trip Planner | Travel Planner" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TripPlanner.aspx.cs" Inherits="AI_Travel_Planner.TripPlanner" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Include jsPDF and html2canvas for PDF Generation -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

    <style>
        :root {
            --brand-blue: #0f4c81;
            --brand-orange: #f47721;
            --brand-dark: #0f172a;
        }

        .page-header { margin-bottom: 24px; }
        .page-title { font-weight: 800; font-size: 1.8rem; margin-bottom: 4px; color: var(--brand-dark); }
        .page-subtitle { color: #64748b; font-size: 0.95rem; margin: 0; }

        .brand-badge {
            background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
            color: #e65100;
            font-weight: 800;
            border: 1px solid #ffe0b2;
        }

        .easy-search-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 18px 24px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 14px rgba(0,0,0,0.03);
            margin-bottom: 16px;
        }

        .search-pill-input {
            position: relative;
            display: flex;
            align-items: center;
            background: #f8fafc;
            border: 1.5px solid #cbd5e1;
            border-radius: 30px;
            padding: 8px 18px;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .search-pill-input:focus-within {
            border-color: var(--brand-blue);
            box-shadow: 0 0 0 3px rgba(15, 76, 129, 0.15);
        }

        .search-pill-input i { color: #64748b; font-size: 1.1rem; margin-right: 12px; }

        .search-pill-input input {
            border: none !important;
            outline: none !important;
            box-shadow: none !important;
            background: transparent;
            width: 100%;
            color: var(--brand-dark);
            font-size: 0.95rem;
            font-weight: 600;
        }

        .clear-search-btn {
            background: none;
            border: none;
            color: #64748b;
            cursor: pointer;
            font-size: 1rem;
            display: none;
        }

        /* Popular Destination Cards Grid */
        .popular-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
            gap: 14px;
            margin-bottom: 24px;
        }

        .pop-card {
            position: relative;
            height: 100px;
            border-radius: 16px;
            overflow: hidden;
            cursor: pointer;
            border: 1px solid #e2e8f0;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            user-select: none;
        }

        .pop-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

        .pop-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .pop-card-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(15, 23, 42, 0.8) 0%, rgba(15, 23, 42, 0.1) 100%);
            display: flex;
            align-items: flex-end;
            padding: 10px 12px;
            color: #ffffff;
        }

        .pop-card-title {
            font-size: 0.85rem;
            font-weight: 800;
            color: #ffffff;
            margin: 0;
            text-shadow: 0 1px 2px rgba(0,0,0,0.5);
        }

        .form-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 24px 28px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 2px 6px rgba(0,0,0,0.02);
            margin-bottom: 28px;
        }

        .form-label { font-size: 0.85rem; font-weight: 700; color: var(--brand-dark); margin-bottom: 6px; }

        .interest-chips { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 6px; }
        .interest-chip-item input[type="checkbox"] { display: none; }
        .interest-chip-item label {
            background: #f8fafc;
            color: var(--brand-dark);
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.82rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            border: 1px solid #cbd5e1;
            user-select: none;
        }

        .interest-chip-item input[type="checkbox"]:checked + label {
            background: #e6f0fa;
            color: var(--brand-blue);
            border-color: var(--brand-blue);
            font-weight: 700;
        }

        .btn-generate {
            background: var(--brand-blue);
            color: #ffffff;
            border: none;
            padding: 12px 28px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 0.95rem;
            cursor: pointer;
            transition: background 0.2s ease;
            width: 100%;
        }

        .btn-generate:hover { background: #0c3d69; color: #ffffff; }

        .btn-book-trip {
            background: linear-gradient(135deg, var(--brand-orange) 0%, #e65100 100%);
            color: #ffffff;
            border: none;
            padding: 10px 24px;
            border-radius: 12px;
            font-weight: 800;
            font-size: 0.9rem;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            box-shadow: 0 4px 12px rgba(244, 119, 33, 0.3);
        }

        .btn-book-trip:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(244, 119, 33, 0.4);
            color: #ffffff;
        }

        .neighbor-state-card {
            background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
            border: 1px solid #bbf7d0;
            border-radius: 16px;
            padding: 16px 20px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
        }

        .booked-summary-banner {
            background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
            border: 1px solid #bfdbfe;
            border-radius: 16px;
            padding: 16px 20px;
            margin-bottom: 20px;
        }

        .itinerary-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 24px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 2px 6px rgba(0,0,0,0.02);
            margin-bottom: 20px;
        }

        .day-badge {
            background: #e6f0fa;
            color: var(--brand-blue);
            font-weight: 800;
            padding: 6px 14px;
            border-radius: 10px;
            font-size: 0.85rem;
            display: inline-block;
        }

        .city-tag {
            background: #fffbeb;
            color: #b45309;
            font-weight: 800;
            padding: 6px 14px;
            border-radius: 10px;
            font-size: 0.82rem;
            display: inline-block;
        }

        .weather-banner {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 8px 14px;
            font-size: 0.82rem;
            font-weight: 600;
            color: #475569;
            margin-bottom: 12px;
        }

        .day-banner-img {
            width: 100%;
            height: 190px;
            border-radius: 14px;
            object-fit: cover;
            margin: 14px 0 18px 0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: transform 0.3s ease;
        }

        .day-banner-img:hover {
            transform: scale(1.01);
        }

        .activity-timeline { border-left: 2px solid #e2e8f0; padding-left: 20px; margin-left: 8px; }
        .activity-item { position: relative; margin-bottom: 20px; }
        .activity-item::before {
            content: '';
            position: absolute;
            left: -26px;
            top: 4px;
            width: 10px;
            height: 10px;
            background: var(--brand-blue);
            border-radius: 50%;
        }

        .activity-time { font-size: 0.78rem; font-weight: 700; color: #64748b; text-transform: uppercase; }
        .activity-title { font-weight: 700; color: var(--brand-dark); font-size: 1rem; margin: 2px 0 4px 0; }
        .activity-desc { color: #64748b; font-size: 0.88rem; margin: 0; }
        .ai-tag { background: #fff7ed; color: #c2410c; font-size: 0.72rem; font-weight: 700; padding: 2px 8px; border-radius: 6px; margin-left: 8px; }
        .map-pin-link { font-size: 0.78rem; font-weight: 700; color: #2563eb; text-decoration: none; margin-left: 8px; }
        .map-pin-link:hover { text-decoration: underline; }

        #printableTicket {
            background: #ffffff;
            color: #000000;
            padding: 24px;
            border: 2px solid var(--brand-blue);
            border-radius: 16px;
        }
    </style>

    <!-- Page Header -->
    <div class="page-header">
        <div class="d-flex align-items-center gap-2 mb-1">
            <h1 class="page-title m-0">Trip Planner ✈️</h1>
            <span class="badge brand-badge rounded-pill px-3 py-1 fs-8">
                ✨ Making Every Journey Memorable
            </span>
        </div>
        <p class="page-subtitle">Search any state or landmark across India, select your travel vibe, and build your fully verified itinerary.</p>
    </div>

    <!-- LIVE SEARCH BAR -->
    <div class="easy-search-card">
        <label class="form-label">Search Destination State, City, or Landmark</label>
        <div class="search-pill-input">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input type="text" id="easySearchInput" placeholder="Try typing 'Goa', 'Taj Mahal', 'Munnar', 'Golden Temple'..." oninput="handleLiveSearch(this.value)" list="destinationDatalist" />
            <button type="button" class="clear-search-btn" id="btnClearSearch" onclick="clearQuickSearch()">✕</button>
        </div>
    </div>

    <!-- Autocomplete Suggestions Datalist -->
    <datalist id="destinationDatalist">
        <option value="Delhi NCR"></option>
        <option value="Goa"></option>
        <option value="Kerala"></option>
        <option value="Rajasthan"></option>
        <option value="Himachal Pradesh"></option>
        <option value="Uttarakhand"></option>
        <option value="Ladakh"></option>
        <option value="Uttar Pradesh"></option>
        <option value="Karnataka"></option>
        <option value="Maharashtra"></option>
        <option value="Tamil Nadu"></option>
        <option value="Punjab"></option>
        <option value="Gujarat"></option>
        <option value="Madhya Pradesh"></option>
        <option value="Bihar"></option>
        <option value="West Bengal"></option>
    </datalist>

    <!-- Quick Popular State Cards with Real Images -->
    <label class="form-label mb-2">Trending Destinations Across India</label>
    <div class="popular-cards-grid">
        <div class="pop-card" onclick="selectStateCard('Delhi NCR')">
            <img src="https://images.unsplash.com/photo-1587474260584-136574528ed5?w=400" alt="Delhi" />
            <div class="pop-card-overlay"><h6 class="pop-card-title">Delhi NCR</h6></div>
        </div>
        <div class="pop-card" onclick="selectStateCard('Goa')">
            <img src="https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=400" alt="Goa" />
            <div class="pop-card-overlay"><h6 class="pop-card-title">Goa</h6></div>
        </div>
        <div class="pop-card" onclick="selectStateCard('Kerala')">
            <img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=400" alt="Kerala" />
            <div class="pop-card-overlay"><h6 class="pop-card-title">Kerala</h6></div>
        </div>
        <div class="pop-card" onclick="selectStateCard('Rajasthan')">
            <img src="https://images.unsplash.com/photo-1599661046289-e31897846e41?w=400" alt="Rajasthan" />
            <div class="pop-card-overlay"><h6 class="pop-card-title">Rajasthan</h6></div>
        </div>
        <div class="pop-card" onclick="selectStateCard('Himachal Pradesh')">
            <img src="https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=400" alt="Himachal" />
            <div class="pop-card-overlay"><h6 class="pop-card-title">Himachal</h6></div>
        </div>
        <div class="pop-card" onclick="selectStateCard('Uttarakhand')">
            <img src="https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?w=400" alt="Uttarakhand" />
            <div class="pop-card-overlay"><h6 class="pop-card-title">Uttarakhand</h6></div>
        </div>
        <div class="pop-card" onclick="selectStateCard('Ladakh')">
            <img src="https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=400" alt="Ladakh" />
            <div class="pop-card-overlay"><h6 class="pop-card-title">Ladakh</h6></div>
        </div>
        <div class="pop-card" onclick="selectStateCard('Uttar Pradesh')">
            <img src="https://images.unsplash.com/photo-1561361513-2d000a50f0dc?w=400" alt="Uttar Pradesh" />
            <div class="pop-card-overlay"><h6 class="pop-card-title">Uttar Pradesh</h6></div>
        </div>
    </div>

    <div class="form-card">
        <div class="row g-3 mb-3">
            <div class="col-md-4">
                <label class="form-label">Selected Destination State</label>
                <asp:DropDownList ID="ddlState" runat="server" ClientIDMode="Static" CssClass="form-select rounded-3">
                    <asp:ListItem Value="Delhi NCR">Delhi NCR (Red Fort, Qutub Minar, Old Delhi)</asp:ListItem>
                    <asp:ListItem Value="Goa">Goa (Panjim, Baga, Palolem)</asp:ListItem>
                    <asp:ListItem Value="Kerala">Kerala (Munnar, Alleppey, Kochi)</asp:ListItem>
                    <asp:ListItem Value="Rajasthan">Rajasthan (Jaipur, Udaipur, Jodhpur)</asp:ListItem>
                    <asp:ListItem Value="Himachal Pradesh">Himachal Pradesh (Manali, Shimla, Dharamshala)</asp:ListItem>
                    <asp:ListItem Value="Uttarakhand">Uttarakhand (Rishikesh, Nainital, Mussoorie)</asp:ListItem>
                    <asp:ListItem Value="Ladakh">Ladakh (Leh, Pangong, Nubra Valley)</asp:ListItem>
                    <asp:ListItem Value="Uttar Pradesh">Uttar Pradesh (Varanasi, Agra, Lucknow)</asp:ListItem>
                    <asp:ListItem Value="Karnataka">Karnataka (Coorg, Hampi, Bengaluru)</asp:ListItem>
                    <asp:ListItem Value="Maharashtra">Maharashtra (Mumbai, Lonavala, Mahabaleshwar)</asp:ListItem>
                    <asp:ListItem Value="Tamil Nadu">Tamil Nadu (Ooty, Madurai, Kodaikanal)</asp:ListItem>
                    <asp:ListItem Value="Punjab">Punjab (Amritsar, Ludhiana, Chandigarh)</asp:ListItem>
                    <asp:ListItem Value="Gujarat">Gujarat (Ahmedabad, Rann of Kutch, Statue of Unity)</asp:ListItem>
                    <asp:ListItem Value="Madhya Pradesh">Madhya Pradesh (Khajuraho, Bhopal, Indore)</asp:ListItem>
                    <asp:ListItem Value="Bihar">Bihar (Patna, Bodh Gaya, Nalanda)</asp:ListItem>
                    <asp:ListItem Value="West Bengal">West Bengal (Kolkata, Darjeeling, Sundarbans)</asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="col-md-3">
                <label class="form-label">Traveler Vibe</label>
                <asp:DropDownList ID="ddlTravelerType" runat="server" CssClass="form-select rounded-3">
                    <asp:ListItem Value="Couple">Couple / Romantic</asp:ListItem>
                    <asp:ListItem Value="Family">Family with Kids</asp:ListItem>
                    <asp:ListItem Value="Solo">Solo Explorer</asp:ListItem>
                    <asp:ListItem Value="Friends">Friends Group</asp:ListItem>
                    <asp:ListItem Value="Adventure">Adventure Seeker</asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="col-md-3">
                <label class="form-label">Trip Duration</label>
                <asp:DropDownList ID="ddlDuration" runat="server" CssClass="form-select rounded-3">
                    <asp:ListItem Value="3">3 Days (Weekend Break)</asp:ListItem>
                    <asp:ListItem Value="5" Selected="True">5 Days (Balanced Trip)</asp:ListItem>
                    <asp:ListItem Value="7">7 Days (Full Exploration)</asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="col-md-2">
                <label class="form-label">Pace</label>
                <asp:DropDownList ID="ddlPace" runat="server" CssClass="form-select rounded-3">
                    <asp:ListItem Value="Relaxed">Relaxed</asp:ListItem>
                    <asp:ListItem Value="Balanced" Selected="True">Balanced</asp:ListItem>
                    <asp:ListItem Value="Fast">Action-Packed</asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Personalize Daily Activities:</label>
            <div class="interest-chips">
                <div class="interest-chip-item">
                    <asp:CheckBox ID="chkFood" runat="server" Checked="true" />
                    <label for="<%= chkFood.ClientID %>">🍛 Indian Street Food & Local Dining</label>
                </div>
                <div class="interest-chip-item">
                    <asp:CheckBox ID="chkHistory" runat="server" Checked="true" />
                    <label for="<%= chkHistory.ClientID %>">🕌 Forts, Temples & Heritage</label>
                </div>
                <div class="interest-chip-item">
                    <asp:CheckBox ID="chkNature" runat="server" />
                    <label for="<%= chkNature.ClientID %>">🌿 Mountains & Parks</label>
                </div>
                <div class="interest-chip-item">
                    <asp:CheckBox ID="chkNightlife" runat="server" />
                    <label for="<%= chkNightlife.ClientID %>">🏖️ Nightlife & Lounges</label>
                </div>
                <div class="interest-chip-item">
                    <asp:CheckBox ID="chkShopping" runat="server" />
                    <label for="<%= chkShopping.ClientID %>">🛍️ Local Bazaars & Handicrafts</label>
                </div>
            </div>
        </div>

        <div class="text-end">
            <asp:Button ID="btnGenerateItinerary" runat="server" Text="Generate Custom Itinerary ✨" CssClass="btn-generate" OnClick="btnGenerateItinerary_Click" />
        </div>
    </div>

    <asp:Panel ID="pnlItinerary" runat="server" Visible="false">
        <asp:Panel ID="pnlNeighborState" runat="server" CssClass="neighbor-state-card">
            <div class="d-flex align-items-center gap-3">
                <i class="fa-solid fa-map-location-dot text-success fs-2"></i>
                <div>
                    <h6 class="fw-bold text-dark mb-1">🗺️ Explore Nearest Neighboring Region</h6>
                    <span class="fs-8 text-muted">
                        Visiting <asp:Label ID="lblCurrentSelectedState" runat="server"></asp:Label>? 
                        You can extend your trip into neighboring <strong class="text-success"><asp:Label ID="lblNearestStateName" runat="server"></asp:Label></strong> (<asp:Label ID="lblNearestStateDistance" runat="server"></asp:Label>).
                    </span>
                </div>
            </div>
            <asp:Button ID="btnExploreNeighbor" runat="server" CssClass="btn btn-sm btn-success rounded-3 fw-bold text-nowrap px-3" OnClick="btnExploreNeighbor_Click" Text="Plan Neighbor Trip ➔" />
        </asp:Panel>

        <!-- BOOKED SUMMARY BANNER FOR ACTIVE BOOKINGS -->
        <asp:Panel ID="pnlBookedSummaryBanner" runat="server" Visible="false" CssClass="booked-summary-banner">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                <div>
                    <h6 class="fw-bold text-dark m-0 mb-1">
                        <i class="fa-solid fa-circle-check text-success me-2"></i>Active Confirmed Booking Pass
                    </h6>
                    <span class="fs-8 text-muted">
                        Primary Traveler: <strong><asp:Label ID="lblBannerTraveler" runat="server"></asp:Label></strong> | 
                        Travel Date: <strong><asp:Label ID="lblBannerDate" runat="server"></asp:Label></strong> | 
                        Package: <strong><asp:Label ID="lblBannerPackage" runat="server"></asp:Label></strong>
                    </span>
                </div>
                <button type="button" class="btn btn-sm btn-dark rounded-3 fw-bold px-3" onclick="openBookingModal()">
                    <i class="fa-solid fa-ticket me-1"></i> Show Ticket Pass 🎫
                </button>
            </div>
        </asp:Panel>

        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
            <div>
                <h3 class="fw-bold text-dark m-0">
                    Itinerary for <asp:Label ID="lblResultDestination" runat="server"></asp:Label>
                </h3>
                <span class="badge brand-badge fw-bold px-3 py-2 rounded-pill fs-8 mt-1">
                    <asp:Label ID="lblResultMeta" runat="server"></asp:Label>
                </span>
            </div>

            <div class="d-flex gap-2">
                <button type="button" class="btn btn-dark rounded-3 fw-bold px-3" onclick="openBookingModal()">
                    <i class="fa-solid fa-ticket me-1"></i> Show Ticket 🎫
                </button>
                <button type="button" class="btn-book-trip" onclick="openBookingModal()">
                    Book This Trip ➔
                </button>
            </div>
        </div>

        <asp:Repeater ID="rptDays" runat="server">
            <ItemTemplate>
                <div class="itinerary-card">
                    <div class="d-flex justify-content-between align-items-center mb-2 flex-wrap gap-2">
                        <span class="day-badge"><%# Eval("DayTitle") %>: <%# Eval("DayTheme") %></span>
                        <span class="city-tag"><i class="fa-solid fa-city me-1"></i>Zone: <%# Eval("CityName") %></span>
                    </div>

                    <!-- Weather & Best Time Widget -->
                    <div class="weather-banner">
                        <%# Eval("WeatherWidget") %>
                    </div>

                    <img src='<%# Eval("DayImageUrl") %>' class="day-banner-img" alt="Destination Photo" />

                    <div class="activity-timeline">
                        <asp:Repeater ID="rptActivities" runat="server" DataSource='<%# Eval("Activities") %>'>
                            <ItemTemplate>
                                <div class="activity-item">
                                    <span class="activity-time"><%# Eval("TimeOfDay") %></span>
                                    <h6 class="activity-title">
                                        <%# Eval("Title") %>
                                        <span class="ai-tag" style='<%# Convert.ToBoolean(Eval("IsRecommended")) ? "display:inline-block;" : "display:none;" %>'>
                                            ⭐ Highlight
                                        </span>
                                        <!-- Map Pin Link -->
                                        <a href='https://www.google.com/maps/search/?api=1&query=<%# Server.UrlEncode(Eval("MapSearchQuery").ToString()) %>' target="_blank" class="map-pin-link">
                                            <i class="fa-solid fa-map-pin"></i> View on Map 🗺️
                                        </a>
                                    </h6>
                                    <p class="activity-desc"><%# Eval("Description") %></p>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </asp:Panel>

    <!-- BOOKING & MOCK PAYMENT MODAL POPUP -->
    <div class="modal fade" id="bookingModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header border-bottom-0 pb-0">
                    <h5 class="modal-title fw-bold text-dark" id="modalTitleText">
                        <i class="fa-solid fa-plane-departure text-success me-2"></i>Travel Planner Secure Booking
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                
                <div class="modal-body p-4">
                    <asp:Panel ID="pnlBookingSuccess" runat="server" Visible="false" CssClass="alert alert-success rounded-3 mb-3">
                        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                            <div>
                                <i class="fa-solid fa-circle-check me-2"></i>
                                <strong>Payment Received & Booking Confirmed!</strong> <asp:Label ID="lblSmsStatus" runat="server"></asp:Label>
                            </div>
                            <div class="d-flex gap-2">
                                <a href="MyTrips.aspx" class="btn btn-sm btn-primary rounded-3 fw-bold">View My Trips ➔</a>
                                <button type="button" class="btn btn-sm btn-dark rounded-3 fw-bold" onclick="downloadPDFTicket()">
                                    <i class="fa-solid fa-file-pdf text-danger me-1"></i> Download Ticket 📄
                                </button>
                            </div>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnlTicketSummary" runat="server" Visible="false" ClientIDMode="Static">
                        <div id="printableTicket" class="my-2">
                            <div class="text-center border-bottom pb-3 mb-3">
                                <h3 class="fw-bold text-primary m-0">✈️ Travel Planner Official E-Ticket</h3>
                                <p class="text-muted fs-8 m-0">Verified Booking Confirmation & Itinerary Pass</p>
                            </div>
                            <div class="row g-2 fs-7 mb-3">
                                <div class="col-6"><strong>Booking ID:</strong> <asp:Label ID="lblTicketId" runat="server"></asp:Label></div>
                                <div class="col-6"><strong>Primary Traveler:</strong> <asp:Label ID="lblTicketName" runat="server"></asp:Label></div>
                                <div class="col-6"><strong>Destination:</strong> <asp:Label ID="lblTicketDest" runat="server"></asp:Label></div>
                                <div class="col-6"><strong>Travel Date:</strong> <asp:Label ID="lblTicketDate" runat="server"></asp:Label></div>
                                <div class="col-6"><strong>Guests Count:</strong> <asp:Label ID="lblTicketGuests" runat="server"></asp:Label></div>
                                <div class="col-6"><strong>Package Type:</strong> <asp:Label ID="lblTicketMode" runat="server"></asp:Label></div>
                                <div class="col-6"><strong>Payment Status:</strong> <span class="badge bg-success">PAID</span></div>
                            </div>
                            <!-- BRAND MOTTO BANNER -->
                            <div class="alert alert-light border rounded-3 p-3 text-center m-0">
                                <h6 class="fw-bold text-primary mb-1">✨ Making Every Journey Memorable</h6>
                                <p class="text-muted fs-8 mb-0">Wish you a very Happy Journey! ✈️ Your booking is confirmed.</p>
                            </div>
                        </div>
                    </asp:Panel>

                    <div id="bookingStep1">
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label font-weight-bold">Full Name</label>
                                <asp:TextBox ID="txtBookerName" runat="server" CssClass="form-control rounded-3" Placeholder="Enter traveler's full name"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label font-weight-bold">Travel Date</label>
                                <asp:TextBox ID="txtTravelDate" runat="server" TextMode="Date" CssClass="form-control rounded-3"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label font-weight-bold">Number of Guests</label>
                                <asp:TextBox ID="txtGuestCount" runat="server" TextMode="Number" Text="1" CssClass="form-control rounded-3" OnKeyUp="calculatePrice()"></asp:TextBox>
                            </div>
                            
                            <div class="col-12">
                                <label class="form-label font-weight-bold">Select Budget & Accommodation Category</label>
                                <asp:DropDownList ID="ddlTravelMode" runat="server" CssClass="form-select rounded-3" onchange="calculatePrice()">
                                    <asp:ListItem Value="🎒 Backpacker Special (Hostel + Bus) - ₹1,499/person">🎒 Backpacker Special (Hostel Stay + Bus) — ₹1,499 / person</asp:ListItem>
                                    <asp:ListItem Value="🚆 Budget Express (Guesthouse + Train) - ₹3,499/person">🚆 Budget Express (Guesthouse + Train) — ₹3,499 / person</asp:ListItem>
                                    <asp:ListItem Value="🏨 Standard Comfort (3★ Hotel + Transport) - ₹6,999/person">🏨 Standard Comfort (3★ Hotel + Transport) — ₹6,999 / person</asp:ListItem>
                                    <asp:ListItem Value="✈️ Deluxe Package (4★ Hotel + Flight) - ₹12,999/person">✈️ Deluxe Package (4★ Hotel + Flight) — ₹12,999 / person</asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="col-12">
                                <label class="form-label font-weight-bold">
                                    <i class="fa-solid fa-phone text-primary me-1"></i> Enter Phone Number
                                </label>
                                <asp:TextBox ID="txtBookerPhone" runat="server" 
                                    CssClass="form-control rounded-3" 
                                    TextMode="Phone"
                                    MaxLength="10"
                                    Placeholder="Enter Phone Number" 
                                    pattern="[0-9]{10}">
                                </asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <div id="bookingStep2" style="display: none;">
                        <div class="alert alert-success border-0 rounded-3 mb-3 d-flex justify-content-between align-items-center">
                            <span class="fw-bold text-dark">Total Amount to Pay:</span>
                            <h4 class="fw-bold m-0 text-success" id="lblPayableAmount">₹1,499</h4>
                        </div>

                        <ul class="nav nav-pills nav-justified mb-3 gap-2" id="paymentTabs" role="tablist">
                            <li class="nav-item">
                                <button class="nav-link active fw-bold rounded-3 border" id="upi-tab" data-bs-toggle="pill" data-bs-target="#upiPayment" type="button" role="tab">
                                    <i class="fa-solid fa-qrcode me-1"></i> UPI / QR Code (Free)
                                </button>
                            </li>
                            <li class="nav-item">
                                <button class="nav-link fw-bold rounded-3 border" id="card-tab" data-bs-toggle="pill" data-bs-target="#cardPayment" type="button" role="tab">
                                    <i class="fa-solid fa-credit-card me-1"></i> Debit / Credit Card
                                </button>
                            </li>
                        </ul>

                        <div class="tab-content border rounded-3 p-3 bg-light">
                            <div class="tab-pane fade show active text-center" id="upiPayment" role="tabpanel">
                                <p class="text-muted fs-8 mb-2">Scan with Google Pay, PhonePe, Paytm, or BHIM UPI</p>
                                <div class="bg-white p-3 d-inline-block rounded-3 border shadow-sm mb-2">
                                    <img id="imgQrCode" src="https://api.qrserver.com/v1/create-qr-code/?size=160x160&data=upi://pay?pa=travelplanner@upi&pn=TravelPlanner&am=1499" alt="UPI QR Code" style="width: 150px; height: 150px;" />
                                </div>
                                <div class="text-center">
                                    <span class="badge bg-secondary-subtle text-dark fs-8">UPI ID: travelplanner@upi</span>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="cardPayment" role="tabpanel">
                                <div class="row g-2">
                                    <div class="col-12">
                                        <label class="form-label fs-8 fw-bold">Card Number</label>
                                        <input type="text" class="form-control rounded-3" placeholder="4532 •••• •••• 8921" maxlength="19" />
                                    </div>
                                    <div class="col-6">
                                        <label class="form-label fs-8 fw-bold">Expiry Date</label>
                                        <input type="text" class="form-control rounded-3" placeholder="MM/YY" maxlength="5" />
                                    </div>
                                    <div class="col-6">
                                        <label class="form-label fs-8 fw-bold">CVV Code</label>
                                        <input type="password" class="form-control rounded-3" placeholder="•••" maxlength="3" />
                                    </div>
                                    <div class="col-12 mt-2">
                                        <label class="form-label fs-8 fw-bold">Cardholder Name</label>
                                        <input type="text" class="form-control rounded-3" placeholder="Name on Card" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer border-top-0 pt-0">
                    <button type="button" class="btn btn-light rounded-3 fw-bold" id="btnBackStep" onclick="goToStep1()" style="display:none;">
                        ← Back
                    </button>
                    <button type="button" class="btn btn-primary rounded-3 fw-bold px-4" id="btnProceedPayment" onclick="goToStep2()">
                        Proceed to Payment ➔
                    </button>
                    
                    <asp:Button ID="btnConfirmBooking" runat="server" 
                        Text="Pay & Confirm Reservation ✓" 
                        CssClass="btn btn-success rounded-3 fw-bold px-4" 
                        Style="display:none;" 
                        OnClick="btnConfirmBooking_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- UI Helper Scripts -->
    <script type="text/javascript">
        function openBookingModal() {
            goToStep1();
            calculatePrice();
            var myModal = new bootstrap.Modal(document.getElementById('bookingModal'));
            myModal.show();
        }

        function calculatePrice() {
            var modeDropdown = document.getElementById('<%= ddlTravelMode.ClientID %>');
            var guestInput = document.getElementById('<%= txtGuestCount.ClientID %>');
            
            var guests = parseInt(guestInput.value) || 1;
            var selectedValue = modeDropdown.value;

            var pricePerPerson = 1499;
            if (selectedValue.includes('3,499')) pricePerPerson = 3499;
            else if (selectedValue.includes('6,999')) pricePerPerson = 6999;
            else if (selectedValue.includes('12,999')) pricePerPerson = 12999;

            var totalPrice = pricePerPerson * guests;
            
            document.getElementById('lblPayableAmount').innerText = '₹' + totalPrice.toLocaleString('en-IN');
            document.getElementById('imgQrCode').src = 'https://api.qrserver.com/v1/create-qr-code/?size=160x160&data=upi://pay?pa=travelplanner@upi&pn=TravelPlanner&am=' + totalPrice;
        }

        function goToStep1() {
            document.getElementById('bookingStep1').style.display = 'block';
            document.getElementById('bookingStep2').style.display = 'none';
            document.getElementById('btnProceedPayment').style.display = 'inline-block';
            document.getElementById('<%= btnConfirmBooking.ClientID %>').style.display = 'none';
            document.getElementById('btnBackStep').style.display = 'none';
            document.getElementById('modalTitleText').innerHTML = '<i class="fa-solid fa-plane-departure text-success me-2"></i>Travel Planner Secure Booking';
        }

        function goToStep2() {
            var nameInput = document.getElementById('<%= txtBookerName.ClientID %>').value.trim();
            var phoneInput = document.getElementById('<%= txtBookerPhone.ClientID %>').value.trim();

            if (nameInput === '' || phoneInput === '') {
                alert('Please enter your Name and Phone Number before proceeding to payment.');
                return;
            }

            calculatePrice();

            document.getElementById('bookingStep1').style.display = 'none';
            document.getElementById('bookingStep2').style.display = 'block';
            document.getElementById('btnProceedPayment').style.display = 'none';
            document.getElementById('<%= btnConfirmBooking.ClientID %>').style.display = 'inline-block';
            document.getElementById('btnBackStep').style.display = 'inline-block';
            document.getElementById('modalTitleText').innerHTML = '<i class="fa-solid fa-lock text-primary me-2"></i>Travel Planner Secure Checkout';
        }

        function downloadPDFTicket() {
            const { jsPDF } = window.jspdf;
            const element = document.getElementById('printableTicket');
            if (!element) return;

            html2canvas(element, { scale: 2 }).then(canvas => {
                const imgData = canvas.toDataURL('image/png');
                const pdf = new jsPDF('p', 'mm', 'a4');
                const imgWidth = 190;
                const imgHeight = (canvas.height * imgWidth) / canvas.width;

                pdf.addImage(imgData, 'PNG', 10, 10, imgWidth, imgHeight);
                pdf.save('TravelPlanner_Confirmation_Ticket.pdf');
            });
        }

        function handleLiveSearch(query) {
            const clearBtn = document.getElementById('btnClearSearch');
            if (clearBtn) clearBtn.style.display = query.length > 0 ? 'inline-block' : 'none';

            const cleanQuery = query.toLowerCase().trim();
            if (!cleanQuery) return;

            const ddl = document.getElementById('<%= ddlState.ClientID %>');
            if (ddl) {
                for (let i = 0; i < ddl.options.length; i++) {
                    if (ddl.options[i].value.toLowerCase().includes(cleanQuery)) {
                        ddl.selectedIndex = i;
                        break;
                    }
                }
            }
        }

        function selectStateCard(stateName) {
            const ddl = document.getElementById('<%= ddlState.ClientID %>');
            const searchInput = document.getElementById('easySearchInput');
            if (searchInput) searchInput.value = stateName;

            if (ddl) {
                for (let i = 0; i < ddl.options.length; i++) {
                    if (ddl.options[i].value.toLowerCase().includes(stateName.toLowerCase())) {
                        ddl.selectedIndex = i;
                        break;
                    }
                }
            }
        }

        function clearQuickSearch() {
            const input = document.getElementById('easySearchInput');
            const clearBtn = document.getElementById('btnClearSearch');
            if (input) input.value = '';
            if (clearBtn) clearBtn.style.display = 'none';
        }
    </script>
</asp:Content>