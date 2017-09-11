<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GridView.aspx.cs" Inherits="CRUDUsingEF.Contacts" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>www.mitechdev.com</title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <style type="text/css">
        input{max-width:150px;}
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <h3 class="text-info">Grid view Using EF</h3>
        <asp:GridView ID="gridview" runat="server" AutoGenerateColumns="false"
            DataKeyNames="ContactID,CountryID,StateID" CellPadding="10" CellSpacing="0"
            ShowFooter="true"
            CssClass="table table-responsive table-striped" OnRowCommand="gridview_RowCommand" OnRowCancelingEdit="gridview_RowCancelingEdit" OnRowDeleting="gridview_RowDeleting" OnRowEditing="gridview_RowEditing" OnRowUpdating="gridview_RowUpdating">
            <Columns>
                <asp:TemplateField>
                    <HeaderTemplate>Contact Person</HeaderTemplate>
                    <ItemTemplate><%#Eval("ContactPerson") %></ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox cssClass="form-control" ID="txtContactPerson" runat="server" Text='<%#Bind("ContactPerson") %>' />
                        <asp:RequiredFieldValidator ID="rfCPEdit" runat="server" ForeColor="Red" ErrorMessage="*"
                             Display="Dynamic" ValidationGroup="edit" ControlToValidate="txtContactPerson">Required</asp:RequiredFieldValidator>
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox cssClass="form-control" ID="txtContactPerson" runat="server"></asp:TextBox><br />
                        <asp:RequiredFieldValidator ID="rfCP" runat="server" ErrorMessage="*"
                            ForeColor="Red" Display="Dynamic" ValidationGroup="Add" ControlToValidate="txtContactPerson">Required</asp:RequiredFieldValidator>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>Contact No</HeaderTemplate>
                    <ItemTemplate><%#Eval("ContactNo") %></ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox cssClass="form-control" ID="txtContactNo" runat="server" Text='<%#Bind("ContactNo") %>' />
                        <asp:RequiredFieldValidator ID="rfCNEdit" runat="server" ErrorMessage="*"
                            Display="Dynamic" ForeColor="Red" ValidationGroup="edit" ControlToValidate="txtContactNo">Required</asp:RequiredFieldValidator>
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox cssClass="form-control" ID="txtContactNo" runat="server"></asp:TextBox><br />
                        <asp:RequiredFieldValidator ID="rfCN" runat="server" ErrorMessage="*"
                            ForeColor="Red" Display="Dynamic" ValidationGroup="Add" ControlToValidate="txtContactNo">Required</asp:RequiredFieldValidator>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>Country</HeaderTemplate>
                    <ItemTemplate><%#Eval("CountryName") %></ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList cssClass="form-control" ID="ddCountry" runat="server" AutoPostBack="true" 
                             OnSelectedIndexChanged="ddCountry_SelectedIndexChanged">
                            <asp:ListItem Text="Select Country" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfCEdit" runat="server" ErrorMessage="*"
                            ForeColor="Red" Display="Dynamic" ValidationGroup="edit" ControlToValidate="ddCountry" InitialValue="0">
                            Required
                        </asp:RequiredFieldValidator>
                     </EditItemTemplate>
                    <FooterTemplate>
                        <asp:DropDownList cssClass="form-control" ID="ddCountry" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddCountry_SelectedIndexChanged">
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
                        <asp:DropDownList cssClass="form-control" ID="ddState" runat="server">
                            <asp:ListItem Text="Select State" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfSEdit" runat="server" ErrorMessage="*"
                            ForeColor="Red" Display="Dynamic" ValidationGroup="edit" ControlToValidate="ddState" InitialValue="0">
                            Required
                        </asp:RequiredFieldValidator>
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:DropDownList cssClass="form-control" ID="ddState" runat="server">
                            <asp:ListItem Text="Select State" Value="0"></asp:ListItem>
                        </asp:DropDownList><br />
                        <asp:RequiredFieldValidator ID="rfS" runat="server" ErrorMessage="*"
                            ForeColor="Red" Display="Dynamic" ValidationGroup="Add" ControlToValidate="ddState"
                            InitialValue="0">Required</asp:RequiredFieldValidator>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="lbEdit" cssClass="btn btn-success" runat="server" CommandName="Edit">Edit</asp:LinkButton>
                        &nbsp;|&nbsp;
                        <asp:LinkButton ID="lbDelete" cssClass="btn btn-danger" runat="server" CommandName="Delete" OnClientClick="return confirm('Are you confirm?')">Delete</asp:LinkButton>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:LinkButton ID="lbUpdate" cssClass="btn btn-success" runat="server" CommandName="Update" ValidationGroup="edit">Update</asp:LinkButton>
                        &nbsp;|&nbsp;
                        <asp:LinkButton ID="lbCancel" cssClass="btn btn-default" runat="server" CommandName="Cancel">Cancel</asp:LinkButton>
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:Button ID="btnInsert" cssClass="btn btn-success" runat="server" Text="Save" CommandName="Insert" ValidationGroup="Add" />
                    </FooterTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
    </form>
</body>
</html>
