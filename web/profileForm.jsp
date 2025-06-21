<%-- 
    Document   : profile
    Created on : Jun 17, 2025
    Author     : Student
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>My Profile</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <style>
            :root {
                --navy-blue: #2c3e50;
                --light-pastel-blue: #a8cfd1;
                --gray-teal: #5c7d7a;
                --deep-sky-blue: #4a90e2;
            }

            body {
                background: linear-gradient(135deg, var(--light-pastel-blue) 0%, #e8f4f8 100%);
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .profile-container {
                max-width: 1000px;
                margin: 0 auto;
                padding: 2rem;
            }

            .profile-header {
                text-align: center;
                margin-bottom: 2rem;
            }

            .profile-title {
                color: var(--navy-blue);
                font-weight: 700;
                font-size: 2.5rem;
                margin-bottom: 1rem;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
            }

            .profile-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                overflow: hidden;
                margin-bottom: 2rem;
                border: 1px solid var(--light-pastel-blue);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .profile-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 40px rgba(0,0,0,0.15);
            }

            .card-header {
                background: linear-gradient(135deg, var(--navy-blue) 0%, var(--gray-teal) 100%);
                color: white;
                padding: 1.5rem;
                border: none;
            }

            .card-header h3 {
                margin: 0;
                font-weight: 600;
                font-size: 1.4rem;
            }

            .info-table {
                margin: 0;
                background: white;
            }

            .info-table th {
                background: var(--light-pastel-blue);
                color: var(--navy-blue);
                font-weight: 600;
                padding: 1rem;
                border: 1px solid #dee2e6;
                width: 30%;
            }

            .info-table td {
                padding: 1rem;
                border: 1px solid #dee2e6;
                color: #555;
            }

            .info-table tr:hover {
                background-color: #f8f9fa;
            }

            .error-alert {
                background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
                border: 1px solid #f44336;
                color: #c62828;
                padding: 1rem;
                border-radius: 10px;
                margin-bottom: 1.5rem;
                box-shadow: 0 4px 15px rgba(244, 67, 54, 0.1);
            }

            .navigation-section {
                background: white;
                padding: 2rem;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                text-align: center;
            }

            .nav-btn {
                background: linear-gradient(135deg, var(--deep-sky-blue) 0%, #357abd 100%);
                color: white;
                border: none;
                padding: 12px 25px;
                border-radius: 25px;
                font-weight: 600;
                margin: 0.5rem;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(74, 144, 226, 0.3);
                min-width: 150px;
            }

            .nav-btn:hover {
                background: linear-gradient(135deg, #357abd 0%, var(--deep-sky-blue) 100%);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(74, 144, 226, 0.4);
                color: white;
            }

            .nav-btn:active {
                transform: translateY(0);
            }

            .btn-home {
                background: linear-gradient(135deg, var(--gray-teal) 0%, #4a6b68 100%);
                box-shadow: 0 4px 15px rgba(92, 125, 122, 0.3);
            }

            .btn-home:hover {
                background: linear-gradient(135deg, #4a6b68 0%, var(--gray-teal) 100%);
                box-shadow: 0 6px 20px rgba(92, 125, 122, 0.4);
                color: white;
            }

            @media (max-width: 768px) {
                .profile-container {
                    padding: 1rem;
                }
                
                .profile-title {
                    font-size: 2rem;
                }
                
                .info-table th,
                .info-table td {
                    padding: 0.75rem;
                    font-size: 0.9rem;
                }
                
                .nav-btn {
                    width: 100%;
                    margin: 0.5rem 0;
                }
            }
        </style>
    </head>
    <body>
        <!-- Kiểm tra đăng nhập -->
        <c:if test="${empty sessionScope.account}">
            <c:redirect url="login.jsp"/>
        </c:if>
        
        <div class="profile-container">
            <div class="profile-header">
                <h1 class="profile-title">My Profile</h1>
            </div>
            
            <!-- Hiển thị thông báo lỗi -->
            <c:if test="${not empty error}">
                <div class="error-alert">
                    <strong>Error:</strong> ${error}
                </div>
            </c:if>
            
            <!-- Profile Information -->
            <c:if test="${not empty account and not empty customer}">
                <div class="profile-card">
                    <div class="card-header">
                        <h3>Account Information</h3>
                    </div>
                    <table class="table info-table mb-0">
                        <tr>
                            <th>Username:</th>
                            <td>${account.userName}</td>
                        </tr>
                        <tr>
                            <th>Customer ID:</th>
                            <td>${account.customerId}</td>
                        </tr>
                    </table>
                </div>
                
                <div class="profile-card">
                    <div class="card-header">
                        <h3>Personal Information</h3>
                    </div>
                    <table class="table info-table mb-0">
                        <tr>
                            <th>Customer ID:</th>
                            <td>${customer.customerId}</td>
                        </tr>
                        <tr>
                            <th>Customer Name:</th>
                            <td>${customer.customerName}</td>
                        </tr>
                        <tr>
                            <th>Email:</th>
                            <td>${customer.email}</td>
                        </tr>
                        <tr>
                            <th>Phone:</th>
                            <td>${customer.phone}</td>
                        </tr>
                        <tr>
                            <th>Address:</th>
                            <td>${customer.address}</td>
                        </tr>
                    </table>
                </div>
            </c:if>
            
            <!-- Navigation -->
            <div class="navigation-section">
                <form action="MainController" method="get" style="display: inline-block;">
                    <input type="hidden" name="action" value="editProfile">
                    <input type="submit" value="Edit Profile" class="nav-btn">
                </form>
                <form action="MainController" method="get" style="display: inline-block;">
                    <input type="hidden" name="action" value="changePassword">
                    <input type="submit" value="Change Password" class="nav-btn">
                </form>
                <form action="MainController" method="get" style="display: inline-block;">
                    <input type="submit" value="Return to Home" class="nav-btn btn-home">
                </form>
            </div>
        </div>
        
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>