<%@ Page Title="Bookings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Bookings.aspx.cs" Inherits="AI_Travel_Planner.Bookings" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .page-title {
            font-weight: 800;
            font-size: 1.8rem;
            margin-bottom: 4px;
            color: #0f172a;
        }

        .page-subtitle {
            color: #64748b;
            font-size: 0.95rem;
            margin: 0;
        }

        /* Filter Tab Buttons */
        .filter-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 24px;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 12px;
        }

        .tab-btn {
            background: #ffffff;
            border: 1px solid #cbd5e1;
            padding: 8px 18px;
            border-radius: 20px;
            font-size: 0.88rem;
            font-weight: 600;
            color: #64748b;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s ease;
            display: inline-block;
        }

        .tab-btn:hover {
            background: #f1f5f9;
            color: #0f172a;
        }

        .tab-btn.active {
            background: #2563eb;
            color: #ffffff !important;
            border-color: #2563eb;
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.25);
        }

        /* Booking Cards */
        .booking-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 20px;
            border: 1px solid #e2e8f0;
            margin-bottom: 16px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.02);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .booking-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.05);
        }

        .booking-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 14px;
        }

        .booking-icon-wrapper {
            width: 44px;
            height: 44px;
            min-width: 44px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }

        /* Status Badges */
        .badge-status {
            font-weight: 700;
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 0.78rem;
            display: inline-block;
        }

        .badge-confirmed { background: #dcfce7; color: #15803d; }
        .badge-pending { background: #fef9c3; color: #a16207; }
        .badge-cancelled { background: #fee2e2; color: #b91c1c; }

        /* Detail Grid */
        .booking-details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            padding-top: 12px;
            border-top: 1px dashed #f1f5f9;
            margin-top: 14px;
        }

        .detail-item {
            font-size: 0.85rem;
        }

        .detail-item .label {
            color: #64748b;
            font-size: 0.78rem;
            display: block;
            margin-bottom: 2px;
        }

        .detail-item .val {
            font-weight: 700;
            color: #0f172a;
        }

        .add-booking-btn {
            background: #2563eb;
            color: #ffffff;
            border: none;
            padding: 10px 20px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 0.9rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: background 0.2s ease;
        }

        .add-booking-btn:hover {
            background: #1d4ed8;
            color: #ffffff;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: #ffffff;
            border-radius: 16px;
            border: 1px dashed #cbd5e1;
            margin-top: 20px;
        }

        .empty-state i {
            font-size: 3rem;
            color: #cbd5e1;
            margin-bottom: 12px;
        }
    </style>

    <!-- Auto-Complete Indian States, Major Cities & Global Hubs Datalist -->
    <datalist id="locationSuggestions">
        <!-- Major Indian Transit Hubs & Metros -->
        <option value="Delhi (DEL), Delhi NCR"></option>
        <option value="Mumbai (BOM), Maharashtra"></option>
        <option value="Bangalore (BLR), Karnataka"></option>
        <option value="Chennai (MAA), Tamil Nadu"></option>
        <option value="Kolkata (CCU), West Bengal"></option>
        <option value="Hyderabad (HYD), Telangana"></option>
        <option value="Ahmedabad (AMD), Gujarat"></option>
        <option value="Pune (PNQ), Maharashtra"></option>
        <option value="Goa (GOI / GOX)"></option>

        <!-- Indian States -->
        <option value="Andhra Pradesh"></option>
        <option value="Arunachal Pradesh"></option>
        <option value="Assam"></option>
        <option value="Bihar"></option>
        <option value="Chhattisgarh"></option>
        <option value="Goa"></option>
        <option value="Gujarat"></option>
        <option value="Haryana"></option>
        <option value="Himachal Pradesh"></option>
        <option value="Jharkhand"></option>
        <option value="Karnataka"></option>
        <option value="Kerala"></option>
        <option value="Madhya Pradesh"></option>
        <option value="Maharashtra"></option>
        <option value="Manipur"></option>
        <option value="Meghalaya"></option>
        <option value="Mizoram"></option>
        <option value="Nagaland"></option>
        <option value="Odisha"></option>
        <option value="Punjab"></option>
        <option value="Rajasthan"></option>
        <option value="Sikkim"></option>
        <option value="Tamil Nadu"></option>
        <option value="Telangana"></option>
        <option value="Tripura"></option>
        <option value="Uttar Pradesh"></option>
        <option value="Uttarakhand"></option>
        <option value="West Bengal"></option>

        <!-- Popular Indian Tourist Cities & Capitals -->
        <option value="Jaipur, Rajasthan"></option>
        <option value="Udaipur, Rajasthan"></option>
        <option value="Jodhpur, Rajasthan"></option>
        <option value="Varanasi, Uttar Pradesh"></option>
        <option value="Agra, Uttar Pradesh"></option>
        <option value="Lucknow, Uttar Pradesh"></option>
        <option value="Kochi (COK), Kerala"></option>
        <option value="Munnar, Kerala"></option>
        <option value="Thiruvananthapuram, Kerala"></option>
        <option value="Shimla, Himachal Pradesh"></option>
        <option value="Manali, Himachal Pradesh"></option>
        <option value="Dharamsala, Himachal Pradesh"></option>
        <option value="Srinagar, Jammu & Kashmir"></option>
        <option value="Leh, Ladakh"></option>
        <option value="Dehradun, Uttarakhand"></option>
        <option value="Rishikesh, Uttarakhand"></option>
        <option value="Haridwar, Uttarakhand"></option>
        <option value="Darjeeling, West Bengal"></option>
        <option value="Gangtok, Sikkim"></option>
        <option value="Shillong, Meghalaya"></option>
        <option value="Guwahati, Assam"></option>
        <option value="Bhopal, Madhya Pradesh"></option>
        <option value="Indore, Madhya Pradesh"></option>
        <option value="Patna, Bihar"></option>
        <option value="Ranchi, Jharkhand"></option>
        <option value="Chandigarh"></option>
        <option value="Mysore, Karnataka"></option>
        <option value="Ooty, Tamil Nadu"></option>
        <option value="Kodaikanal, Tamil Nadu"></option>
        <option value="Madurai, Tamil Nadu"></option>

        <!-- Global International Hubs -->
        <option value="Paris (CDG), France"></option>
        <option value="Bali (DPS), Indonesia"></option>
        <option value="London (LHR), UK"></option>
        <option value="Tokyo (HND), Japan"></option>
        <option value="New York (JFK), USA"></option>
        <option value="Dubai (DXB), UAE"></option>
        <option value="Singapore (SIN)"></option>
        <option value="Rome (FCO), Italy"></option>
        <option value="Santorini, Greece"></option>
    </datalist>

    <!-- Page Title Header -->
    <div class="page-header">
        <div>
            <h1 class="page-title">My Bookings</h1>
            <p class="page-subtitle">Manage all your flight, hotel, and activity reservations in one place.</p>
        </div>
        <button type="button" class="add-booking-btn" data-bs-toggle="modal" data-bs-target="#addBookingModal">
            <i class="fa-solid fa-plus"></i> Add Booking
        </button>
    </div>

    <!-- Category Filter Buttons -->
    <div class="filter-tabs">
        <asp:LinkButton ID="btnFilterAll" runat="server" CssClass="tab-btn active" OnClick="Filter_Click" CommandArgument="All">All Bookings</asp:LinkButton>
        <asp:LinkButton ID="btnFilterFlights" runat="server" CssClass="tab-btn" OnClick="Filter_Click" CommandArgument="Flight">Flights</asp:LinkButton>
        <asp:LinkButton ID="btnFilterHotels" runat="server" CssClass="tab-btn" OnClick="Filter_Click" CommandArgument="Hotel">Hotels</asp:LinkButton>
        <asp:LinkButton ID="btnFilterTransfers" runat="server" CssClass="tab-btn" OnClick="Filter_Click" CommandArgument="Transfer">Transfers & Activities</asp:LinkButton>
    </div>

    <!-- Bookings Repeater Control -->
    <asp:Repeater ID="rptBookings" runat="server">
        <ItemTemplate>
            <div class="booking-card">
                <div class="booking-card-header">
                    <div class="d-flex align-items-center gap-3">
                        <div class="booking-icon-wrapper" style='<%# Eval("IconStyle") %>'>
                            <i class='<%# Eval("IconClass") %>'></i>
                        </div>
                        <div>
                            <h5 class="fw-bold mb-1 fs-6"><%# Eval("Title") %></h5>
                            <span class="text-muted fs-8"><%# Eval("BookingRef") %></span>
                        </div>
                    </div>
                    <div>
                        <span class='<%# GetStatusBadgeCss(Eval("Status").ToString()) %>'>
                            <%# Eval("Status") %>
                        </span>
                    </div>
                </div>

                <div class="booking-details-grid">
                    <div class="detail-item">
                        <span class="label">Date / Time</span>
                        <span class="val"><%# Eval("BookingDate") %></span>
                    </div>
                    <div class="detail-item">
                        <span class="label">Provider / Location</span>
                        <span class="val"><%# Eval("Provider") %></span>
                    </div>
                    <div class="detail-item">
                        <span class="label">Guests / Details</span>
                        <span class="val"><%# Eval("GuestDetails") %></span>
                    </div>
                    <div class="detail-item">
                        <span class="label">Total Price</span>
                        <span class="val text-primary"><%# Eval("Price") %></span>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>

    <!-- Empty State Panel -->
    <asp:Panel ID="pnlEmptyState" runat="server" Visible="false" CssClass="empty-state">
        <i class="fa-solid fa-ticket"></i>
        <h5 class="fw-bold text-dark mb-1">No bookings found</h5>
        <p class="text-muted fs-8 mb-0">There are no bookings matching the selected category.</p>
    </asp:Panel>

    <!-- Simplified Add Booking Modal -->
    <div class="modal fade" id="addBookingModal" tabindex="-1" aria-labelledby="addBookingModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold text-dark" id="addBookingModalLabel">Quick Add Booking</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold fs-8">Type of Booking</label>
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select rounded-3">
                            <asp:ListItem Value="Flight">Flight</asp:ListItem>
                            <asp:ListItem Value="Hotel">Hotel</asp:ListItem>
                            <asp:ListItem Value="Transfer">Transfer / Tour</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Source and Destination Inputs with Live Suggest Search -->
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold fs-8">From (Source)</label>
                            <asp:TextBox ID="txtSource" runat="server" CssClass="form-control rounded-3" Placeholder="Type state or city..." list="locationSuggestions"></asp:TextBox>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold fs-8">To (Destination)</label>
                            <asp:TextBox ID="txtDestination" runat="server" CssClass="form-control rounded-3" Placeholder="Type state or city..." list="locationSuggestions"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold fs-8">Travel Date</label>
                            <asp:TextBox ID="txtDate" runat="server" TextMode="Date" CssClass="form-control rounded-3"></asp:TextBox>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold fs-8">Total Price</label>
                            <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control rounded-3" Placeholder="e.g. ₹15,000"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold fs-8">Provider / Airline / Hotel Name (Optional)</label>
                        <asp:TextBox ID="txtProvider" runat="server" CssClass="form-control rounded-3" Placeholder="e.g. Air India or Taj Hotel"></asp:TextBox>
                    </div>
                </div>

                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-light rounded-3 fw-bold" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSaveBooking" runat="server" Text="Add Booking" CssClass="btn btn-primary rounded-3 fw-bold px-4" OnClick="btnSaveBooking_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>