<%-- 
    Document   : editProfile
    Created on : Jun 18, 2025, 9:00:40 PM
    Author     : hqthi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Profile</title>
    </head>
    <body>
        <c:if test="${empty sessionScope.account}">
            <c:redirect url="login.jsp"/>
        </c:if>

        <h1>Edit Profile</h1>



        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="updateProfile">

            <fieldset style="margin: 20px 0; padding: 15px;">
                <legend><strong>Profile Information</strong></legend>
                <c:if test="${not empty success}">
                    <div style="color: green">
                        <strong>${success}</strong> 
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div style="color: red">
                        <strong>Error:</strong> ${error}
                    </div>
                </c:if>
                <c:if test="${not empty updateError}">
                    <div style="color: red">
                        <strong>Update Error:</strong> ${updateError}
                    </div>
                </c:if>
                <c:if test="${not empty changeError}">
                    <div style="color: red">
                        <strong>Password Change Error:</strong> ${changeError}
                    </div>
                </c:if>

                <!-- Username (Read Only) -->
                <div style="margin: 10px 0;">
                    <label for="userName">Username <span style="color: red;">*</span></label><br>
                    <input type="text" id="userName" name="userName" 
                           value="${account.userName}" readonly 
                           style="width: 200px; padding: 5px;"/>
                </div>

                <!-- Customer ID (Read Only) -->
                <div style="margin: 10px 0;">
                    <label for="customerId">Customer ID <span style="color: red;">*</span></label><br>
                    <input type="text" id="customerId" name="customerId" 
                           value="${account.customerId}" readonly 
                           style="width: 200px; padding: 5px;"/>
                </div>

                <!-- Full Name -->
                <div style="margin: 10px 0;">
                    <label for="customerName">Full Name <span style="color: red;">*</span></label><br>
                    <input type="text" id="customerName" name="customerName" 
                           value="${not empty param.customerName ? param.customerName : customer.customerName}" required/>
                    <c:if test="${not empty nameError}">
                        <div style="color: red; font-size: 12px;">${nameError}</div>
                    </c:if>
                </div>

                <!-- Email -->
                <div style="margin: 10px 0;">
                    <label for="email">Email <span style="color: red;">*</span></label><br>
                    <input type="email" id="email" name="email" 
                           value="${not empty param.email ? param.email : customer.email}" required/>
                    <c:if test="${not empty emailError}">
                        <div style="color: red; font-size: 12px;">${emailError}</div>
                    </c:if>
                </div>

                <!-- Phone -->
                <div style="margin: 10px 0;">
                    <label for="phone">Phone <span style="color: red;">*</span></label><br>
                    <input type="tel" id="phone" name="phone" 
                           value="${not empty param.phone ? param.phone : customer.phone}" required/>
                    <c:if test="${not empty phoneError}">
                        <div style="color: red; font-size: 12px;">${phoneError}</div>
                    </c:if>
                    <c:if test="${not empty phoneMessage}">
                        <div style="color: blue; font-size: 12px;">${phoneMessage}</div>
                    </c:if>
                </div>

                <!-- Address -->
                <div style="margin: 10px 0;">
                    <label for="address">Address <span style="color: red;">*</span></label><br>
                    <textarea id="address" name="address" rows="3" required 
                              style="width: 400px; padding: 5px;">${not empty param.address ? param.address : customer.address}</textarea>
                    <c:if test="${not empty addressError}">
                        <div style="color: red; font-size: 12px; margin-top: 5px;">${addressError}</div>
                    </c:if>
                </div>
                <!-- Action Buttons for Update Profile -->
                <input type="submit" value="Update Profile">
            </fieldset>

        </form>


        <!-- Password change section -->
        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="changePassword">

            <fieldset style="margin: 20px 0; padding: 15px;">
                <legend><strong>Change Password</strong></legend>
                <c:if test="${not empty successChanging}">
                    <div style="color: green">
                        <strong>${successChanging}</strong> 
                    </div>
                </c:if>
                <c:if test="${not empty passwordMessage}">
                    <div style="color: blue">
                        <strong>${passwordMessage}</strong> 
                    </div>
                </c:if>

                <div style="margin: 10px 0;">
                    <label for="oldPassword">Current Password</label><br>
                    <input type="password" id="oldPassword" name="oldPassword" style="width: 200px; padding: 5px;"/>
                    <c:if test="${not empty oldPasswordError}">
                        <div style="color: red; font-size: 12px;">${oldPasswordError}</div>
                    </c:if>
                </div>

                <div style="margin: 10px 0;">
                    <label for="newPassword">New Password</label><br>
                    <input type="password" id="newPassword" name="newPassword" style="width: 200px; padding: 5px;"/>
                    <c:if test="${not empty passwordError}">
                        <div style="color: red; font-size: 12px;">${passwordError}</div>
                    </c:if>
                </div>

                <div style="margin: 10px 0;">
                    <label for="confirmPassword">Confirm New Password</label><br>
                    <input type="password" id="confirmPassword" name="confirmPassword" style="width: 200px; padding: 5px;"/>
                    <c:if test="${not empty confirmError}">
                        <div style="color: red; font-size: 12px;">${confirmError}</div>
                    </c:if>
                </div>
                <input type="submit" value="Change Password">
            </fieldset>
        </form>
        <input type="button" value="Return to Profile" onclick="window.location.href = 'MainController?action=viewProfile'">
    </body>
</html>
