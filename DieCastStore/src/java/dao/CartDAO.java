package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderDetail;
import utils.DBUtils;

/**
 *
 * @author Admin
 */
public class CartDAO {
    
    private static final String GET_CART = "SELECT orderId, customerId, orderDate, status, total_amount FROM orders WHERE customerId = ? AND status = 'CART'";
    private static final String GET_CART_DETAILS = "SELECT orderId, itemType, itemId, unitPrice, unitQuantity FROM orderDetail WHERE orderId = ?";
    private static final String ADD_CART_ITEM = "INSERT INTO orderDetail (orderId, itemType, itemId, unitPrice, unitQuantity) VALUES (?, ?, ?, ?, ?)";
    private static final String UPDATE_QUANTITY = "UPDATE orderDetail SET unitQuantity = ? WHERE orderId = ? AND itemType = ? AND itemId = ?";
    private static final String REMOVE_CART_ITEM = "DELETE FROM orderDetail WHERE orderId = ? AND itemType = ? AND itemId = ?";
    private static final String CLEAR_CART = "DELETE FROM orderDetail WHERE orderId = ?";
    private static final String FIND_ITEM_CART = "SELECT orderId, itemType, itemId, unitPrice, unitQuantity FROM orderDetail WHERE orderId = ? AND itemType = ? AND itemId = ?";
    private static final String CREATE_CART = "INSERT INTO orders (orderId, customerId, orderDate, status, total_amount) VALUES (?, ?, GETDATE(), 'CART', 0)";
    private static final String UPDATE_CART_TOTAL = "UPDATE orders SET total_amount = (SELECT SUM(unitPrice * unitQuantity) FROM orderDetail WHERE orderId = ?) WHERE orderId = ?";
    private static final String GET_TOTAL_ITEM_COUNT = "SELECT SUM(unitQuantity) FROM orderDetail WHERE orderId = ?";
    private static final String DELETE_EMPTY_CART = "DELETE FROM orders WHERE orderId = ? AND NOT EXISTS (SELECT 1 FROM orderDetail WHERE orderId = ?)";
    
    
    public Order getCart(String customerId) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        Order cart = null;
        
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_CART);
            st.setString(1, customerId);
            rs = st.executeQuery();
            
            if (rs.next()) {
                cart = new Order();
                cart.setOrderId(rs.getString("orderId"));
                cart.setCustomerId(rs.getString("customerId"));
                cart.setOrderDate(rs.getTimestamp("orderDate"));
                cart.setStatus(rs.getString("status"));
                cart.setTotalAmount(rs.getDouble("total_amount"));
                
                // Get cart items
                List<OrderDetail> items = getCartDetails(cart.getOrderId());
                cart.setOrderDetails(items);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }
        
        return cart;
    }
    
    public boolean addToCart(String customerId, String itemType, String itemId, double unitPrice, int quantity) {
        Connection c = null;
        PreparedStatement st = null;
        boolean result = false;
        
        try {
            c = DBUtils.getConnection();
            c.setAutoCommit(false);
            
            // Get or create cart
            Order cart = getCart(customerId);
            if (cart == null) {
                cart = createNewCart(customerId);
                if (cart == null) {
                    c.rollback();
                    return false;
                }
            }
            
            
            OrderDetail existingItem = findItemInCart(cart.getOrderId(), itemType, itemId);
            
            if (existingItem != null) {
                
                int newQuantity = existingItem.getUnitQuantity() + quantity;
                result = updateQuantity(cart.getOrderId(), itemType, itemId, newQuantity);
            } else {
               
                st = c.prepareStatement(ADD_CART_ITEM);
                st.setString(1, cart.getOrderId());
                st.setString(2, itemType);
                st.setString(3, itemId);
                st.setDouble(4, unitPrice);
                st.setInt(5, quantity);
                
                result = st.executeUpdate() > 0;
            }
            
            if (result) {
                updateCartTotal(cart.getOrderId());
                c.commit();
            } else {
                c.rollback();
            }
            
        } catch (Exception e) {
            try {
                if (c != null) c.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (c != null) c.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources(c, st, null);
        }
        
        return result;
    }
    
    public boolean updateQuantity(String orderId, String itemType, String itemId, int newQuantity) {
        Connection c = null;
        PreparedStatement st = null;
        boolean result = false;
        
        try {
            c = DBUtils.getConnection();
            c.setAutoCommit(false);
            
            if (newQuantity <= 0) {
                // Remove item if quantity is 0 or negative
                result = removeFromCart(orderId, itemType, itemId);
            } else {
                st = c.prepareStatement(UPDATE_QUANTITY);
                st.setInt(1, newQuantity);
                st.setString(2, orderId);
                st.setString(3, itemType);
                st.setString(4, itemId);
                
                result = st.executeUpdate() > 0;
                
                if (result) {
                    updateCartTotal(orderId);
                    c.commit();
                } else {
                    c.rollback();
                }
            }
            
        } catch (Exception e) {
            try {
                if (c != null) c.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (c != null) c.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources(c, st, null);
        }
        
        return result;
    }
    
     public boolean removeFromCart(String orderId, String itemType, String itemId) {
        Connection c = null;
        PreparedStatement st = null;
        boolean result = false;
        
        try {
            c = DBUtils.getConnection();
            c.setAutoCommit(false);
            
            st = c.prepareStatement(REMOVE_CART_ITEM);
            st.setString(1, orderId);
            st.setString(2, itemType);
            st.setString(3, itemId);
            
            result = st.executeUpdate() > 0;
            
            if (result) {
                updateCartTotal(orderId);
                // Check if cart is empty and delete if necessary
                checkAndDeleteEmptyCart(orderId);
                c.commit();
            } else {
                c.rollback();
            }
            
        } catch (Exception e) {
            try {
                if (c != null) c.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (c != null) c.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources(c, st, null);
        }
        
        return result;
    }
    
    public boolean clearCart(String customerId) {
        Connection c = null;
        PreparedStatement st = null;
        boolean result = false;
        
        try {
            c = DBUtils.getConnection();
            c.setAutoCommit(false);
            
            Order cart = getCart(customerId);
            if (cart != null) {
                st = c.prepareStatement(CLEAR_CART);
                st.setString(1, cart.getOrderId());
                
                result = st.executeUpdate() >= 0;
                
                if (result) {
                    updateCartTotal(cart.getOrderId());
                    checkAndDeleteEmptyCart(cart.getOrderId());
                    c.commit();
                } else {
                    c.rollback();
                }
            } else {
                result = true; // Cart already empty
            }
            
        } catch (Exception e) {
            try {
                if (c != null) c.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (c != null) c.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources(c, st, null);
        }
        
        return result;
    }
    
     public OrderDetail findItemInCart(String orderId, String itemType, String itemId) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        OrderDetail item = null;
        
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(FIND_ITEM_CART);
            st.setString(1, orderId);
            st.setString(2, itemType);
            st.setString(3, itemId);
            rs = st.executeQuery();
            
            if (rs.next()) {
                item = new OrderDetail();
                item.setOrderId(rs.getString("orderId"));
                item.setItemType(rs.getString("itemType"));
                item.setItemId(rs.getString("itemId"));
                item.setUnitPrice(rs.getDouble("unitPrice"));
                item.setUnitQuantity(rs.getInt("unitQuantity"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }
        
        return item;
    }
    
    public int getTotalItemCount(String customerId) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            Order cart = getCart(customerId);
            if (cart != null) {
                c = DBUtils.getConnection();
                st = c.prepareStatement(GET_TOTAL_ITEM_COUNT);
                st.setString(1, cart.getOrderId());
                rs = st.executeQuery();
                
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }
        
        return count;
    }
    
     private Order createNewCart(String customerId) {
        Connection c = null;
        PreparedStatement st = null;
        Order cart = null;
        
        try {
            c = DBUtils.getConnection();
            
            // Generate unique cart ID
            String cartId = "CART_" + customerId + "_" + System.currentTimeMillis();
            
            st = c.prepareStatement(CREATE_CART);
            st.setString(1, cartId);
            st.setString(2, customerId);
            
            if (st.executeUpdate() > 0) {
                cart = new Order();
                cart.setOrderId(cartId);
                cart.setCustomerId(customerId);
                cart.setStatus("CART");
                cart.setTotalAmount(0.0);
                cart.setOrderDetails(new ArrayList<>());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, null);
        }
        
        return cart;
    }
    
    private void updateCartTotal(String orderId) {
        Connection c = null;
        PreparedStatement st = null;
        
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(UPDATE_CART_TOTAL);
            st.setString(1, orderId);
            st.setString(2, orderId);
            st.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, null);
        }
    }
    
    private List<OrderDetail> getCartDetails(String orderId) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        List<OrderDetail> items = new ArrayList<>();
        
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_CART_DETAILS);
            st.setString(1, orderId);
            rs = st.executeQuery();
            
            while (rs.next()) {
                OrderDetail item = new OrderDetail();
                item.setOrderId(rs.getString("orderId"));
                item.setItemType(rs.getString("itemType"));
                item.setItemId(rs.getString("itemId"));
                item.setUnitPrice(rs.getDouble("unitPrice"));
                item.setUnitQuantity(rs.getInt("unitQuantity"));
                items.add(item);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }
        
        return items;
    }
    
    private void checkAndDeleteEmptyCart(String orderId) {
        Connection c = null;
        PreparedStatement st = null;
        
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(DELETE_EMPTY_CART);
            st.setString(1, orderId);
            st.setString(2, orderId);
            st.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, null);
        }
    }

    private void closeResources(Connection c, PreparedStatement st, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (st != null) {
                st.close();
            }
            if (c != null) {
                c.close();
            }
        } catch (Exception e) {
            System.err.println("Error closing resources: " + e.getMessage());
            e.printStackTrace();
        }
    }

}