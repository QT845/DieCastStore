/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerAccountDAO;
import dao.CustomerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.CustomerAccount;
import utils.AuthUtils;

/**
 *
 * @author hqthi
 */
@WebServlet(name = "UserController", urlPatterns = {"/UserController"})
public class UserController extends HttpServlet {

    private static final String WELCOME_PAGE = "home.jsp";
    private static final String LOGIN_PAGE = "login.jsp";
    private static final String REGISTER_PAGE = "register.jsp";
    private static final String PROFILE_PAGE = "profileForm.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = LOGIN_PAGE;
        try {
            String action = request.getParameter("action");
            if (action != null) {
                switch (action) {
                    case "showLogin":
                        url = "login.jsp";
                        break;
                    case "showRegister":
                        url = "register.jsp";
                        break;
                    case "login":
                        url = handleLogin(request, response);
                        break;
                    case "register":
                        url = handleRegister(request, response);
                        break;
                    case "logout":
                        url = handleLogout(request, response);
                        break;
                    case "updateProfile":
                        url = handleUpdateProfile(request, response);
                        break;
                    case "viewProfile":
                        url = handleViewProfile(request, response);
                        break;
                    default:
                        request.setAttribute("message", "Invalid action: " + action);
                        url = LOGIN_PAGE;
                        break;
                }
            }
        } catch (Exception e) {
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

    private String handleLogin(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        CustomerAccountDAO accountDAO = new CustomerAccountDAO();
        CustomerDAO customerDAO = new CustomerDAO();

        if (userName == null || userName.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("message", "Please enter your User Name and Password!");
            return LOGIN_PAGE;
        }

        try {
            if (accountDAO.login(userName, password)) {
                CustomerAccount account = accountDAO.getByUserName(userName);

                if (account != null) {
                    Customer customer = customerDAO.getById(account.getCustomerId());

                    if (customer != null) {
                        session.setAttribute("account", account);
                        session.setAttribute("customer", customer);
                        session.setAttribute("userName", account.getUserName());
                        session.setAttribute("customerId", account.getCustomerId());
                        session.setAttribute("role", account.getRole());

                        return WELCOME_PAGE;
                    } else {
                        request.setAttribute("message", "Customer information not found!");
                        return LOGIN_PAGE;
                    }
                } else {
                    request.setAttribute("message", "Can not load account information!");
                    return LOGIN_PAGE;
                }
            } else {
                request.setAttribute("message", "Username or password is incorrect!");
                return LOGIN_PAGE;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return LOGIN_PAGE;
        }
    }

    private String handleRegister(HttpServletRequest request, HttpServletResponse response) {
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String customerName = request.getParameter("customerName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        Customer preserveCustomer = new Customer();
        preserveCustomer.setCustomerName(customerName);
        preserveCustomer.setEmail(email);
        preserveCustomer.setPhone(phone);
        preserveCustomer.setAddress(address);

        CustomerAccount preserveAccount = new CustomerAccount();
        preserveAccount.setUserName(userName);

        request.setAttribute("customer", preserveCustomer);
        request.setAttribute("account", preserveAccount);

        if (userName == null
                || password == null
                || confirmPassword == null
                || customerName == null
                || email == null
                || phone == null
                || address == null) {
            request.setAttribute("emptyError", "Please fill in all required information!");
            return REGISTER_PAGE;
        }
        if (password.length() < 6) {
            request.setAttribute("lengthError", "Password must be at least 6 characters!");
            return REGISTER_PAGE;
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("confirmError", "Password confirmation does not match!");
            return REGISTER_PAGE;
        }

        if (!AuthUtils.isValidEmail(email)) {
            request.setAttribute("emailError", "Incorrect email format! Please try again.");
            return REGISTER_PAGE;
        }
        if (!AuthUtils.isValidPhone(phone)) {
            request.setAttribute("phoneError", "Incorrect phone format! Please try again.");
            request.setAttribute("phoneMessage", "Phone number must start with 09|08|07|05|03 and follow by 8 number!");
            return REGISTER_PAGE;
        }

        try {
            CustomerDAO customerDAO = new CustomerDAO();
            CustomerAccountDAO accountDAO = new CustomerAccountDAO();

            if (accountDAO.isUserNameExists(userName)) {
                request.setAttribute("userNameError", "Username already exists! Please choose another one.");
                return REGISTER_PAGE;
            }
            if (customerDAO.isEmailExists(email)) {
                request.setAttribute("emailError", "Email already exists! Please use another email.");
                return REGISTER_PAGE;
            }

            Customer customer = new Customer();
            CustomerAccount account = new CustomerAccount();

            customer.setCustomerName(customerName);
            customer.setEmail(email);
            customer.setPhone(phone);
            customer.setAddress(address);

            boolean isCustomerCreated = customerDAO.create(customer);
            if (isCustomerCreated) {
                String customerId = customer.getCustomerId();

                account.setCustomerId(customerId);
                account.setUserName(userName);
                account.setPassword(password);
                account.setRole(2);

                boolean isAccountCreated = accountDAO.create(account);

                if (isAccountCreated) {
                    request.setAttribute("success", "Registration successful! Your Customer ID is: " + customerId);
                    return LOGIN_PAGE;
                } else {
                    request.setAttribute("error", "Failed to create account. Please try again later.");
                    return REGISTER_PAGE;
                }
            } else {
                request.setAttribute("error", "Failed to create customer. Please try again later.");
                return REGISTER_PAGE;

            }
        } catch (Exception e) {
            e.printStackTrace();
            return REGISTER_PAGE;
        }

    }

    private String handleLogout(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return WELCOME_PAGE;
    }

    private String handleUpdateProfile(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isLoggedin(request)) {
            request.setAttribute("error", "Please login first!");
            return LOGIN_PAGE;
        }
        CustomerAccount account = AuthUtils.getCurrentUser(request);
        if (account == null) {
            request.setAttribute("error", "Session expired. Please login again!");
            return LOGIN_PAGE;
        }
        try {
            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getById(account.getCustomerId());
            if (customer == null) {
                request.setAttribute("error", "Customer information not found!");
                return LOGIN_PAGE;
            }
            String customerName = request.getParameter("customerName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

        } catch (Exception e) {
        }
        return null;
    }

    private String handleViewProfile(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isLoggedin(request)) {
            request.setAttribute("error", "Please login first!");
            return LOGIN_PAGE;
        }
        CustomerAccount account = AuthUtils.getCurrentUser(request);
        try {
            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getById(account.getCustomerId());

            if (customer != null) {
                request.setAttribute("account", account);
                request.setAttribute("customer", customer);
                return PROFILE_PAGE;
            } else {
                request.setAttribute("error", "Customer information not found!");
                return LOGIN_PAGE;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return LOGIN_PAGE;
        }
    }
}
