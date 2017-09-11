using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using CRUDUsingEF.Models;
using CRUDUsingEF;
using System.Web.UI.WebControls;

namespace CRUDUsingEF
{
    public partial class Contacts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadContacts();
            }
        }
        private void LoadContacts()
        {
            List<Contact> allContacts = null;
            using (MydatabaseEntities dc = new MydatabaseEntities())
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
                    allContacts.Add(new Contact());
                    gridview.DataSource = allContacts;
                    gridview.DataBind();
                    gridview.Rows[0].Visible = false;
                }
                else
                {
                    gridview.DataSource = allContacts;
                    gridview.DataBind();
                }

                if (gridview.Rows.Count > 0)
                {
                    DropDownList dd = (DropDownList)gridview.FooterRow.FindControl("ddCountry");
                    BindCountry(dd, PopulateCountry());
                }

            }
        }
        private List<Country> PopulateCountry()
        {
            using (MydatabaseEntities dc = new MydatabaseEntities())
            {
                return dc.Countries.OrderBy(a => a.CountryName).ToList();
            }
        }
        private List<State> PopulateState(int countryID)
        {
            using (MydatabaseEntities dc = new MydatabaseEntities())
            {
                return dc.States.Where(a => a.CountryID.Equals(countryID)).OrderBy(a => a.StateName).ToList();
            }
        }
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
        protected void gridview_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Insert")
            {
                Page.Validate("Add");
                if (Page.IsValid)
                {
                    var fRow = gridview.FooterRow;
                    TextBox txtContactPerson = (TextBox)fRow.FindControl("txtContactPerson");
                    TextBox txtContactNo = (TextBox)fRow.FindControl("txtContactNo");
                    DropDownList ddCountry = (DropDownList)fRow.FindControl("ddCountry");
                    DropDownList ddState = (DropDownList)fRow.FindControl("ddState");
                    using (MydatabaseEntities dc = new MydatabaseEntities())
                    {
                        dc.Contacts.Add(new Contact
                        {
                            ContactPerson = txtContactPerson.Text.Trim(),
                            ContactNo = txtContactNo.Text.Trim(),
                            CountryID = Convert.ToInt32(ddCountry.SelectedValue),
                            StateID = Convert.ToInt32(ddState.SelectedValue)
                        });
                        dc.SaveChanges();
                        LoadContacts();
                    }
                }
            }
        }
        protected void gridview_RowEditing(object sender, GridViewEditEventArgs e)
        {
            string countryID = gridview.DataKeys[e.NewEditIndex]["CountryID"].ToString();
            string stateID = gridview.DataKeys[e.NewEditIndex]["StateID"].ToString();
            gridview.EditIndex = e.NewEditIndex;
            LoadContacts();
            DropDownList ddCountry = (DropDownList)gridview.Rows[e.NewEditIndex].FindControl("ddCountry");
            DropDownList ddState = (DropDownList)gridview.Rows[e.NewEditIndex].FindControl("ddState");
            if (ddCountry != null && ddState != null)
            {
                BindCountry(ddCountry, PopulateCountry());
                ddCountry.SelectedValue = countryID;
                BindState(ddState, Convert.ToInt32(countryID));
                ddState.SelectedValue = stateID;
            }
        }
        protected void gridview_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            //Cancel Edit Mode 
            gridview.EditIndex = -1;
            LoadContacts();
        }
        protected void gridview_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            Page.Validate("edit");
            if (!Page.IsValid)
            {
                return;
            }
            int contactID = (int)gridview.DataKeys[e.RowIndex]["ContactID"];
            TextBox txtContactPerson = (TextBox)gridview.Rows[e.RowIndex].FindControl("txtContactPerson");
            TextBox txtContactNo = (TextBox)gridview.Rows[e.RowIndex].FindControl("txtContactNo");
            DropDownList ddCountry = (DropDownList)gridview.Rows[e.RowIndex].FindControl("ddCountry");
            DropDownList ddState = (DropDownList)gridview.Rows[e.RowIndex].FindControl("ddState");
            using (MydatabaseEntities dc = new MydatabaseEntities())
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
                gridview.EditIndex = -1;
                LoadContacts();
            }
        }
        protected void gridview_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int contactID = (int)gridview.DataKeys[e.RowIndex]["ContactID"];
            using (MydatabaseEntities dc = new MydatabaseEntities())
            {
                var v = dc.Contacts.Where(a => a.ContactID.Equals(contactID)).FirstOrDefault();
                if (v != null)
                {
                    dc.Contacts.Remove(v);
                    dc.SaveChanges();
                    LoadContacts();
                }
            }
        }
    }
}