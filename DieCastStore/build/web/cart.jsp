<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Cart"%>
<%@page import="model.CartItem"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cart</title>
    </head>
    <body>
        <h1>My cart</h1>

        <%
            // Lấy cart từ request attribute
            Cart cart = (Cart) request.getAttribute("cart");
        
            // Hiển thị thông báo lỗi nếu có
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <div style="color: red; margin-bottom: 10px;">
            <strong>Lỗi: </strong><%= error %>
        </div>
        <%
            }
        
            // Hiển thị thông báo thành công nếu có
            String success = (String) request.getAttribute("success");
            if (success != null) {
        %>
        <div style="color: green; margin-bottom: 10px;">
            <strong>Succeed: </strong><%= success %>
        </div>
        <%
            }
        
            // Kiểm tra giỏ hàng có trống không
            if (cart == null || cart.isEmpty()) {
        %>
        <div>
            <h3>Your cart is empty</h3>
            <p><a href="productList.jsp">Continue shopping</a></p>
        </div>
        <%
            } else {
                List<CartItem> items = cart.getItems();
        %>
        <div>
            <p>Total products: <strong><%= cart.getTotalQuantity() %></strong></p>
            <p>Total amount: <strong><%= String.format("%.2f", cart.getTotalAmount()) %> $</strong></p>
        </div>

        <table border="1" cellpadding="5" cellspacing="0" width="100%">
            <thead>
                <tr>
                    <th>No.</th>
                    <th>Product Name</th>
                    <th>Type</th>
                    <th>Unit price</th>
                    <th>Quantity</th>
                    <th>Total amount</th>
                    <th>Active</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int index = 1;
                    for (CartItem item : items) {
                %>
                <tr>
                    <td><%= index++ %></td>
                    <td><%= item.getItemName() %></td>
                    <td>
                        <%= "MODEL".equals(item.getItemType()) ? "Mô hình xe" : "Phụ kiện" %>
                    </td>
                    <td><%= String.format("%.2f", item.getUnitPrice()) %> $</td>
                    <td>
                        <!-- Form cập nhật số lượng -->
                        <form action="cart" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="itemType" value="<%= item.getItemType() %>">
                            <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
                            <input type="number" name="quantity" value="<%= item.getQuantity() %>" 
                                   min="1" max="100" style="width: 60px;">
                            <input type="submit" value="Update">
                        </form>
                    </td>
                    <td><%= String.format("%.2f", item.getSubTotal()) %> $</td>
                    <td>
                        <!-- Nút xóa sản phẩm -->
                        <a href="cart?action=remove&itemType=<%= item.getItemType() %>&itemId=<%= item.getItemId() %>"
                           onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?')">
                            Delete
                        </a>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <div style="margin-top: 20px;">
            <h3>Total: <%= String.format("%.2f", cart.getTotalAmount()) %> $</h3>
        </div>

        <div style="margin-top: 20px;">
            <a href="cart?action=clear" 
               onclick="return confirm('Bạn có chắc muốn xóa toàn bộ giỏ hàng?')"
               style="color: red;">
                Clear entire cart
            </a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="productList.jsp">Continue shopping</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="cart?action=checkout" style="background-color: #4CAF50; color: white; padding: 10px 20px; text-decoration: none;">
                Pay
            </a>
        </div>
        <%
            }
        %>

        <br><br>
        <a href="home.jsp">Back to home page</a>
    </body>
</html>