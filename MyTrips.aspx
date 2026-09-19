<%@ Page Title="My Trips & Stays" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyTrips.aspx.cs" Inherits="AI_Travel_Planner.MyTrips" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 16px;
        }

        .page-title {
            font-weight: 800;
            font-size: 1.8rem;
            margin-bottom: 4px;
            color: var(--text-dark, #0f172a);
        }

        .page-subtitle {
            color: var(--text-muted, #64748b);
            font-size: 0.95rem;
            margin: 0;
        }

        .btn-create-trip {
            background-color: var(--primary-blue, #2563eb);
            color: #ffffff !important;
            border: none;
            padding: 10px 22px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 0.9rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.22);
            transition: all 0.2s ease;
        }

        .btn-create-trip:hover {
            background-color: #1d4ed8;
            transform: translateY(-2px);
        }

        .filter-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 24px;
            border-bottom: 1px solid var(--border-color, #e2e8f0);
            padding-bottom: 12px;
            overflow-x: auto;
        }

        .tab-btn {
            background: var(--card-bg, #ffffff);
            border: 1px solid var(--border-color, #cbd5e1);
            padding: 8px 18px;
            border-radius: 20px;
            font-size: 0.88rem;
            font-weight: 600;
            color: var(--text-muted, #64748b);
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s ease;
            white-space: nowrap;
            display: inline-block;
        }

        .tab-btn:hover {
            background: var(--hover-bg, #f8fafc);
            color: var(--text-dark, #0f172a);
        }

        .tab-btn.active {
            background: var(--primary-blue, #2563eb);
            color: #ffffff !important;
            border-color: var(--primary-blue, #2563eb);
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.25);
        }

        .trips-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 22px;
        }

        .trip-card {
            background: var(--card-bg, #ffffff);
            border-radius: 20px;
            border: 1px solid var(--border-color, #e2e8f0);
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .trip-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 24px rgba(0,0,0,0.08);
        }

        .trip-image-wrapper {
            position: relative;
            height: 180px;
            width: 100%;
            overflow: hidden;
        }

        .trip-image-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .trip-card:hover .trip-image-wrapper img {
            transform: scale(1.04);
        }

        .trip-status-badge {
            position: absolute;
            top: 14px;
            left: 14px;
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            backdrop-filter: blur(6px);
        }

        .status-upcoming { background: rgba(37, 99, 235, 0.9); color: #ffffff; }
        .status-active { background: rgba(22, 163, 74, 0.9); color: #ffffff; }
        .status-completed { background: rgba(100, 116, 139, 0.85); color: #ffffff; }

        .btn-delete-trigger {
            position: absolute;
            top: 14px;
            right: 14px;
            background: #ffffff;
            color: #ef4444;
            border: none;
            width: 34px;
            height: 34px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            transition: all 0.2s ease;
            z-index: 10;
        }

        .btn-delete-trigger:hover {
            transform: scale(1.1);
            background: #fef2f2;
            color: #dc2626;
        }

        .trip-body {
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .trip-title {
            font-weight: 800;
            font-size: 1.15rem;
            color: var(--text-dark, #0f172a);
            margin-bottom: 6px;
        }

        .trip-meta {
            color: var(--text-muted, #64748b);
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 14px;
        }

        .trip-meta i {
            color: var(--primary-blue, #2563eb);
        }

        .booking-summary-box {
            background: var(--hover-bg, #f8fafc);
            border-radius: 12px;
            padding: 10px 14px;
            margin-bottom: 16px;
            border: 1px dashed var(--border-color, #cbd5e1);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .booking-summary-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .booking-summary-info i {
            font-size: 1.1rem;
            color: #16a34a;
        }

        .trip-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 14px;
            border-top: 1px solid var(--border-color, #e2e8f0);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: var(--card-bg, #ffffff);
            border-radius: 20px;
            border: 1px dashed var(--border-color, #cbd5e1);
            margin-top: 20px;
            grid-column: 1 / -1;
        }

        .empty-state i {
            font-size: 3rem;
            color: var(--text-muted, #94a3b8);
            margin-bottom: 12px;
        }
    </style>

    <div class="page-header">
        <div>
            <h1 class="page-title">My Trips & Stays 🧳</h1>
            <p class="page-subtitle">View active itineraries, manage flight/hotel tickets, and explore upcoming vacations.</p>
        </div>
        <a href="TripPlanner.aspx" class="btn-create-trip">
            <i class="fa-solid fa-wand-magic-sparkles"></i> Plan New Trip
        </a>
    </div>

    <!-- Hidden Field for storing selected trip ID to delete -->
    <asp:HiddenField ID="hfDeleteTripId" runat="server" ClientIDMode="Static" />

    <!-- Filter Tabs -->
    <div class="filter-tabs">
        <asp:LinkButton ID="btnFilterAll" runat="server" CssClass="tab-btn active" OnClick="Filter_Click" CommandArgument="All">All Journeys</asp:LinkButton>
        <asp:LinkButton ID="btnFilterUpcoming" runat="server" CssClass="tab-btn" OnClick="Filter_Click" CommandArgument="Upcoming">✈️ Upcoming</asp:LinkButton>
        <asp:LinkButton ID="btnFilterActive" runat="server" CssClass="tab-btn" OnClick="Filter_Click" CommandArgument="Active">🟢 Active Now</asp:LinkButton>
        <asp:LinkButton ID="btnFilterCompleted" runat="server" CssClass="tab-btn" OnClick="Filter_Click" CommandArgument="Completed">🏁 Completed</asp:LinkButton>
    </div>

    <!-- Trips Grid Container -->
    <asp:Panel ID="pnlTripsGrid" runat="server" CssClass="trips-grid">
        <asp:Repeater ID="rptTrips" runat="server">
            <ItemTemplate>
                <div class="trip-card">
                    <div class="trip-image-wrapper">
                        <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Destination") %>' />
                        <span class='<%# GetStatusBadgeCss(Eval("Status").ToString()) %>'>
                            <%# Eval("Status") %>
                        </span>

                        <!-- Trash button opens custom Bootstrap Modal instead of browser alert -->
                        <button type="button" class="btn-delete-trigger" 
                                onclick="openDeleteModal('<%# Eval("TripId") %>', '<%# Eval("TripTitle") %>')" 
                                title="Delete Trip">
                            <i class="fa-solid fa-trash-can"></i>
                        </button>
                    </div>

                    <div class="trip-body">
                        <div>
                            <h5 class="trip-title"><%# Eval("TripTitle") %></h5>
                            <div class="trip-meta">
                                <span><i class="fa-solid fa-calendar-days"></i> <%# Eval("Dates") %></span>
                                <span><i class="fa-solid fa-user-group"></i> <%# Eval("Travelers") %></span>
                            </div>

                            <div class="booking-summary-box">
                                <div class="booking-summary-info">
                                    <i class="fa-solid fa-circle-check"></i>
                                    <div>
                                        <span class="d-block fw-bold fs-8 text-dark"><%# Eval("BookingType") %></span>
                                        <span class="fs-9 text-muted"><%# Eval("BookingDetails") %></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="trip-footer">
                            <span class="fw-extrabold fs-7 text-primary"><%# Eval("EstimatedBudget") %></span>
                            <div class="d-flex gap-2">
                                <button type="button" class="btn btn-sm btn-dark rounded-3 fs-9 fw-bold px-3"
                                        onclick="openTicketModal('<%# Eval("TripTitle") %>', '<%# Eval("BookingType") %>', '<%# Eval("PnrCode") %>', '<%# Eval("BookingDetails") %>')">
                                    <i class="fa-solid fa-ticket me-1"></i> Show Ticket 🎫
                                </button>
                                <a href='<%# "TripPlanner.aspx?dest=" + Server.UrlEncode(Eval("Destination").ToString()) %>' class="btn btn-sm btn-primary rounded-3 fw-bold px-3">View Details</a>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </asp:Panel>

    <!-- Empty State Panel -->
    <asp:Panel ID="pnlEmptyState" runat="server" Visible="false" CssClass="empty-state">
        <i class="fa-solid fa-plane-slash"></i>
        <h5 class="fw-bold text-dark mb-1">No trips found in this category</h5>
        <p class="text-muted fs-8 mb-3">Ready to plan your next escape? Let our AI generate a custom itinerary in seconds.</p>
        <a href="TripPlanner.aspx" class="btn btn-primary rounded-3 fw-bold px-4">Create Itinerary</a>
    </asp:Panel>

    <!-- CUSTOM BOOTSTRAP DELETE CONFIRMATION MODAL -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header border-bottom-0 pb-0">
                    <h5 class="modal-title fw-bold text-danger">
                        <i class="fa-solid fa-trash-can me-2"></i>Delete Trip Itinerary
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4 text-center">
                    <i class="fa-solid fa-triangle-exclamation text-danger fs-1 mb-3"></i>
                    <h5 class="fw-bold text-dark mb-2">Are you sure you want to delete this trip?</h5>
                    <p class="text-muted fs-8 mb-0" id="lblDeleteModalText">This action cannot be undone and will permanently remove this itinerary from your account.</p>
                </div>
                <div class="modal-footer border-top-0 pt-0 justify-content-center">
                    <button type="button" class="btn btn-light rounded-3 fw-bold px-4" data-bs-dismiss="modal">Cancel</button>
                    <!-- Trigger Server-Side Delete Event -->
                    <asp:Button ID="btnConfirmDeleteServer" runat="server" 
                        Text="Yes, Delete Trip 🗑️" 
                        CssClass="btn btn-danger rounded-3 fw-bold px-4" 
                        OnClick="btnConfirmDeleteServer_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- Digital Ticket & Voucher Modal -->
    <div class="modal fade" id="ticketModal" tabindex="-1" aria-labelledby="ticketModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header bg-primary text-white border-0 py-3">
                    <h6 class="modal-title fw-bold" id="ticketModalLabel">🎫 Booking Voucher Details</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="text-center mb-3">
                        <i class="fa-solid fa-ticket fs-1 text-primary mb-2"></i>
                        <h5 class="fw-extrabold text-dark" id="modalTripTitle">Trip Title</h5>
                        <span class="badge bg-success-subtle text-success fw-bold px-3 py-1 fs-9">CONFIRMED & ISSUED</span>
                    </div>

                    <div class="bg-light p-3 rounded-3 mb-3 border">
                        <div class="row g-2 fs-8">
                            <div class="col-6">
                                <span class="text-muted d-block">Booking Category</span>
                                <strong id="modalBookingType" class="text-dark">Flight</strong>
                            </div>
                            <div class="col-6 text-end">
                                <span class="text-muted d-block">PNR / Ref Code</span>
                                <strong id="modalPnrCode" class="text-primary fs-7">AI-984210</strong>
                            </div>
                            <div class="col-12 mt-2 pt-2 border-top">
                                <span class="text-muted d-block">Details</span>
                                <span id="modalBookingDetails" class="fw-semibold text-dark">IndiGo Flight 6E-204</span>
                            </div>
                        </div>
                    </div>
                    <p class="text-muted fs-9 text-center mb-0">Present this reference code or digital voucher upon check-in.</p>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-light rounded-3 fw-bold fs-8" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary rounded-3 fw-bold fs-8" onclick="window.print()">Print Ticket Pass</button>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript Handlers -->
    <script type="text/javascript">
        function openDeleteModal(tripId, tripTitle) {
            document.getElementById('hfDeleteTripId').value = tripId;
            document.getElementById('lblDeleteModalText').innerText = 'You are about to delete: "' + tripTitle + '". This trip will be removed from your account.';

            var modalElement = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
            modalElement.show();
        }

        function openTicketModal(title, type, pnr, details) {
            document.getElementById('modalTripTitle').innerText = title;
            document.getElementById('modalBookingType').innerText = type;
            document.getElementById('modalPnrCode').innerText = pnr;
            document.getElementById('modalBookingDetails').innerText = details;

            var modalElement = new bootstrap.Modal(document.getElementById('ticketModal'));
            modalElement.show();
        }
    </script>
</asp:Content>