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
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderDetail;

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
        try {
            conn.setAutoCommit(false);
            PreparedStatement psOrder = conn.prepareStatement(orderSql);
            psOrder.setString(1, orderId);
            psOrder.setString(2, customerId);
            psOrder.setString(3, "PENDING");
            psOrder.setDouble(4, totalAmount);
            psOrder.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void insertOrderDetail(Connection conn, String orderId, Cart cart) throws SQLException {
        String detailSql = "INSERT INTO orderDetail (orderId, itemType, itemId, unitPrice, unitQuantity) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = conn.prepareStatement(detailSql);
            for (CartItem item : cart.getItems()) {
                ps.setString(1, orderId);
                ps.setString(2, item.getItemType());
                ps.setString(3, item.getItemId());
                ps.setDouble(4, item.getUnitPrice());
                ps.setInt(5, item.getQuantity());
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean updateCustomerInfo(String customerId, String customerName, String phone, String address) {
        String sql = "UPDATE customer SET customerName = ?, phone = ?, address = ? WHERE customerId = ?";
        try {
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, customerName);
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setString(4, customerId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // lấy tất cả đơn
    public List<Order> getOrdersByCustomer(String customerId) {
        List<Order> orderList = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE customerId = ? ORDER BY orderDate DESC";

        try {
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order ord = new Order();
                ord.setOrderId(rs.getString("orderId"));
                ord.setCustomerId(rs.getString("customerId"));
                ord.setOrderDate(rs.getTimestamp("orderDate"));
                ord.setStatus(rs.getString("status"));
                ord.setTotalAmount(rs.getDouble("total_amount"));
                orderList.add(ord);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderList;
    }

    // lấy chi tiết 1 đơn
    public Order getOrderById(String orderId) {
        String sql = "SELECT * FROM orders WHERE orderId = ?";
        try {
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getString("orderId"));
                o.setCustomerId(rs.getString("customerId"));
                o.setOrderDate(rs.getTimestamp("orderDate"));
                o.setStatus(rs.getString("status"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                return o;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<OrderDetail> getOrderDetails(String orderId) {
        List<OrderDetail> detailList = new ArrayList<>();
        String sql = "SELECT * FROM orderDetail WHERE orderId = ?";
        try {
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderDetail ord = new OrderDetail();
                ord.setOrderId(rs.getString("orderId"));
                ord.setItemType(rs.getString("itemType"));
                ord.setItemId(rs.getString("itemId"));
                ord.setUnitPrice(rs.getDouble("unitPrice"));
                ord.setUnitQuantity(rs.getInt("unitQuantity"));
                detailList.add(ord);               
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return detailList;
    }

    public boolean updateOrderStatus(String orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE orderId = ?";
        try {
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, orderId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
