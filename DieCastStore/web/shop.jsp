<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Order" %>
<%@ page import="model.OrderDetail" %>
<%@ page import="java.util.List" %>

<%
    List<OrderDetail> orders = (List<OrderDetail>) request.getAttribute("orders");

    if (orders == null || orders.isEmpty()) {
%>
<p style="color:red;">Không có sản phẩm nào được tìm thấy.</p>
<a href="home.jsp">Quay lại trang chủ</a>
<% return; } %>

<html>
    <head>
        <title>Danh sách sản phẩm</title>
    </head>
    <body>

        <h2>Các sản phẩm hiện có</h2>

        <table border="1" cellpadding="8" cellspacing="0">
            <tr>
                <th>STT</th>
                <th>Loại</th>
                <th>Mã sản phẩm</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Hành động</th>
            </tr>

            <%
                int index = 1;
                for (OrderDetail o : orders) {
            %>
            <tr>
                <td><%= index++ %></td>
                <td><%= o.getItemType() %></td>
                <td><%= o.getItemId() %></td>
                <td><%= o.getUnitPrice() %> VNĐ</td>
                <td>
                    <form action="cart" method="post">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="itemId" value="<%= o.getItemId() %>">
                        <input type="hidden" name="itemType" value="<%= o.getItemType() %>">
                        <input type="hidden" name="unitPrice" value="<%= o.getUnitPrice() %>">
                        <input type="number" name="quantity" value="1" min="1" style="width:50px;">
                        </td>
                        <td>
                            <input type="submit" value="Thêm vào giỏ">
                    </form>
                </td>
            </tr>
            <% } %>
        </table>

        <br>
        <a href="cart?action=view"> Xem giỏ hàng</a>

    </body>
</html>
