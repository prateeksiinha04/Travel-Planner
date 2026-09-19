<%@ Page Title="Expenses & Budget" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Budget.aspx.cs" Inherits="AI_Travel_Planner.Budget" %>

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

        /* Budget Config Card */
        .budget-config-card {
            background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
            border: 1px solid #bfdbfe;
            border-radius: 20px;
            padding: 20px 24px;
            margin-bottom: 24px;
        }

        /* Metric Cards Grid */
        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }

        .metric-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 20px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 2px 6px rgba(0,0,0,0.02);
        }

        .metric-card .label {
            font-size: 0.8rem;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
            display: block;
        }

        .metric-card .value {
            font-size: 1.6rem;
            font-weight: 800;
            color: #0f172a;
            margin: 0;
        }

        /* Budget Progress Card */
        .progress-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 20px;
            border: 1px solid #e2e8f0;
            margin-bottom: 24px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.02);
        }

        .progress-bar-container {
            height: 12px;
            background: #f1f5f9;
            border-radius: 20px;
            overflow: hidden;
            margin-top: 10px;
        }

        .progress-bar-fill {
            height: 100%;
            border-radius: 20px;
            transition: width 0.4s ease;
        }

        /* Deals Grid */
        .deals-card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 16px;
            margin-bottom: 28px;
        }

        .deal-item-card {
            background: #ffffff;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
            transition: transform 0.2s ease;
        }

        .deal-item-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 18px rgba(0,0,0,0.08);
        }

        .deal-img-wrapper {
            position: relative;
            height: 140px;
            width: 100%;
        }

        .deal-img-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .deal-tag {
            position: absolute;
            top: 10px;
            left: 10px;
            background: #10b981;
            color: #ffffff;
            font-size: 0.72rem;
            font-weight: 800;
            padding: 3px 10px;
            border-radius: 12px;
            text-transform: uppercase;
        }

        .deal-body {
            padding: 14px;
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

        /* Expense Card */
        .expense-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 16px 20px;
            border: 1px solid #e2e8f0;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 4px rgba(0,0,0,0.01);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .expense-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 14px rgba(0,0,0,0.04);
        }

        .expense-icon-wrapper {
            width: 42px;
            height: 42px;
            min-width: 42px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
        }

        .delete-btn {
            color: #94a3b8;
            background: transparent;
            border: none;
            padding: 6px;
            border-radius: 8px;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .delete-btn:hover {
            color: #ef4444;
            background-color: #fef2f2;
        }

        .add-expense-btn {
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

        .add-expense-btn:hover {
            background: #1d4ed8;
            color: #ffffff;
        }

        /* Empty State */
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

    <!-- Page Header -->
    <div class="page-header">
        <div>
            <h1 class="page-title">Expenses & Budget 💰</h1>
            <p class="page-subtitle">Set your total trip budget, discover matching deals, and manage spending.</p>
        </div>
        <button type="button" class="add-expense-btn" data-bs-toggle="modal" data-bs-target="#addExpenseModal">
            <i class="fa-solid fa-plus"></i> Add Expense
        </button>
    </div>

    <!-- ASK BUDGET FROM USER INPUT CARD -->
    <div class="budget-config-card">
        <div class="row align-items-center g-3">
            <div class="col-md-7">
                <h5 class="fw-bold text-dark m-0 mb-1">🎯 What is your Total Trip Budget?</h5>
                <p class="text-muted fs-8 m-0">Set your maximum limit to dynamically unlock matching hotel & transport deals.</p>
            </div>
            <div class="col-md-5">
                <div class="input-group">
                    <span class="input-group-text bg-white fw-bold border-end-0 rounded-start-3">₹</span>
                    <asp:TextBox ID="txtCustomBudget" runat="server" CssClass="form-control fw-bold fs-6 border-start-0" Text="50000" TextMode="Number"></asp:TextBox>
                    <asp:Button ID="btnUpdateBudget" runat="server" Text="Set & Find Deals ➔" CssClass="btn btn-primary rounded-end-3 fw-bold px-3" OnClick="btnUpdateBudget_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- Summary Metrics -->
    <div class="metrics-grid">
        <div class="metric-card">
            <span class="label">Total Budget</span>
            <h3 class="value"><asp:Label ID="lblTotalBudget" runat="server" Text="₹50,000"></asp:Label></h3>
        </div>
        <div class="metric-card">
            <span class="label">Total Spent</span>
            <h3 class="value text-primary"><asp:Label ID="lblTotalSpent" runat="server" Text="₹0"></asp:Label></h3>
        </div>
        <div class="metric-card">
            <span class="label">Remaining</span>
            <h3 class="value text-success"><asp:Label ID="lblRemaining" runat="server" Text="₹50,000"></asp:Label></h3>
        </div>
        <div class="metric-card">
            <span class="label">Daily Average</span>
            <h3 class="value text-secondary"><asp:Label ID="lblDailyAvg" runat="server" Text="₹0"></asp:Label></h3>
        </div>
    </div>

    <!-- Budget Utilization Progress Bar -->
    <div class="progress-card">
        <div class="d-flex justify-content-between align-items-center mb-1">
            <span class="fw-bold fs-8 text-dark">Budget Utilization</span>
            <span class="fw-bold fs-8 text-muted"><asp:Label ID="lblProgressPercent" runat="server" Text="0%"></asp:Label></span>
        </div>
        <div class="progress-bar-container">
            <asp:Panel ID="pnlProgressBarFill" runat="server" CssClass="progress-bar-fill" style="width: 0%; background-color: #22c55e;"></asp:Panel>
        </div>
    </div>

    <!-- MATCHING BUDGET DEALS SECTION -->
    <div class="mb-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="fw-bold text-dark m-0">🏷️ Deals Matching Your Budget (<asp:Label ID="lblDealCategory" runat="server" Text="Under ₹50,000"></asp:Label>)</h5>
            <span class="badge bg-success-subtle text-success fw-bold px-3 py-2 rounded-pill fs-8">Verified AI Deals</span>
        </div>

        <div class="deals-card-grid">
            <asp:Repeater ID="rptDeals" runat="server">
                <ItemTemplate>
                    <div class="deal-item-card">
                        <div class="deal-img-wrapper">
                            <img src='<%# Eval("ImageUrl") %>' alt="Deal Image" />
                            <span class="deal-tag"><%# Eval("DiscountTag") %></span>
                        </div>
                        <div class="deal-body">
                            <h6 class="fw-bold text-dark fs-8 mb-1"><%# Eval("Title") %></h6>
                            <span class="text-muted fs-9 d-block mb-2"><i class="fa-solid fa-location-dot me-1 text-danger"></i><%# Eval("Location") %></span>
                            <div class="d-flex justify-content-between align-items-center mt-2">
                                <span class="fw-extrabold text-primary fs-7"><%# Eval("Price") %></span>
                                
                                <!-- TRIGGER MODAL WITH DEAL DATA -->
                                <button type="button" class="btn btn-sm btn-primary rounded-3 fs-9 fw-bold px-3"
                                    onclick="openDealModal('<%# Eval("Title") %>', '<%# Eval("Location") %>', '<%# Eval("Price") %>', '<%# Eval("ImageUrl") %>', '<%# Eval("DiscountTag") %>', '<%# Eval("Inclusions") %>', '<%# Eval("DestinationQuery") %>')">
                                    Book Deal ➔
                                </button>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <!-- Category Filter Tabs -->
    <div class="filter-tabs">
        <asp:LinkButton ID="btnFilterAll" runat="server" CssClass="tab-btn active" OnClick="Filter_Click" CommandArgument="All">All Expenses</asp:LinkButton>
        <asp:LinkButton ID="btnFilterFlight" runat="server" CssClass="tab-btn" OnClick="Filter_Click" CommandArgument="Flight">✈️ Flights</asp:LinkButton>
        <asp:LinkButton ID="btnFilterStay" runat="server" CssClass="tab-btn" OnClick="Filter_Click" CommandArgument="Stay">🏨 Stays</asp:LinkButton>
        <asp:LinkButton ID="btnFilterFood" runat="server" CssClass="tab-btn" OnClick="Filter_Click" CommandArgument="Food">🍔 Food & Dining</asp:LinkButton>
        <asp:LinkButton ID="btnFilterActivities" runat="server" CssClass="tab-btn" OnClick="Filter_Click" CommandArgument="Activity">🎟️ Activities</asp:LinkButton>
        <asp:LinkButton ID="btnFilterShopping" runat="server" CssClass="tab-btn" OnClick="Filter_Click" CommandArgument="Shopping">🛍️ Shopping</asp:LinkButton>
        <asp:LinkButton ID="btnFilterTransit" runat="server" CssClass="tab-btn" OnClick="Filter_Click" CommandArgument="Transit">🚕 Transit</asp:LinkButton>
    </div>

    <!-- Expense Repeater -->
    <asp:Repeater ID="rptExpenses" runat="server" OnItemCommand="rptExpenses_ItemCommand">
        <ItemTemplate>
            <div class="expense-card">
                <div class="d-flex align-items-center gap-3">
                    <div class="expense-icon-wrapper" style='<%# Eval("IconStyle") %>'>
                        <i class='<%# Eval("IconClass") %>'></i>
                    </div>
                    <div>
                        <h6 class="fw-bold mb-0 fs-6 text-dark"><%# Eval("Title") %></h6>
                        <span class="text-muted fs-8"><%# Eval("Category") %> • <%# Eval("ExpenseDate") %></span>
                    </div>
                </div>
                <div class="d-flex align-items-center gap-4">
                    <div class="text-end">
                        <span class="fw-bold fs-6 text-dark d-block"><%# Eval("FormattedAmount") %></span>
                        <span class="text-muted fs-8"><%# Eval("PaymentMethod") %></span>
                    </div>
                    <!-- Delete LinkButton -->
                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteExpense" CommandArgument='<%# Eval("Id") %>' CssClass="delete-btn" ToolTip="Delete Expense" OnClientClick="return confirm('Are you sure you want to delete this expense?');">
                        <i class="fa-regular fa-trash-can"></i>
                    </asp:LinkButton>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>

    <!-- Empty State Panel -->
    <asp:Panel ID="pnlEmptyState" runat="server" Visible="false" CssClass="empty-state">
        <i class="fa-solid fa-receipt"></i>
        <h5 class="fw-bold text-dark mb-1">No expenses recorded</h5>
        <p class="text-muted fs-8 mb-0">No entries match the selected filter category.</p>
    </asp:Panel>

    <!-- POPUP MODAL FOR BOOK DEAL DETAILS -->
    <div class="modal fade" id="dealModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header border-bottom-0 pb-0">
                    <h5 class="modal-title fw-bold text-dark">
                        <i class="fa-solid fa-tag text-success me-2"></i>Exclusive Deal Voucher
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-5">
                            <div class="position-relative rounded-3 overflow-hidden shadow-sm h-100">
                                <img id="modalDealImage" src="" alt="Deal Image" class="w-100 h-100" style="object-fit: cover; min-height: 200px;" />
                                <span id="modalDealTag" class="deal-tag" style="top: 12px; left: 12px;">SPECIAL DEAL</span>
                            </div>
                        </div>
                        <div class="col-md-7 d-flex flex-column justify-content-between">
                            <div>
                                <h4 class="fw-bold text-dark mb-1" id="modalDealTitle">Deal Title</h4>
                                <p class="text-muted fs-8 mb-3"><i class="fa-solid fa-location-dot text-danger me-1"></i><span id="modalDealLocation">Location</span></p>

                                <div class="bg-light p-3 rounded-3 border mb-3">
                                    <h6 class="fw-bold fs-8 text-primary mb-2">🎁 Deal Inclusions & Highlights:</h6>
                                    <p class="fs-8 text-muted mb-0" id="modalDealInclusions">Buffet Breakfast, Free Airport Transfer, WiFi, Local Sightseeing Voucher.</p>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                                <div>
                                    <span class="text-muted fs-9 d-block">Special Offer Price</span>
                                    <h3 class="fw-bold text-success m-0" id="modalDealPrice">₹0</h3>
                                </div>
                                <a id="btnModalPlannerLink" href="#" class="btn btn-success rounded-3 fw-bold px-4">
                                    Proceed & Customize Itinerary ➔
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Expense Modal -->
    <div class="modal fade" id="addExpenseModal" tabindex="-1" aria-labelledby="addExpenseModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold text-dark" id="addExpenseModalLabel">Add New Expense</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold fs-8">Description / Title</label>
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control rounded-3" Placeholder="e.g. Dinner at Le Cafe or Metro Pass"></asp:TextBox>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold fs-8">Category</label>
                            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select rounded-3">
                                <asp:ListItem Value="Food">Food & Dining</asp:ListItem>
                                <asp:ListItem Value="Stay">Hotel / Stay</asp:ListItem>
                                <asp:ListItem Value="Flight">Flight / Transport</asp:ListItem>
                                <asp:ListItem Value="Activity">Activity & Tour</asp:ListItem>
                                <asp:ListItem Value="Shopping">Shopping</asp:ListItem>
                                <asp:ListItem Value="Transit">Taxi / Transit</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold fs-8">Amount (₹)</label>
                            <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control rounded-3" Placeholder="e.g. 1250"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold fs-8">Date</label>
                            <asp:TextBox ID="txtDate" runat="server" TextMode="Date" CssClass="form-control rounded-3"></asp:TextBox>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold fs-8">Payment Method</label>
                            <asp:DropDownList ID="ddlPaymentMethod" runat="server" CssClass="form-select rounded-3">
                                <asp:ListItem Value="Card">Credit/Debit Card</asp:ListItem>
                                <asp:ListItem Value="Cash">Cash</asp:ListItem>
                                <asp:ListItem Value="UPI">UPI / Digital Wallet</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-light rounded-3 fw-bold" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSaveExpense" runat="server" Text="Save Expense" CssClass="btn btn-primary rounded-3 fw-bold px-4" OnClick="btnSaveExpense_Click" />
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function openDealModal(title, location, price, imageUrl, tag, inclusions, query) {
            document.getElementById('modalDealTitle').innerText = title;
            document.getElementById('modalDealLocation').innerText = location;
            document.getElementById('modalDealPrice').innerText = price;
            document.getElementById('modalDealImage').src = imageUrl;
            document.getElementById('modalDealTag').innerText = tag;
            document.getElementById('modalDealInclusions').innerText = inclusions;
            document.getElementById('btnModalPlannerLink').href = 'TripPlanner.aspx?dest=' + encodeURIComponent(query);

            var myModal = new bootstrap.Modal(document.getElementById('dealModal'));
            myModal.show();
        }
    </script>
</asp:Content>