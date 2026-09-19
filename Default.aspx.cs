using System;
using System.Web.UI;

namespace AI_Travel_Planner
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect root traffic to the dashboard page
            Response.Redirect("~/Dashboard.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}