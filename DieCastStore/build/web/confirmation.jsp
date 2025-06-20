<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String message = (String) request.getAttribute("message");
%>
<html>
    <head>
        <title>Thanh toán thành công</title>
    </head>
    <body>
        <h2>Xác nhận đơn hàng</h2>

        <% if (message != null) { %>
        <p style="color:green;"><%= message %></p>
        <% } else { %>
        <p>Đơn hàng của bạn đã được xử lý thành công.</p>
        <% } %>

        <a href="shop.jsp">Quay lại trang mua hàng</a>
    </body>
</html>
