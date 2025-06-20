/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CartDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.CustomerAccount;
import model.Order;
import model.OrderDetail;

/**
 *
 * @author Admin
 */
@WebServlet(name = "CartController", urlPatterns = {"/cart","/CartController"})
public class CartController extends HttpServlet {

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "cart.jsp";
        try {
            String action = request.getParameter("action");
            if (action != null) {
                switch (action) {
                    case "view":
                        url = handleView(request, response);
                        break;
                    case "add":
                        url = handleAdd(request, response);
                        break;
                    case "buynow":
                        url = handleBuyNow(request, response);
                        break;
                    case "update":
                        url = handleUpdate(request, response);
                        break;
                    case "remove":
                        url = handleRemoveCart(request, response);
                        break;
                    case "clear":
                        url = handleClearCart(request, response);
                        break;
                    case "checkout":
                        url = handleCheckout(request);
                        break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Lỗi hệ thống: " + e.getMessage());
            url = "cart.jsp";
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
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

    private String handleView(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        List<OrderDetail> cart = getOrCreateCart(session);
        request.setAttribute("cart", cart);
        return "cart.jsp";
    }

    private String handleAdd(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        CustomerAccount user = (CustomerAccount) session.getAttribute("user");


        if (user == null) {
            request.setAttribute("message", "Bạn cần đăng nhập để thêm vào giỏ hàng.");
            return "login.jsp";
        }

        try {
            String itemId = request.getParameter("itemId");
            String itemType = request.getParameter("itemType");
            String unitPriceStr = request.getParameter("unitPrice");
            String quantityStr = request.getParameter("quantity");
            String cusId = request.getParameter("cusId");

            if (itemId == null || unitPriceStr == null || quantityStr == null) {
                request.setAttribute("message", "Thiếu thông tin sản phẩm.");
                return "cart.jsp";
            }

            double unitPrice = Double.parseDouble(unitPriceStr);
            int quantity = Integer.parseInt(quantityStr);

            CartDAO cartDAO = new CartDAO();
            boolean success = cartDAO.addToCart(cusId, itemType, itemId, unitPrice, quantity);
            
            if (success) {
                request.setAttribute("message", "Đã thêm vào giỏ hàng.");
            } else {
                request.setAttribute("message", "Không thể thêm vào giỏ hàng.");
            }

            return "cart.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Lỗi hệ thống: " + e.getMessage());
            return "cart.jsp";
        }
    }


    private String handleUpdate(HttpServletRequest request, HttpServletResponse response) {
        String itemId = request.getParameter("itemId");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        HttpSession session = request.getSession();
        List<OrderDetail> cart = getOrCreateCart(session);

        for (OrderDetail item : cart) {
            if (item.getItemId().equals(itemId)) {
                item.setUnitQuantity(quantity);
                break;
            }
        }

        session.setAttribute("cart", cart);
        return "cart.jsp";
    }

    private String handleRemoveCart(HttpServletRequest request, HttpServletResponse response) {
        String itemId = request.getParameter("itemId");

        HttpSession session = request.getSession();
        List<OrderDetail> cart = getOrCreateCart(session);

        cart.removeIf(item -> item.getItemId().equals(itemId));

        session.setAttribute("cart", cart);
        return "cart.jsp";
    }

    private String handleClearCart(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        session.removeAttribute("cart");
        return "cart.jsp";
    }

    private String handleCheckout(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String customerId = (String) session.getAttribute("customerId");

        if (customerId == null) {
            request.setAttribute("message", "Bạn cần đăng nhập để thanh toán.");
            return "login.jsp";
        }

        List<OrderDetail> cart = (List<OrderDetail>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            request.setAttribute("message", "Giỏ hàng trống.");
            return "cart.jsp";
        }

       // lưu đơn hàng vào database bảng orders/order_details
        session.removeAttribute("cart");

        request.setAttribute("message", "Đặt hàng thành công!");
        return "confirmation.jsp";
    }


    
    private List<OrderDetail> getOrCreateCart(HttpSession session) {
        List<OrderDetail> cart = (List<OrderDetail>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private String handleBuyNow(HttpServletRequest request, HttpServletResponse response) {
        handleAdd(request, response);
        return "checkout.jsp";
    }
}
