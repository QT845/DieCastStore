/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AccessoryDAO;
import dao.CartDAO;
import dao.ModelCarDAO;
import dao.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Accessory;
import model.Cart;
import model.CartItem;
import model.CustomerAccount;
import model.ModelCar;

/**
 *
 * @author Admin
 */
@WebServlet(name = "CartController", urlPatterns = {"/cart", "/CartController"})
public class CartController extends HttpServlet {

    private ModelCarDAO modelCarDAO;
    private AccessoryDAO accessoryDAO;
    private OrderDAO orderDAO;
    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        modelCarDAO = new ModelCarDAO();
        accessoryDAO = new AccessoryDAO();
        orderDAO = new OrderDAO();
        cartDAO = new CartDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "cart.jsp";
        String action = request.getParameter("action");
        String itemId = request.getParameter("itemId");
        String itemType = request.getParameter("itemType");
        String quantity = request.getParameter("quantity");

        // Debug log
        System.out.println("=== Debug CartController ===");
        System.out.println("Action: " + action);
        System.out.println("ItemId: " + itemId);
        System.out.println("ItemType: " + itemType);
        System.out.println("Quantity: " + quantity);
        System.out.println("============================");

        try {
            if (action == null) {
                action = "view";
            }

            switch (action) {
                case "view":
                    viewCart(request, response);
                    return;
                case "add":
                    addToCart(request, response);
                    return;
                case "update":
                    updateCart(request, response);
                    return;
                case "remove":
                    removeFromCart(request, response);
                    return;
                case "clear":
                    clearCart(request, response);
                    return;
                case "checkout":
                    showCheckout(request, response);
                    return;
                case "processCheckout":
                    processCheckout(request, response);
                    return;
                case "buyNow":
                    handleBuyNow(request, response);
                    return;
                default:
                    viewCart(request, response);
                    return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            // Nếu có lỗi, forward đến trang cart để hiển thị lỗi
            request.getRequestDispatcher("cart.jsp").forward(request, response);
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

    private void viewCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        request.setAttribute("cart", cart);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {

            // KIỂM TRA ĐĂNG NHẬP TRƯỚC KHI ADD TO CART
            HttpSession session = request.getSession();
            CustomerAccount user = (CustomerAccount) session.getAttribute("user");

            if (user == null) {
                // Chưa đăng nhập -> redirect đến login
                session.setAttribute("message", "Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng");

                // Lưu URL hiện tại để redirect về sau khi login
                String referer = request.getHeader("Referer");
                if (referer != null) {
                    session.setAttribute("redirectAfterLogin", referer);
                }

                response.sendRedirect("login.jsp");
                return;
            }

            String itemType = request.getParameter("itemType"); // "MODEL" hoặc "ACCESSORY"
            String itemId = request.getParameter("itemId");
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            if (quantity <= 0) {
                request.setAttribute("error", "Số lượng phải lớn hơn 0");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            // Lấy thông tin sản phẩm từ database
            String itemName = "";
            double unitPrice = 0.0;
            int availableQuantity = 0;

            if ("MODEL".equals(itemType)) {
                ModelCar model = modelCarDAO.getById(itemId);
                if (model != null) {
                    itemName = model.getModelName();
                    unitPrice = model.getPrice();
                    availableQuantity = model.getQuantity();
                } else {
                    request.setAttribute("error", "Sản phẩm không tồn tại");
                    response.sendRedirect(request.getHeader("Referer"));
                    return;
                }
            } else if ("ACCESSORY".equals(itemType)) {
                Accessory accessory = accessoryDAO.getById(itemId);
                if (accessory != null) {
                    itemName = accessory.getAccessoryName();
                    unitPrice = accessory.getPrice();
                    availableQuantity = accessory.getQuantity();
                } else {
                    request.setAttribute("error", "Sản phẩm không tồn tại");
                    response.sendRedirect(request.getHeader("Referer"));
                    return;
                }
            } else {
                request.setAttribute("error", "Loại sản phẩm không hợp lệ");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            // Kiểm tra số lượng tồn kho
            if (quantity > availableQuantity) {
                request.setAttribute("error", "Không đủ số lượng trong kho. Còn lại: " + availableQuantity);
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            // Lấy cart từ session
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                cart = new Cart();
            }

            // Thêm vào cart
            cart.addItem(itemType, itemId, itemName, unitPrice, quantity);
            session.setAttribute("cart", cart);
            request.setAttribute("success", "Đã thêm sản phẩm vào giỏ hàng");
            response.sendRedirect("cart?action=view");

            // LƯU VÀO DATABASE
            CartItem newItem = new CartItem(itemType, itemId, itemName, unitPrice, quantity);
            cartDAO.saveCartItem(user.getCustomerId(), newItem);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getHeader("Referer"));
        }
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String itemType = request.getParameter("itemType");
            String itemId = request.getParameter("itemId");
            int newQuantity = Integer.parseInt(request.getParameter("quantity"));

            HttpSession session = request.getSession();
            CustomerAccount user = (CustomerAccount) session.getAttribute("user");
            Cart cart = (Cart) session.getAttribute("cart");

            if (cart != null) {
                if (newQuantity <= 0) {
                    cart.removeItem(itemType, itemId);
                    // Xóa khỏi database
                    if (user != null) {
                        cartDAO.removeCartItem(user.getCustomerId(), itemType, itemId);
                    }
                } else {
                    // Kiểm tra số lượng tồn kho
                    int availableQuantity = 0;
                    if ("MODEL".equals(itemType)) {
                        ModelCar model = modelCarDAO.getById(itemId);
                        if (model != null) {
                            availableQuantity = model.getQuantity();
                        }
                    } else if ("ACCESSORY".equals(itemType)) {
                        Accessory accessory = accessoryDAO.getById(itemId);
                        if (accessory != null) {
                            availableQuantity = accessory.getQuantity();
                        }
                    }

                    if (newQuantity > availableQuantity) {
                        request.setAttribute("error", "Không đủ số lượng trong kho");
                    } else {
                        cart.updateQuantity(itemType, itemId, newQuantity);
                        request.setAttribute("success", "Đã cập nhật giỏ hàng");
                        // Cập nhật database
                        if (user != null) {
                            cartDAO.updateCartItemQuantity(user.getCustomerId(), itemType, itemId, newQuantity);
                        }
                    }
                }
                session.setAttribute("cart", cart);
            }

        } catch (Exception e) {
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }

        response.sendRedirect("cart?action=view");
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String itemType = request.getParameter("itemType");
        String itemId = request.getParameter("itemId");

        HttpSession session = request.getSession();
        CustomerAccount user = (CustomerAccount) session.getAttribute("user");

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart != null) {
            cart.removeItem(itemType, itemId);
            session.setAttribute("cart", cart);

            // Xóa khỏi database
            if (user != null) {
                cartDAO.removeCartItem(user.getCustomerId(), itemType, itemId);
            }
            request.setAttribute("success", "Đã xóa sản phẩm khỏi giỏ hàng");
        }

        response.sendRedirect("cart?action=view");
    }

    private void clearCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        CustomerAccount user = (CustomerAccount) session.getAttribute("user");

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart != null) {
            cart.clearCart();
            session.setAttribute("cart", cart);
            // Xóa khỏi database
            if (user != null) {
                cartDAO.clearCart(user.getCustomerId());
            }
            request.setAttribute("success", "Đã xóa toàn bộ giỏ hàng");
        }

        response.sendRedirect("cart?action=view");
    }

    private void showCheckout(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession();

        // Debug: In tất cả session attributes
        System.out.println("=== DEBUG SESSION ===");
        System.out.println("Session ID: " + session.getId());

        java.util.Enumeration<String> attributeNames = session.getAttributeNames();
        while (attributeNames.hasMoreElements()) {
            String name = attributeNames.nextElement();
            Object value = session.getAttribute(name);
            System.out.println("Session[" + name + "] = " + value);
        }
        System.out.println("====================");

        // Kiểm tra đăng nhập đúng cách
        CustomerAccount user = (CustomerAccount) session.getAttribute("user");
        if (user == null) {
            System.out.println("Customer not logged in - redirecting to login");
            request.setAttribute("error", "Vui lòng đăng nhập để thanh toán");
            response.sendRedirect("login.jsp");
            return;
        }

        String customerId = user.getCustomerId();
        System.out.println("CustomerId from user object: " + customerId);

        Cart cart = (Cart) session.getAttribute("cart");
        boolean isBuyNow = Boolean.TRUE.equals(session.getAttribute("isBuyNow"));

        // Merge buyNowCart vào cart chính
        if (isBuyNow) {
            Cart buyNowCart = (Cart) session.getAttribute("buyNowCart");
            if (buyNowCart != null && !buyNowCart.getItems().isEmpty()) {
                // Nếu cart chính chưa có thì tạo mới
                if (cart == null) {
                    cart = new Cart();
                }

                // Merge buyNowCart vào cart chính
                for (CartItem item : buyNowCart.getItems()) {
                    cart.addItem(item.getItemType(), item.getItemId(),
                            item.getItemName(), item.getUnitPrice(), item.getQuantity());
                }

                // Cập nhật cart trong session và xóa buyNowCart
                session.setAttribute("cart", cart);
                session.removeAttribute("buyNowCart");
                session.removeAttribute("isBuyNow");
            }
        }

        // Kiểm tra giỏ hàng
        if (cart == null || cart.getItems().isEmpty()) {
            request.setAttribute("error", "Giỏ hàng trống");
            response.sendRedirect("cart?action=view");
            return;
        }

        System.out.println("Cart in showCheckout: " + (cart != null ? cart.getItems().size() + " items" : "null"));

        request.setAttribute("cart", cart);
        request.setAttribute("totalAmount", cart.getTotalAmount());
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    private void processCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        //  Kiểm tra đăng nhập 
        CustomerAccount user = (CustomerAccount) session.getAttribute("user");
        if (user == null) {
            request.setAttribute("error", "Vui lòng đăng nhập để thanh toán");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String customerId = user.getCustomerId();

        // Chỉ lấy cart chính (đã được merge ở showCheckout)
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.getItems().isEmpty()) {
            request.setAttribute("error", "Giỏ hàng trống");
            response.sendRedirect("cart?action=view");
            return;
        }

        // Lấy thông tin từ form
        String customerName = request.getParameter("customerName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Validate dữ liệu
        if (customerName == null || customerName.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || address == null || address.trim().isEmpty()) {

            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            request.setAttribute("cart", cart);
            request.setAttribute("totalAmount", cart.getTotalAmount());
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            return;
        }

        // Thêm validation cho phone
        if (!phone.matches("^[0-9]{10,11}$")) {
            request.setAttribute("error", "Số điện thoại không hợp lệ!");
            request.setAttribute("cart", cart);
            request.setAttribute("totalAmount", cart.getTotalAmount());
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            return;
        }

        try {
            // Lưu totalAmount trước khi clear cart
            double totalAmount = cart.getTotalAmount();
            // Cập nhật thông tin khách hàng
            orderDAO.updateCustomerInfo(customerId, customerName.trim(),
                    phone.trim(), address.trim());

            // Tạo đơn hàng
            String orderId = orderDAO.createOrder(customerId, cart.getTotalAmount(), cart);

            // Xóa giỏ hàng sau khi đặt hàng thành công
            cart.clearCart();
            session.setAttribute("cart", cart);

            // Đảm bảo xóa hết các session liên quan đến buyNow
            session.removeAttribute("buyNowCart");
            session.removeAttribute("isBuyNow");

            // Chuyển đến trang thành công
            request.setAttribute("orderId", orderId);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("success", "Đặt hàng thành công!");
            request.getRequestDispatcher("orderSuccess.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi đặt hàng: " + e.getMessage());
            request.setAttribute("cart", cart);
            request.setAttribute("totalAmount", cart.getTotalAmount());
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }

    private void handleBuyNow(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String itemType = request.getParameter("itemType");
            String itemId = request.getParameter("itemId");
            String quantityStr = request.getParameter("quantity");

            // Debug
            System.out.println("handleBuyNow - itemType: " + itemType);
            System.out.println("handleBuyNow - itemId: " + itemId);
            System.out.println("handleBuyNow - quantity: " + quantityStr);

            if (itemType == null || itemId == null || quantityStr == null) {
                System.out.println("Missing parameters!");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            int quantity = Integer.parseInt(quantityStr);

            if (quantity <= 0) {
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            String itemName = "";
            double unitPrice = 0.0;
            int availableQuantity = 0;

            if ("MODEL".equals(itemType)) {
                ModelCar model = modelCarDAO.getById(itemId);
                if (model != null) {
                    itemName = model.getModelName();
                    unitPrice = model.getPrice();
                    availableQuantity = model.getQuantity();
                } else {
                    response.sendRedirect(request.getHeader("Referer"));
                    return;
                }
            } else if ("ACCESSORY".equals(itemType)) {
                Accessory accessory = accessoryDAO.getById(itemId);
                if (accessory != null) {
                    itemName = accessory.getAccessoryName();
                    unitPrice = accessory.getPrice();
                    availableQuantity = accessory.getQuantity();
                } else {
                    response.sendRedirect(request.getHeader("Referer"));
                    return;
                }
            } else {
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            if (quantity > availableQuantity) {
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            Cart buyNowCart = new Cart();
            buyNowCart.addItem(itemType, itemId, itemName, unitPrice, quantity);

            HttpSession session = request.getSession();
            session.setAttribute("buyNowCart", buyNowCart);
            session.setAttribute("isBuyNow", true);

            response.sendRedirect("cart?action=checkout");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getHeader("Referer"));
        }
    }
}
