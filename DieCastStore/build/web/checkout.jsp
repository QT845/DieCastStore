<%-- 
    Document   : checkout
    Created on : Jun 20, 2025, 12:39:32 PM
    Author     : Admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.OrderDetail" %>
<%@ page import="java.util.List" %>

<%
    List<OrderDetail> cart = (List<OrderDetail>) session.getAttribute("cart");
    String message = (String) request.getAttribute("message");
%>

<html>
    <head>
        <title>Thanh toán</title>
        <style>
            table {
                width: 80%;
                margin: auto;
                border-collapse: collapse;
            }

            th, td {
                border: 1px solid #ccc;
                padding: 10px;
                text-align: center;
            }

            .btn {
                padding: 10px 20px;
                background-color: #4CAF50;
                color: white;
                border: none;
                margin-top: 20px;
                cursor: pointer;
            }

            .btn:hover {
                background-color: #45a049;
            }

            .center {
                text-align: center;
            }
        </style>
    </head>
    <body>
        <h2 class="center">Xác nhận thanh toán</h2>

        <% if (message != null) { %>
        <p style="color: red; text-align:center;"><%= message %></p>
        <% } %>

        <% if (cart == null || cart.isEmpty()) { %>
        <p class="center">Không có sản phẩm nào trong giỏ hàng.</p>
        <% } else { %>
        <form action="CartController" method="post" class="center">
            <input type="hidden" name="action" value="checkout">
            <table>
                <tr>
                    <th>STT</th>
                    <th>Tên sản phẩm</th>
                    <th>Loại</th>
                    <th>Đơn giá</th>
                    <th>Số lượng</th>
                    <th>Thành tiền</th>
                </tr>
                <%
                    int index = 1;
                    double total = 0;
                    for (OrderDetail d : cart) {
                        double itemTotal = d.getUnitQuantity() * d.getUnitPrice();
                        total += itemTotal;
                %>
                <tr>
                    <td><%= index++ %></td>
                    <td><%= d.getItemId() %></td>
                    <td><%= d.getItemType() %></td>
                    <td><%= String.format("%,.0f", d.getUnitPrice()) %> VNĐ</td>
                    <td><%= d.getUnitQuantity() %></td>
                    <td><%= String.format("%,.0f", itemTotal) %> VNĐ</td>
                </tr>
                <% } %>
                <tr>
                    <td colspan="5" style="text-align:right;"><strong>Tổng tiền:</strong></td>
                    <td><strong><%= String.format("%,.0f", total) %> VNĐ</strong></td>
                </tr>
            </table>
            <br>
            <input type="submit" class="btn" value="Xác nhận Đặt hàng">
        </form>
        <% } %>

        <div class="center">
            <br><a href="CartController?action=view"> Quay lại giỏ hàng</a>
        </div>
    </body>
</html>

