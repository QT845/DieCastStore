<%-- 
    Document   : orderdetail
    Created on : Jul 9, 2025, 3:56:46 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Order" %>
<%@ page import="model.OrderDetail" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order Details Page</title>
    </head>
    <body>
        <%
            Order order = (Order) request.getAttribute("order");
            List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("details");
        %>
        <h2>Order Details - <%= order.getOrderId() %></h2>
        <p>Status: <%= order.getStatus() %></p>
        <p>Date: <%= order.getOrderDate() %></p>
        <p>Total: <%= String.format("%.2f", order.getTotalAmount()) %></p>
        <table border="1">
            <tr>
                <th>Item Type</th>
                <th>Item ID</th>
                <th>Quantity</th>
                <th>Price</th>
            </tr>
            <%
                if (details != null && !details.isEmpty()) {
                    for (OrderDetail d : details) {
            %>
            <tr>
                <td><%= d.getItemType() %></td>
                <td><%= d.getItemId() %></td>
                <td><%= d.getUnitQuantity() %></td>
                <td><%= d.getUnitPrice() %></td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr><td colspan="4">No items found in this order.</td></tr>
            <%
                }
            %>
        </table>

        <br>
        <a href="order?action=list">Back to My Orders</a>
        <%
            String status = order.getStatus();
            if (!"CANCELLED".equalsIgnoreCase(status) && !"SHIPPED".equalsIgnoreCase(status)) {
        %>
        | <a href="order?action=cancel&orderId=<%= order.getOrderId() %>"
             onclick="return confirm('Cancel this order?')">Cancel this order</a>
        <%
            }
        %>
    </body>
</html>
