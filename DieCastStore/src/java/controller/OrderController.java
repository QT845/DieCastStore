/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.CustomerAccount;
import model.Order;
import model.OrderDetail;

/**
 *
 * @author Admin
 */
@WebServlet(name = "OrderController", urlPatterns = {"/order", "/OrderController"})
public class OrderController extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        try {
            if (action == null) {
                action = "list";
            }
            switch (action) {
                case "list":
                    listOrders(request, response);
                    break;
                case "vieworder":
                    viewOrders(request, response);
                    break;
                case "cancel":
                    cancelOrder(request, response);
                    break;
                default:
                    listOrders(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("orderlist.jsp").forward(request, response);
            return;
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private void listOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        CustomerAccount user = (CustomerAccount) session.getAttribute("user");
        String customerId = null;
        if (user != null) {
            customerId = user.getCustomerId();
        }

        if (customerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Order> orders = orderDAO.getOrdersByCustomer(customerId);
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("orderlist.jsp").forward(request, response);
    }

    private void viewOrders(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String orderId = request.getParameter("orderId");
        if (orderId == null) {
            response.sendRedirect("order?action=list");
            return;
        }
        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            response.sendRedirect("order?action=list");
            return;
        }
        List<OrderDetail> details = orderDAO.getOrderDetails(orderId);
        request.setAttribute("order", order);
        request.setAttribute("details", details);
        request.getRequestDispatcher("orderdetail.jsp").forward(request, response);
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();

        CustomerAccount user = (CustomerAccount) session.getAttribute("user");
        String customerId = null;
        if (user != null) {
            customerId = user.getCustomerId();
        }
        if (customerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String orderId = request.getParameter("orderId");

        try {
            if (orderId == null || orderId.trim().isEmpty()) {
                request.setAttribute("error", "Order ID is required");
                listOrders(request, response);
                return;
            }

            Order order = orderDAO.getOrderById(orderId);
            if (order == null) {
                request.setAttribute("error", "Order not found");
                listOrders(request, response);
                return;
            }

            if (!customerId.equals(order.getCustomerId())) {
                request.setAttribute("error", "You don't have permission to cancel this order");
                listOrders(request, response);
                return;
            }

            String currentStatus = order.getStatus();
            if ("CANCELLED".equals(currentStatus) || "DELIVERED".equals(currentStatus) || "SHIPPED".equals(currentStatus)) {
                request.setAttribute("error", "Cannot cancel order with status: " + currentStatus);
                listOrders(request, response);
                return;
            }

            boolean success = orderDAO.updateOrderStatus(orderId, "CANCELLED");

            if (success) {
                request.setAttribute("success", "Order cancelled successfully");
            } else {
                request.setAttribute("error", "Failed to cancel order. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error while cancelling order: " + e.getMessage());
        }
        response.sendRedirect("order?action=list");
    }

}
