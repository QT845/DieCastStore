<%-- 
    Document   : checkout
    Created on : Jun 20, 2025, 12:39:32 PM
    Author     : Admin
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Cart" %>
<%@ page import="model.CartItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    Cart cart = (Cart) request.getAttribute("cart");
    String error = (String) request.getAttribute("error");
    
    // Kiểm tra cart ngay từ đầu
    if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Cart is empty - DieCastStore</title>
    </head>
    <body>
        <h2>Notification</h2>
        <p>Cart is empty. <a href="cart?action=view">Back to cart</a></p>
    </body>
</html>
<%
    } else {
        List<CartItem> items = cart.getItems();
        DecimalFormat df = new DecimalFormat("#,##0.00");
        double totalAmount = cart.getTotalAmount();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Pay - DieCastStore</title>
    </head>
    <body>
        <h2>Payment information</h2>

        <% if (error != null && !error.isEmpty()) { %>
        <div>
            <b style="color:red;"><%= error %></b>
        </div>
        <br>
        <% } %>

        <form action="checkout?action=process" method="post" onsubmit="return validateForm()">
            <table>
                <tr>
                    <td><label for="customerName">Full name *</label></td>
                    <td><input type="text" id="customerName" name="customerName" size="30" required></td>
                </tr>
                <tr>
                    <td><label for="phone">Phone number *</label></td>
                    <td><input type="tel" id="phone" name="phone" size="30" 
                               pattern="[0-9]{10,11}" 
                               title="Phone number must be 10-11 digits" required></td>
                </tr>
                <tr>
                    <td valign="top"><label for="address">Address *</label></td>
                    <td><textarea id="address" name="address" rows="3" cols="30" required></textarea></td>
                </tr>
            </table>

            <h3>My order</h3>
            <table border="1" cellpadding="8" cellspacing="0">
                <tr bgcolor="#f2f2f2">
                    <th>Product</th>
                    <th>Quantity</th>
                    <th>Unit price</th>
                    <th>Total amount</th>
                </tr>
                <% for (CartItem item : items) { %>
                <tr>
                    <td><%= item.getItemName() %></td>
                    <td align="center"><%= item.getQuantity() %></td>
                    <td align="right"><%= df.format(item.getUnitPrice()) %> $</td>
                    <td align="right"><%= df.format(item.getUnitPrice() * item.getQuantity()) %> $</td>
                </tr>
                <% } %>
                <tr bgcolor="#f9f9f9">
                    <td colspan="3" align="right"><b>Total:</b></td>
                    <td align="right"><b><%= df.format(totalAmount) %> $</b></td>
                </tr>
            </table>

            <br>
            <input type="submit" value="Order Confirmation">
            <input type="button" value="Back to cart" onclick="location.href = 'cart?action=view'">
        </form>

        <script>
            function validateForm() {
                var name = document.getElementById("customerName").value.trim();
                var phone = document.getElementById("phone").value.trim();
                var address = document.getElementById("address").value.trim();

                if (name === "" || phone === "" || address === "") {
                    alert("Vui lòng điền đầy đủ thông tin!");
                    return false;
                }

                var phonePattern = /^[0-9]{10,11}$/;
                if (!phonePattern.test(phone)) {
                    alert("Invalid phone number! Please enter 10-11 digits.");
                    return false;
                }

                return confirm("Are you sure you want to place an order with the total amount " +
                        "<%= df.format(totalAmount) %> $?");
            }
        </script>
    </body>
</html>
<% } %>