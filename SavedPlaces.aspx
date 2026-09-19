<%@ Page Title="Saved Places" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SavedPlaces.aspx.cs" Inherits="AI_Travel_Planner.SavedPlaces" %>

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
            color: #0f172a;
        }

        .page-subtitle {
            color: #64748b;
            font-size: 0.95rem;
            margin: 0;
        }

        /* Search Bar & Action Buttons */
        .search-action-bar {
            display: flex;
            gap: 12px;
            align-items: center;
            width: 100%;
            max-width: 600px;
        }

        .search-box-group {
            display: flex;
            background: #ffffff;
            border-radius: 14px;
            padding: 4px 4px 4px 16px;
            border: 1px solid #cbd5e1;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            flex-grow: 1;
            align-items: center;
        }

        .search-box-group i {
            color: #94a3b8;
            font-size: 1rem;
            margin-right: 10px;
        }

        .search-box-group input[type="text"] {
            border: none !important;
            outline: none !important;
            box-shadow: none !important;
            flex-grow: 1;
            font-size: 0.9rem;
            color: #0f172a;
            background: transparent;
        }

        .btn-search-trigger {
            background: #2563eb;
            color: #ffffff;
            border: none;
            padding: 8px 18px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.85rem;
            cursor: pointer;
            white-space: nowrap;
            transition: background 0.2s ease;
        }

        .btn-search-trigger:hover {
            background: #1d4ed8;
        }

        .btn-add-modal {
            background: #ffffff;
            color: #0f172a;
            border: 1px solid #cbd5e1;
            padding: 10px 18px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 0.88rem;
            cursor: pointer;
            white-space: nowrap;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-add-modal:hover {
            background: #f8fafc;
            border-color: #94a3b8;
        }

        /* Category Filter Tabs */
        .filter-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 24px;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 12px;
            overflow-x: auto;
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
            white-space: nowrap;
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

        /* Places Grid */
        .places-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .place-card {
            background: #ffffff;
            border-radius: 18px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            box-shadow: 0 2px 6px rgba(0,0,0,0.02);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            display: flex;
            flex-direction: column;
        }

        .place-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.06);
        }

        .place-img-wrapper {
            position: relative;
            height: 180px;
            width: 100%;
            overflow: hidden;
            background: #f1f5f9;
        }

        .place-img-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .place-card:hover .place-img-wrapper img {
            transform: scale(1.04);
        }

        .category-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            background: rgba(15, 23, 42, 0.75);
            backdrop-filter: blur(4px);
            color: #ffffff;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 12px;
        }

        .remove-btn {
            position: absolute;
            top: 12px;
            right: 12px;
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
            text-decoration: none;
        }

        .remove-btn:hover {
            transform: scale(1.1);
            background: #fef2f2;
            color: #dc2626;
        }

        .place-body {
            padding: 18px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .place-title {
            font-weight: 800;
            font-size: 1.05rem;
            color: #0f172a;
            margin-bottom: 4px;
        }

        .place-location {
            color: #64748b;
            font-size: 0.85rem;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .place-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 12px;
            border-top: 1px dashed #f1f5f9;
        }

        .rating-badge {
            color: #eab308;
            font-weight: 700;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: #ffffff;
            border-radius: 16px;
            border: 1px dashed #cbd5e1;
            margin-top: 20px;
            grid-column: 1 / -1;
        }

        .empty-state i {
            font-size: 3rem;
            color: #cbd5e1;
            margin-bottom: 12px;
        }
    </style>

    <datalist id="indianDestinationsList">
        <option value="Taj Mahal, Agra"></option>
        <option value="Amber Fort, Jaipur"></option>
        <option value="Baga Beach, Goa"></option>
        <option value="Palolem Beach, Goa"></option>
        <option value="Taj Lake Palace, Udaipur"></option>
        <option value="Alleppey Houseboats, Kerala"></option>
        <option value="Golden Temple, Amritsar"></option>
    </datalist>

    <div class="page-header">
        <div>
            <h1 class="page-title">Saved Places 📍</h1>
            <p class="page-subtitle">Search your saved places or add new Indian destinations.</p>
        </div>

        <div class="search-action-bar">
            <div class="search-box-group">
                <i class="fa-solid fa-magnifying-glass"></i>
                <asp:TextBox ID="txtSearchDestination" runat="server" ClientIDMode="Static" Placeholder="Search by city, landmark, or category..." list="indianDestinationsList" onkeyup="filterPlacesOnClient()"></asp:TextBox>
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn-search-trigger" OnClick="btnSearch_Click" />
            </div>

            <button type="button" class="btn-add-modal" data-bs-toggle="modal" data-bs-target="#addPlaceModal">
                <i class="fa-solid fa-plus text-primary"></i> Add
            </button>
        </div>
    </div>

    <div class="filter-tabs">
        <asp:LinkButton ID="btnFilterAll" runat="server" CssClass="tab-btn active" OnClick="Filter_Click" CommandArgument="All">All Saved</asp:LinkButton>
        <asp:LinkButton ID="btnFilterAttractions" runat="server" CssClass="tab-btn" OnClick="Filter_Click" CommandArgument="Attraction">🏛️ Attractions</asp:LinkButton>
        <asp:LinkButton ID="btnFilterRestaurants" runat="server" CssClass="tab-btn" OnClick="Filter_Click" CommandArgument="Restaurant">🍽️ Restaurants & Cafes</asp:LinkButton>
        <asp:LinkButton ID="btnFilterHotels" runat="server" CssClass="tab-btn" OnClick="Filter_Click" CommandArgument="Hotel">🏨 Hotels & Stays</asp:LinkButton>
        <asp:LinkButton ID="btnFilterBeaches" runat="server" CssClass="tab-btn" OnClick="Filter_Click" CommandArgument="Beach">🏖️ Beaches & Nature</asp:LinkButton>
    </div>

    <asp:Panel ID="pnlPlacesGrid" runat="server" CssClass="places-grid" ClientIDMode="Static">
        <asp:Repeater ID="rptPlaces" runat="server">
            <ItemTemplate>
                <div class="place-card" data-title='<%# Eval("Name") %>' data-city='<%# Eval("City") %>' data-category='<%# Eval("Category") %>'>
                    <div class="place-img-wrapper">
                        <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Name") %>' />
                        <span class="category-badge"><%# Eval("Category") %></span>
                        <a href="javascript:void(0);" class="remove-btn" onclick="openDeleteModal('<%# Eval("Id") %>')" title="Remove from saved">
                            <i class="fa-solid fa-trash-can"></i>
                        </a>
                    </div>
                    <div class="place-body">
                        <div>
                            <h5 class="place-title"><%# Eval("Name") %></h5>
                            <div class="place-location">
                                <i class="fa-solid fa-location-dot text-danger"></i>
                                <span><%# Eval("City") %></span>
                            </div>
                        </div>
                        <div class="place-footer">
                            <span class="rating-badge">
                                <i class="fa-solid fa-star"></i> <%# Eval("Rating") %>
                            </span>
                            <span class="text-muted fs-8"><%# Eval("Notes") %></span>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </asp:Panel>

    <asp:Panel ID="pnlEmptyState" runat="server" Visible="false" CssClass="empty-state" ClientIDMode="Static">
        <i class="fa-solid fa-bookmark"></i>
        <h5 class="fw-bold text-dark mb-1">No saved places found</h5>
        <p class="text-muted fs-8 mb-0">Try searching for a different landmark or add a new place.</p>
    </asp:Panel>

    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 18px;">
                <div class="modal-body text-center p-4">
                    <div class="text-danger mb-3" style="font-size: 2.5rem;">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                    </div>
                    <h5 class="fw-bold text-dark mb-2" id="deleteModalLabel">Remove Destination?</h5>
                    <p class="text-muted fs-8 mb-4">Are you sure you want to remove this place from your saved list?</p>
                    <div class="d-flex justify-content-center gap-2">
                        <button type="button" class="btn btn-light rounded-pill px-3 fw-bold fs-8" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnConfirmDelete" runat="server" Text="Yes, Remove" CssClass="btn btn-danger rounded-pill px-3 fw-bold fs-8 shadow-sm" OnClick="btnConfirmDelete_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hfDeleteId" runat="server" ClientIDMode="Static" />

    <div class="modal fade" id="addPlaceModal" tabindex="-1" aria-labelledby="addPlaceModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold text-dark" id="addPlaceModalLabel">Bookmark New Place</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold fs-8">Place Name</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control rounded-3" Placeholder="e.g. Hawa Mahal or Baga Beach"></asp:TextBox>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold fs-8">City / State</label>
                            <asp:TextBox ID="txtCity" runat="server" CssClass="form-control rounded-3" Placeholder="e.g. Jaipur, Rajasthan"></asp:TextBox>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold fs-8">Category</label>
                            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select rounded-3">
                                <asp:ListItem Value="Attraction">Attraction</asp:ListItem>
                                <asp:ListItem Value="Restaurant">Restaurant & Cafe</asp:ListItem>
                                <asp:ListItem Value="Hotel">Hotel & Stay</asp:ListItem>
                                <asp:ListItem Value="Beach">Beach & Nature</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold fs-8">Rating (1 to 5)</label>
                            <asp:TextBox ID="txtRating" runat="server" CssClass="form-control rounded-3" Placeholder="e.g. 4.8"></asp:TextBox>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold fs-8">Note / Vibe</label>
                            <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control rounded-3" Placeholder="e.g. Great sunset views"></asp:TextBox>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold fs-8">Image URL (Optional)</label>
                        <asp:TextBox ID="txtImageUrl" runat="server" CssClass="form-control rounded-3" Placeholder="Paste image web link or leave blank"></asp:TextBox>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-light rounded-3 fw-bold" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSavePlace" runat="server" Text="Save Place" CssClass="btn btn-primary rounded-3 fw-bold px-4" OnClick="btnSavePlace_Click" />
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function openDeleteModal(placeId) {
            document.getElementById('hfDeleteId').value = placeId;
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
            deleteModal.show();
        }

        function filterPlacesOnClient() {
            var input = document.getElementById('txtSearchDestination').value.toLowerCase().trim();
            var cards = document.querySelectorAll('.place-card');
            var visibleCount = 0;

            cards.forEach(function (card) {
                var title = (card.getAttribute('data-title') || '').toLowerCase();
                var city = (card.getAttribute('data-city') || '').toLowerCase();
                var category = (card.getAttribute('data-category') || '').toLowerCase();

                if (title.indexOf(input) > -1 || city.indexOf(input) > -1 || category.indexOf(input) > -1) {
                    card.style.display = 'flex';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            var emptyState = document.getElementById('pnlEmptyState');
            if (emptyState) {
                if (visibleCount === 0 && cards.length > 0) {
                    emptyState.style.display = 'block';
                } else {
                    emptyState.style.display = 'none';
                }
            }
        }
    </script>
</asp:Content>