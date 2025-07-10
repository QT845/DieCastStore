<%-- 
    Document   : orderlist
    Created on : Jul 9, 2025, 3:54:38 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Order" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Order Page</title>
    </head>
    <body>
        <%
            List<Order> orders = (List<Order>) request.getAttribute("orders");
        %>
        <h2>My Orders</h2>

        <table border="1">
            <tr>
                <th>Order ID</th>
                <th>Date</th>
                <th>Status</th>
                <th>Total</th>
                <th>Action</th>
            </tr>
            <%
                if (orders != null && !orders.isEmpty()) {
                    for (Order o : orders) {
            %>
            <tr>
                <td><%= o.getOrderId() %></td>
                <td><%= o.getOrderDate() %></td>
                <td><%= o.getStatus() %></td>
                <td><%= String.format("%.2f", o.getTotalAmount()) %></td>
                <td>
                    <a href="order?action=vieworder&orderId=<%= o.getOrderId() %>">View</a>
                    <%
                                String status = o.getStatus();
                                if (!"CANCELLED".equalsIgnoreCase(status) && !"SHIPPED".equalsIgnoreCase(status)) {
                    %>
                    | <a href="order?action=cancel&orderId=<%= o.getOrderId() %>"
                         onclick="return confirm('Cancel this order?')">Cancel</a>
                    <%
                                }
                    %>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr><td colspan="5">You have no orders.</td></tr>
            <%
                }
            %>
        </table>
        <a href="home.jsp">Back to home page</a>
    </body>
</html>
