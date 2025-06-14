<%-- 
    Document   : register
    Created on : Jun 14, 2025, 2:51:31 PM
    Author     : hqthi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register</title>
    </head>
    <body>
        <%
        String emptyError = (String)request.getAttribute("emptyError");
        String lengthError = (String)request.getAttribute("lengthError");
        String confirmError = (String)request.getAttribute("confirmError");
        String userNameError = (String)request.getAttribute("userNameError");
        String emailError = (String)request.getAttribute("emailError");
        String phoneError = (String)request.getAttribute("phoneError");
        String phoneMessage = (String)request.getAttribute("phoneMessage");
        String success = (String)request.getAttribute("success");
        String error = (String)request.getAttribute("error");
        Customer customer  = (Customer)request.getAttribute("customer");
        %>
        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="register" />


            <div> 
                <label for="userName"/> User Name *</label> 
                <input type="text" id="userName" name="userName" required="required"
                       value="<%=product!=null?product.getId():""%>"
                       />
            </div>

            <div> 
                <label for="password"/> Password* </label> 
                <input type="password" id="password" name="password" required="required"
                       value="<%=product!=null?product.getName():""%>"/>
            </div>

            <div> 
                <label for="confirmPassword"/> Confirm Password </label> 
                <input type="password" id="confirmPassword" name="confirmPassword" required="required"
                       value="<%=product!=null?product.getImage():""%>"/>
            </div>

            <div> 
                <label for="customerName"/> Full Name* </label> 
                <input type="text" id="customerName" name="customerName"> required="required"
                <%=product!=null?product.getDescription():""%>
                </textarea>
            </div>

            <div> 
                <label for="email"/> Email* </label> 
                <input type="text" id="email" name="email" required="required"
                       value="<%=product!=null?product.getPrice():""%>"/>
            </div>

            <div> 
                <label for="phone"/> Phone* </label> 
                <input type="text" id="phone" name="phone" required="required"
                       value="<%=product!=null?product.getSize():""%>"/>
            </div>

            <div> 
                <label for="address"/> Address </label> 
                <input type="text" id="address" name="address" required="required"
                       <%=product!=null&&product.isStatus()?" checked='checked' ":""%>
                       />
            </div>

            <div> 
                <input type="submit" value="Register"/>
                <input type="reset" value="Reset"/>    
            </div>
        </form>
    </body>
</html>
