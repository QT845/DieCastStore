<%-- 
    Document   : welcome
    Created on : May 27, 2025, 10:54:03 PM
    Author     : hqthi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "model.CustomerAccount"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            CustomerAccount cus = (CustomerAccount)request.getAttribute("customer");
            if (cus == null) {
            response.sendRedirect("login.jsp");
            return;
    }
        %>
        <h1>Hello <%=cus.getPassword()%></h1>
    </body>
</html>
