/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import model.Cart;
import model.CartItem;
import utils.DBUtils;

import java.sql.Connection;

public class OrderDAO {

    public String createOrder(String customerId, double totalAmount, Cart cart) throws SQLException, ClassNotFoundException {
        String orderId = "ORD" + System.currentTimeMillis(); // Tạo orderId unique
        Connection conn = null;

        try {
            conn = DBUtils.getConnection();
            conn.setAutoCommit(false);

            // Tách thành 2 bước
            insertOrder(conn, orderId, customerId, totalAmount);
            insertOrderDetail(conn, orderId, cart);

            conn.commit();
            return orderId;

        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    private void insertOrder(Connection conn, String orderId, String customerId, double totalAmount) throws SQLException {
        String orderSql = "INSERT INTO orders (orderId, customerId, status, total_amount) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(orderSql)) {
            ps.setString(1, orderId);
            ps.setString(2, customerId);
            ps.setString(3, "PENDING");
            ps.setDouble(4, totalAmount);
            ps.executeUpdate();
        }
    }

    private void insertOrderDetail(Connection conn, String orderId, Cart cart) throws SQLException {
        String detailSql = "INSERT INTO orderDetail (orderId, itemType, itemId, unitPrice, unitQuantity) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(detailSql)) {
            for (CartItem item : cart.getItems()) {
                ps.setString(1, orderId);
                ps.setString(2, item.getItemType());
                ps.setString(3, item.getItemId());
                ps.setDouble(4, item.getUnitPrice());
                ps.setInt(5, item.getQuantity());
                ps.executeUpdate();
            }
        }
    }

    public boolean updateCustomerInfo(String customerId, String customerName, String phone, String address) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE customer SET customerName = ?, phone = ?, address = ? WHERE customerId = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customerName);
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setString(4, customerId);

            return ps.executeUpdate() > 0;
        }
    }
}

