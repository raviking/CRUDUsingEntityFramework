using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ASPCRUDPart1
{
    public partial class Contacts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateContacts();
            }
        }

        //Write function for Populate Contacts for show in Gridview
        private void PopulateContacts()
        {
            List<Contact> allContacts = null;
            using (MyDatabaseEntities dc = new MyDatabaseEntities())
            {
                var contacts = (from a in dc.Contacts
                                join b in dc.Countries on a.CountryID equals b.CountryID
                                join c in dc.States on a.StateID equals c.StateID
                                select new
                                {
                                    a,
                                    b.CountryName,
                                    c.StateName
                                });
                if (contacts != null)
                {
                    allContacts = new List<Contact>();
                    foreach (var i in contacts)
                    {
                        Contact c = i.a;
                        c.CountryName = i.CountryName;
                        c.StateName = i.StateName;
                        allContacts.Add(c);
                    }
                }

                if (allContacts == null || allContacts.Count == 0)
                {
                    //trick to show footer when there is no data in the gridview
                    allContacts.Add(new Contact());
                    myGridview.DataSource = allContacts;
                    myGridview.DataBind();
                    myGridview.Rows[0].Visible = false;
                }
                else
                {
                    myGridview.DataSource = allContacts;
                    myGridview.DataBind();
                }

                //Populate & bind country
                if (myGridview.Rows.Count > 0)
                {
                    DropDownList dd = (DropDownList)myGridview.FooterRow.FindControl("ddCountry");
                    BindCountry(dd, PopulateCountry());
                }

            }
        }

        //Function for fetch country from database
        private List<Country> PopulateCountry()
        {
            using (MyDatabaseEntities dc = new MyDatabaseEntities())
            {
                return dc.Countries.OrderBy(a => a.CountryName).ToList();
            }
        }
        //function for fetch state from database
        private List<State> PopulateState(int countryID)
        {
            using (MyDatabaseEntities dc = new MyDatabaseEntities())
            {
                return dc.States.Where(a => a.CountryID.Equals(countryID)).OrderBy(a => a.StateName).ToList();
            }
        }
        //function for bind country to dropdown
        private void BindCountry(DropDownList ddCountry, List<Country> country)
        {
            ddCountry.Items.Clear();
            ddCountry.Items.Add(new ListItem { Text = "Select Country", Value = "0" });
            ddCountry.AppendDataBoundItems = true;

            ddCountry.DataTextField = "CountryName";
            ddCountry.DataValueField = "CountryID";
            ddCountry.DataSource = country;
            ddCountry.DataBind();
        }
        //function for bind state to dropdown 
        private void BindState(DropDownList ddState, int countryID)
        {
            ddState.Items.Clear();
            ddState.Items.Add(new ListItem { Text = "Select State", Value = "0" });
            ddState.AppendDataBoundItems = true;

            ddState.DataTextField = "StateName";
            ddState.DataValueField = "StateID";
            ddState.DataSource = countryID > 0 ? PopulateState(countryID) : null;
            ddState.DataBind();
        }

        protected void ddCountry_SelectedIndexChanged(object sender, EventArgs e)
        {
            //write code for cascade dropdown
            string countryID = ((DropDownList)sender).SelectedValue;
            var dd = (DropDownList)((System.Web.UI.WebControls.ListControl)(sender)).Parent.Parent.FindControl("ddState");
            BindState(dd, Convert.ToInt32(countryID));
        }

        protected void myGridview_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            //Insert new contact
            if (e.CommandName == "Insert")
            {
                Page.Validate("Add");
                if (Page.IsValid)
                {
                    var fRow = myGridview.FooterRow;
                    TextBox txtContactPerson = (TextBox)fRow.FindControl("txtContactPerson");
                    TextBox txtContactNo = (TextBox)fRow.FindControl("txtContactNo");
                    DropDownList ddCountry = (DropDownList)fRow.FindControl("ddCountry");
                    DropDownList ddState = (DropDownList)fRow.FindControl("ddState");
                    using (MyDatabaseEntities dc = new MyDatabaseEntities())
                    {

                        //Here in this example we have done a little mistake // class name and page name is Same (contact) 
                        // We will remove contact page , as its not in use

                        dc.Contacts.Add(new Contact
                        {
                            ContactPerson = txtContactPerson.Text.Trim(),
                            ContactNo = txtContactNo.Text.Trim(),
                            CountryID = Convert.ToInt32(ddCountry.SelectedValue),
                            StateID = Convert.ToInt32(ddState.SelectedValue)
                        });
                        dc.SaveChanges();
                        PopulateContacts();
                    }
                }
            }
        }

        protected void myGridview_RowEditing(object sender, GridViewEditEventArgs e)
        {
            //Get Country ID and State ID of editable row
            string countryID = myGridview.DataKeys[e.NewEditIndex]["CountryID"].ToString();
            string stateID = myGridview.DataKeys[e.NewEditIndex]["StateID"].ToString();
            //Open Edit Mode
            myGridview.EditIndex = e.NewEditIndex;
            PopulateContacts();
            //Populate Country And State and Bind
            DropDownList ddCountry = (DropDownList)myGridview.Rows[e.NewEditIndex].FindControl("ddCountry");
            DropDownList ddState = (DropDownList)myGridview.Rows[e.NewEditIndex].FindControl("ddState");
            if (ddCountry != null && ddState != null)
            {
                BindCountry(ddCountry, PopulateCountry());
                ddCountry.SelectedValue = countryID;
                BindState(ddState, Convert.ToInt32(countryID));
                ddState.SelectedValue = stateID;
            }
        }

        protected void myGridview_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            //Cancel Edit Mode 
            myGridview.EditIndex = -1;
            PopulateContacts();
        }

        protected void myGridview_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            //Validate Page
            Page.Validate("edit");
            if (!Page.IsValid)
            {
                return;
            }

            //Get Contact ID
            int contactID = (int)myGridview.DataKeys[e.RowIndex]["ContactID"];

            //Find Controls 
            TextBox txtContactPerson = (TextBox)myGridview.Rows[e.RowIndex].FindControl("txtContactPerson");
            TextBox txtContactNo = (TextBox)myGridview.Rows[e.RowIndex].FindControl("txtContactNo");
            DropDownList ddCountry = (DropDownList)myGridview.Rows[e.RowIndex].FindControl("ddCountry");
            DropDownList ddState = (DropDownList)myGridview.Rows[e.RowIndex].FindControl("ddState");
            //Get Values (updated) and Save to database
            using (MyDatabaseEntities dc = new MyDatabaseEntities())
            {
                var v = dc.Contacts.Where(a => a.ContactID.Equals(contactID)).FirstOrDefault();
                if (v != null)
                {
                    v.ContactPerson = txtContactPerson.Text.Trim();
                    v.ContactNo = txtContactNo.Text.Trim();
                    v.CountryID = Convert.ToInt32(ddCountry.SelectedValue);
                    v.StateID = Convert.ToInt32(ddState.SelectedValue);
                }
                dc.SaveChanges();
                myGridview.EditIndex = -1;
                PopulateContacts();
            }
        }

        protected void myGridview_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int contactID = (int)myGridview.DataKeys[e.RowIndex]["ContactID"];
            using (MyDatabaseEntities dc = new MyDatabaseEntities())
            {
                var v = dc.Contacts.Where(a => a.ContactID.Equals(contactID)).FirstOrDefault();
                if (v != null)
                {
                    dc.Contacts.Remove(v);
                    dc.SaveChanges();
                    PopulateContacts();
                }
            }
        }

    }
}