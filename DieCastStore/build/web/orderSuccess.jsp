<%-- 
    Document   : orderSuccess
    Created on : Jun 25, 2025, 10:22:45 PM
    Author     : Admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    String orderId = (String) request.getAttribute("orderId");
    Double totalAmount = (Double) request.getAttribute("totalAmount");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Order successful - DieCastStore</title>
    </head>
    <body>
        <div align="center" style="margin-top: 50px;">
            <div style="font-size: 48px; color: green;">&#10003;</div>
            <h2>Order successful!</h2>
            <p>Thank you for ordering at DieCastStore.</p>
            <p><b>Order code:</b> <%= orderId %></p>
            <p><b>Total amount:</b> <%= String.format("%,.2f", totalAmount) %> $</p>
            <p>We will contact you as soon as possible to confirm your order.</p>

            <br><br>
            <div>
                <a href="productList.jsp">Continue shopping</a> |
                <a href="home.jsp">Back to home page</a>
            </div>
        </div>
    </body>
</html>

