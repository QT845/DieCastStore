<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Order" %>
<%@ page import="model.OrderDetail" %>
<%@ page import="java.util.List" %>
<%
    Order cart = (Order) request.getAttribute("cart");
    String message = (String) request.getAttribute("message");
%>
<html>
    <head>
        <title>Giỏ Hàng</title>
    </head>
    <body>
        <h2>Giỏ hàng của bạn</h2>

        <% if (message != null) { %>
        <p style="color:red;"><%= message %></p>
        <% } %>

        <% if (cart == null || cart.getOrderDetails() == null || cart.getOrderDetails().isEmpty()) { %>
        <p>Không có sản phẩm nào trong giỏ hàng.</p>
        <% } else { %>
        <table border="1">
            <tr>
                <th>STT</th>
                <th>Loại</th>
                <th>Mã sản phẩm</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Tổng</th>
                <th>Hành động</th>
            </tr>
            <%
                List<OrderDetail> list = cart.getOrderDetails();
                int index = 1;
                double total = 0;
                for (OrderDetail d : list) {
                    double lineTotal = d.getUnitPrice() * d.getUnitQuantity();
                    total += lineTotal;
            %>
            <tr>
                <td><%= index++ %></td>
                <td><%= d.getItemType() %></td>
                <td><%= d.getItemId() %></td>
                <td><%= d.getUnitPrice() %></td>
                <td><%= d.getUnitQuantity() %></td>
                <td><%= lineTotal %></td>
                <td>
                    <form action="cart" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="remove">
                        <input type="hidden" name="orderId" value="<%= d.getOrderId() %>">
                        <input type="hidden" name="itemType" value="<%= d.getItemType() %>">
                        <input type="hidden" name="itemId" value="<%= d.getItemId() %>">
                        <input type="submit" value="Xoá">
                    </form>
                    <form action="cart" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="orderId" value="<%= d.getOrderId() %>">
                        <input type="hidden" name="itemType" value="<%= d.getItemType() %>">
                        <input type="hidden" name="itemId" value="<%= d.getItemId() %>">
                        <input type="number" name="quantity" value="<%= d.getUnitQuantity() %>" min="1">
                        <input type="submit" value="Cập nhật">
                    </form>
                </td>
            </tr>
            <% } %>
            <tr>
                <td colspan="5" align="right"><strong>Tổng cộng:</strong></td>
                <td colspan="2"><%= total %></td>
            </tr>
        </table>

        <form action="cart" method="post">
            <input type="hidden" name="action" value="clear">
            <input type="submit" value="Xoá tất cả">
        </form>

        <form action="cart" method="post">
            <input type="hidden" name="action" value="checkout">
            <input type="submit" value="Thanh toán">
        </form>
        <% } %>

        <a href="shop.jsp">Tiếp tục mua sắm</a>

    </body>
</html>
