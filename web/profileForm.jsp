<%-- 
    Document   : profileForm
    Created on : Jun 17, 2025
    Author     : Student
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Profile Management</title>
    </head>
    <body>
        <!-- Kiểm tra đăng nhập -->
        <c:if test="${empty sessionScope.account}">
            <c:redirect url="login.jsp"/>
        </c:if>

        <h1>My Profile</h1>

        <!-- Hiển thị thông báo lỗi hoặc thành công -->
        <c:if test="${not empty error}">
            <div style="color: red; margin: 10px 0;">
                <strong>Error:</strong> ${error}
            </div>
        </c:if>

        <form action="MainController" method="get">
            <!-- Hidden field để xác định action -->
            c

            <!-- Buttons -->
            <div style="margin: 20px 0;">
                <c:choose>
                    <c:when test="${isEdit}">
                        <input type="submit" value="Update Profile"/>
                        <input type="reset" value="Reset"/>
                        <input type="button" value="Cancel" onclick="history.back()"/>
                    </c:when>
                    <c:otherwise>
                        <input type="submit" value="Edit Profile"/>
                    </c:otherwise>
                </c:choose>
            </div>
        </form>

        <!-- Navigation -->
        <div style="margin: 20px 0;">
            <a href="MainController?action=editProfile">Edit Profile</a> |
            <a href="MainController?action=logout">Logout</a>
        </div>
    </body>
</html>