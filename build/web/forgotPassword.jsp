<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Forgot Password</title>
    </head>
    <body>
        <h2>Forgot Password</h2>

        <c:if test="${not empty message}">
            <div style="color: red; margin-bottom: 15px;">
                ${message}
            </div>
        </c:if>

        <form action="MainController" method="post">
            <input type="hidden" name="action" value="forgotPassword">

            <table>
                <tr>
                    <td><label for="email">Email:</label></td>
                    <td><input type="email" id="email" name="email" required></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="submit" value="Send Email Reset">
                        <input type="button" value="Back" onclick="window.location.href = 'MainController?action=showLogin'">
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>