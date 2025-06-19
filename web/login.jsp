<%-- 
    Document   : login.jsp
    Created on : Jun 14, 2025, 2:51:18 PM
    Author     : hqthi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="utils.AuthUtils" %>
<%
    if (AuthUtils.isLoggedIn(request)) {
        response.sendRedirect("home.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Page</title>
    </head>
    <body>
        <h1>Sign in</h1>
        <h2>Welcome back! Please sign in to your account</h2>
        <%
        String msg = (String) request.getAttribute("message");
        %>
        <% if (msg != null && !msg.isEmpty()) { %>
        <%= msg %>
        <% } %>
        <form action="UserController" method="post">
            <div class="form-group">
                <label for="userName">User Name</label>
                <input type="text" id="userName" name="userName" placeholder="Enter User Name" required/>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <div style="position: relative;">
                    <input type="password" id="password" name="password" placeholder="Enter Password" required style="padding-right: 40px;"/>
                    <button type="button" onclick="togglePassword()" style="position:absolute; right:10px; top:50%; transform:translateY(-50%); border:none; background:none; cursor:pointer; color:#388e3c;">👁</button>
                </div>
            </div>
            <div class="remember-password">
                <input type="checkbox" id="remember" name="remember" value="On"/>
                <label for="remember">Remember password</label>
            </div>
            <div class="forgot-password">
                <a href="#">Forgot Password</a>
            </div>
            <div class="btn-login">
                <button type="submit" name="action" value="login">Sign In</button>
            </div>
        </form>

        <form action="UserController" method="get">
            <button type="submit" name="action" value="showRegister">Register</button>
        </form>
    </body>
</html>
