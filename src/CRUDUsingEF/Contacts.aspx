<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Contacts.aspx.cs" Inherits="ASPCRUDPart1.Contacts" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        /*Here I will add some css for looks good*/
        .myGrid {
            border: 1px solid #ddd;
            margin: 15px;
            -webkit-border-radius: 3px 3px 0 0;
            -moz-border-radius: 3px 3px 0 0;
            border-radius: 3px 3px 0 0;
        }
        .myGrid td {
            vertical-align:top;
        }
        .header {
            overflow: hidden;
            position: relative;
            border-bottom: 1px solid #ddd;
            height: 30px;
        }

            .header th {
                color: #222;
                font-weight: normal;
                line-height: 40px;
                text-align: left;
                /* text-shadow: 0 1px #FFFFFF; */
                white-space: nowrap;
                border-right: 1px solid #ddd;
                border-bottom: 2px solid #ddd;
                padding: 0px 15px 0px 15px;
                -webkit-border-radius: 1px;
                -moz-border-radius: 1px;
            }

        .trow1 {
            background: #f9f9f9;
        }

        .trow2 {
            background: #fff;
        }

            .trow1 td, .trow2 td {
                color: #555;
                line-height: 18px;
                padding: 9px 5px;
                text-align: left;
                border-right: 1px solid #ddd;
                border-bottom: 1px solid #ddd;
                text-align: left;
                
            }

        input[type='text'],select {
            border: 1px solid #b8b8b8;
            border-radius: 3px;
            color: #999999;
            float: left;
            height: 22px;
            padding: 0 5px;
            position: relative;
            width: 185px;            
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:GridView ID="myGridview" runat="server" AutoGenerateColumns="false"
            DataKeyNames="ContactID,CountryID,StateID" CellPadding="10" CellSpacing="0"
            ShowFooter="true"
            CssClass="myGrid"  HeaderStyle-CssClass="header" RowStyle-CssClass="trow1" 
            AlternatingRowStyle-CssClass="trow2" OnRowCommand="myGridview_RowCommand" OnRowCancelingEdit="myGridview_RowCancelingEdit" OnRowDeleting="myGridview_RowDeleting" OnRowEditing="myGridview_RowEditing" OnRowUpdating="myGridview_RowUpdating">

            <Columns>
                <asp:TemplateField>
                    <HeaderTemplate>Contact Person</HeaderTemplate>
                    <ItemTemplate><%#Eval("ContactPerson") %></ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtContactPerson" runat="server" Text='<%#Bind("ContactPerson") %>' />
                        <asp:RequiredFieldValidator ID="rfCPEdit" runat="server" ForeColor="Red" ErrorMessage="*"
                             Display="Dynamic" ValidationGroup="edit" ControlToValidate="txtContactPerson">Required</asp:RequiredFieldValidator>
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="txtContactPerson" runat="server"></asp:TextBox><br />
                        <asp:RequiredFieldValidator ID="rfCP" runat="server" ErrorMessage="*"
                            ForeColor="Red" Display="Dynamic" ValidationGroup="Add" ControlToValidate="txtContactPerson">Required</asp:RequiredFieldValidator>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>Contact No</HeaderTemplate>
                    <ItemTemplate><%#Eval("ContactNo") %></ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtContactNo" runat="server" Text='<%#Bind("ContactNo") %>' />
                        <asp:RequiredFieldValidator ID="rfCNEdit" runat="server" ErrorMessage="*"
                            Display="Dynamic" ForeColor="Red" ValidationGroup="edit" ControlToValidate="txtContactNo">Required</asp:RequiredFieldValidator>
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="txtContactNo" runat="server"></asp:TextBox><br />
                        <asp:RequiredFieldValidator ID="rfCN" runat="server" ErrorMessage="*"
                            ForeColor="Red" Display="Dynamic" ValidationGroup="Add" ControlToValidate="txtContactNo">Required</asp:RequiredFieldValidator>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>Country</HeaderTemplate>
                    <ItemTemplate><%#Eval("CountryName") %></ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddCountry" runat="server" AutoPostBack="true" 
                             OnSelectedIndexChanged="ddCountry_SelectedIndexChanged">
                            <asp:ListItem Text="Select Country" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfCEdit" runat="server" ErrorMessage="*"
                            ForeColor="Red" Display="Dynamic" ValidationGroup="edit" ControlToValidate="ddCountry" InitialValue="0">
                            Required
                        </asp:RequiredFieldValidator>
                     </EditItemTemplate>
                    <FooterTemplate>
                        <asp:DropDownList ID="ddCountry" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddCountry_SelectedIndexChanged">
                            <asp:ListItem Text="Select Country" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                        <br />
                        <asp:RequiredFieldValidator ID="rfC" runat="server" ErrorMessage="*"
                            ForeColor="Red" Display="Dynamic" ValidationGroup="Add" ControlToValidate="ddCountry" InitialValue="0">Required</asp:RequiredFieldValidator>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>State</HeaderTemplate>
                    <ItemTemplate><%#Eval("StateName") %></ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddState" runat="server">
                            <asp:ListItem Text="Select State" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfSEdit" runat="server" ErrorMessage="*"
                            ForeColor="Red" Display="Dynamic" ValidationGroup="edit" ControlToValidate="ddState" InitialValue="0">
                            Required
                        </asp:RequiredFieldValidator>
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:DropDownList ID="ddState" runat="server">
                            <asp:ListItem Text="Select State" Value="0"></asp:ListItem>
                        </asp:DropDownList><br />
                        <asp:RequiredFieldValidator ID="rfS" runat="server" ErrorMessage="*"
                            ForeColor="Red" Display="Dynamic" ValidationGroup="Add" ControlToValidate="ddState"
                            InitialValue="0">Required</asp:RequiredFieldValidator>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="lbEdit" runat="server" CommandName="Edit">Edit</asp:LinkButton>
                        &nbsp;|&nbsp;
                        <asp:LinkButton ID="lbDelete" runat="server" CommandName="Delete" OnClientClick="return confirm('Are you confirm?')">Delete</asp:LinkButton>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:LinkButton ID="lbUpdate" runat="server" CommandName="Update" ValidationGroup="edit">Update</asp:LinkButton>
                        &nbsp;|&nbsp;
                        <asp:LinkButton ID="lbCancel" runat="server" CommandName="Cancel">Cancel</asp:LinkButton>
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:Button ID="btnInsert" runat="server" Text="Save" CommandName="Insert" ValidationGroup="Add" />
                    </FooterTemplate>
                </asp:TemplateField>
            </Columns>

        </asp:GridView>
    </div>
    </form>
</body>
</html>
