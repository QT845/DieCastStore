<%-- 
    Document   : profile
    Created on : Jun 14, 2025, 2:51:04 PM
    Author     : hqthi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Customer"%>
<%@page import="model.CustomerAccount"%>
<%@page import="utils.AuthUtils" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Profile Page</title>
    </head>
    <body>
        <%
        if (!AuthUtils.isLoggedin(request)) {
            response.sendRedirect("login.jsp");  
            return;
        }
        %>
        <h1>Profile</h1>
        <%
            
        %>    
    </body>
</html>
