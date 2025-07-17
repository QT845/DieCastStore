<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Reset Password</title>
    </head>
    <body>
        <h2>Reset Password</h2>

        <c:if test="${not empty message}">
            <div style="color: red; margin-bottom: 15px;">
                ${message}
            </div>
        </c:if>

        <form action="MainController" method="post">
            <input type="hidden" name="action" value="resetPassword">
            <input type="hidden" name="token" value="${param.token}">

            <table>
                <tr>
                    <td><label for="newPassword">New Password:</label></td>
                    <td><input type="password" id="newPassword" name="newPassword" required></td>
                </tr>
                <tr>
                    <td><label for="confirmPassword">Confirm Password:</label></td>
                    <td><input type="password" id="confirmPassword" name="confirmPassword" required></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="submit" value="Reset Password">
                    </td>
                </tr>
            </table>
        </form>

        <br>
        <a href="MainController?action=showLogin">Back to Login</a>

        <script>
            document.querySelector('form').addEventListener('submit', function (e) {
                var newPassword = document.getElementById('newPassword').value;
                var confirmPassword = document.getElementById('confirmPassword').value;

                if (newPassword !== confirmPassword) {
                    e.preventDefault();
                    alert('Confirmation password does not match!');
                }
            });
        </script>
    </body>
</html>