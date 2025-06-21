<%-- 
    Document   : register
    Created on : Jun 14, 2025, 2:51:31 PM
    Author     : hqthi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Register</title>
        
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        
        <style>
            /* Custom CSS cho Register Form */
            /* Color Variables */
            :root {
                --navy-blue: #2c3e50;
                --pastel-blue: #a8cfd1;
                --gray-teal: #5c7d7a;
                --sky-blue: #4a90e2;
                --white: #ffffff;
                --light-gray: #f8f9fa;
                --danger: #dc3545;
                --success: #28a745;
                --warning: #ffc107;
                --info: #17a2b8;
            }

            /* Body và Background */
            body {
                background: linear-gradient(135deg, var(--pastel-blue) 0%, var(--light-gray) 100%);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                min-height: 100vh;
                color: var(--navy-blue);
            }

            /* Container chính */
            .register-container {
                max-width: 600px;
                margin: 0 auto;
            }

            /* Card styling */
            .card {
                border: none;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(44, 62, 80, 0.1);
                background: var(--white);
                overflow: hidden;
            }

            .card-header {
                background: linear-gradient(135deg, var(--navy-blue) 0%, var(--gray-teal) 100%);
                border: none;
                padding: 2rem 1.5rem;
                text-align: center;
            }

            .card-title {
                color: var(--white);
                font-size: 1.8rem;
                font-weight: 700;
                margin: 0;
                letter-spacing: 1px;
                text-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .card-body {
                padding: 2.5rem !important;
                background: var(--white);
            }

            /* Form Labels */
            .form-label {
                color: var(--navy-blue);
                font-weight: 600;
                margin-bottom: 0.75rem;
                font-size: 0.95rem;
            }

            .required {
                color: var(--danger);
                font-weight: bold;
            }

            /* Form Controls */
            .form-control {
                border: 2px solid var(--pastel-blue);
                border-radius: 8px;
                padding: 0.75rem 1rem;
                font-size: 0.95rem;
                transition: all 0.3s ease;
                background: var(--white);
                color: var(--navy-blue);
            }

            .form-control:focus {
                border-color: var(--sky-blue);
                box-shadow: 0 0 0 0.2rem rgba(74, 144, 226, 0.25);
                background: var(--white);
                color: var(--navy-blue);
            }

            .form-control::placeholder {
                color: var(--gray-teal);
                opacity: 0.7;
            }

            /* Input Group */
            .input-group .form-control {
                border-right: none;
            }

            .input-group .form-control:focus {
                border-color: var(--sky-blue);
            }

            /* Password Toggle Button */
            .password-toggle {
                background: var(--pastel-blue);
                border: 2px solid var(--pastel-blue);
                border-left: none;
                color: var(--gray-teal);
                transition: all 0.3s ease;
                cursor: pointer;
            }

            .password-toggle:hover {
                background: var(--sky-blue);
                border-color: var(--sky-blue);
                color: var(--white);
            }

            .input-group:focus-within .password-toggle {
                border-color: var(--sky-blue);
            }

            /* Buttons */
            .btn-primary {
                background: linear-gradient(135deg, var(--sky-blue) 0%, var(--navy-blue) 100%);
                border: none;
                border-radius: 8px;
                padding: 0.75rem 1.5rem;
                font-weight: 600;
                font-size: 1rem;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, var(--navy-blue) 0%, var(--gray-teal) 100%);
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(44, 62, 80, 0.2);
            }

            .btn-primary:active {
                transform: translateY(0);
            }

            .btn-secondary {
                background: var(--gray-teal);
                border: 2px solid var(--gray-teal);
                border-radius: 8px;
                padding: 0.75rem 1.5rem;
                font-weight: 600;
                font-size: 1rem;
                color: var(--white);
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .btn-secondary:hover {
                background: var(--navy-blue);
                border-color: var(--navy-blue);
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(44, 62, 80, 0.2);
            }

            /* Alert Messages */
            .alert {
                border: none;
                border-radius: 8px;
                padding: 1rem 1.25rem;
                margin-bottom: 1.5rem;
                font-weight: 500;
            }

            .alert-danger {
                background: rgba(220, 53, 69, 0.1);
                color: #721c24;
                border-left: 4px solid var(--danger);
            }

            .alert-success {
                background: rgba(40, 167, 69, 0.1);
                color: #155724;
                border-left: 4px solid var(--success);
            }

            .alert-info {
                background: rgba(168, 207, 209, 0.2);
                color: var(--navy-blue);
                border-left: 4px solid var(--sky-blue);
            }

            /* Invalid Feedback */
            .invalid-feedback {
                display: block !important;
                color: var(--danger);
                font-size: 0.875rem;
                margin-top: 0.5rem;
                font-weight: 500;
            }

            /* Form Groups */
            .mb-3, .mb-4 {
                position: relative;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .card-body {
                    padding: 1.5rem !important;
                }
                
                .card-title {
                    font-size: 1.5rem;
                }
                
                .btn-primary, .btn-secondary {
                    padding: 0.6rem 1rem;
                    font-size: 0.9rem;
                }
            }

            @media (max-width: 576px) {
                .container-fluid {
                    padding: 1rem;
                }
                
                .card-header {
                    padding: 1.5rem 1rem;
                }
                
                .card-body {
                    padding: 1rem !important;
                }
                
                .row.g-3 > .col-md-8,
                .row.g-3 > .col-md-4 {
                    margin-bottom: 0.75rem;
                }
            }

            /* Animation cho form */
            .card {
                animation: slideInUp 0.6s ease-out;
            }

            @keyframes slideInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Hover effects cho form controls */
            .form-control:hover {
                border-color: var(--sky-blue);
                background: rgba(168, 207, 209, 0.05);
            }

            /* Focus animation */
            .form-control:focus + .form-label::after {
                content: '';
                position: absolute;
                bottom: -2px;
                left: 0;
                width: 100%;
                height: 2px;
                background: var(--sky-blue);
                animation: expandWidth 0.3s ease;
            }

            @keyframes expandWidth {
                from { width: 0; }
                to { width: 100%; }
            }
        </style>
    </head>
    <body>
        <div class="container-fluid py-5">
            <div class="row justify-content-center">
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <div class="register-container">
                        <div class="card shadow-lg">
                            <div class="card-header">
                                <h1 class="card-title">REGISTER ACCOUNT</h1>
                            </div>
                            <c:if test="${not empty sessionScope.account}">
                                <c:redirect url="home.jsp"/>
                            </c:if>
                            <div class="card-body p-4">
                                <form action="MainController" method="POST" novalidate>
                                    <input type="hidden" name="action" value="register" />

                                    <!-- General Messages - Priority: Empty error should show first -->
                                    <c:if test="${not empty emptyError}">
                                        <div class="alert alert-danger">
                                            ${emptyError}
                                        </div>
                                    </c:if>

                                    <c:if test="${empty emptyError and not empty error}">
                                        <div class="alert alert-danger">
                                            ${error}
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty success}">
                                        <div class="alert alert-success">
                                            ${success}
                                        </div>
                                    </c:if>

                                    <!-- Username Field -->
                                    <div class="mb-3">
                                        <label for="userName" class="form-label">
                                            Username <span class="required">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="userName" name="userName" 
                                               placeholder="Enter your username" required
                                               value="${param.userName}">
                                        <c:if test="${not empty userNameError and empty emptyError}">
                                            <div class="invalid-feedback">${userNameError}</div>
                                        </c:if>
                                    </div>

                                    <!-- Password Field -->
                                    <div class="mb-3">
                                        <label for="password" class="form-label">
                                            Password <span class="required">*</span>
                                        </label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="password" name="password" 
                                                   placeholder="Enter your password" required>
                                            <button class="btn password-toggle" type="button" onclick="togglePassword('password')">
                                                <i class="fas fa-eye" id="password-icon"></i>
                                            </button>
                                        </div>
                                        <!-- Only show password length error if there's no empty error -->
                                        <c:if test="${not empty lengthError and empty emptyError}">
                                            <div class="invalid-feedback">${lengthError}</div>
                                        </c:if>
                                    </div>

                                    <!-- Confirm Password Field -->
                                    <div class="mb-3">
                                        <label for="confirmPassword" class="form-label">
                                            Confirm Password <span class="required">*</span>
                                        </label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                                   placeholder="Confirm your password" required>
                                            <button class="btn password-toggle" type="button" onclick="togglePassword('confirmPassword')">
                                                <i class="fas fa-eye" id="confirmPassword-icon"></i>
                                            </button>
                                        </div>
                                        <c:if test="${not empty confirmError and empty emptyError}">
                                            <div class="invalid-feedback">${confirmError}</div>
                                        </c:if>
                                    </div>

                                    <!-- Full Name Field -->
                                    <div class="mb-3">
                                        <label for="customerName" class="form-label">
                                            Full Name <span class="required">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="customerName" name="customerName" 
                                               placeholder="Enter your full name" required
                                               value="${param.customerName}">
                                    </div>

                                    <!-- Email Field -->
                                    <div class="mb-3">
                                        <label for="email" class="form-label">
                                            Email <span class="required">*</span>
                                        </label>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               placeholder="Enter your email address" required
                                               value="${param.email}">
                                        <c:if test="${not empty emailError and empty emptyError}">
                                            <div class="invalid-feedback">${emailError}</div>
                                        </c:if>
                                    </div>

                                    <!-- Phone Field -->
                                    <div class="mb-3">
                                        <label for="phone" class="form-label">
                                            Phone <span class="required">*</span>
                                        </label>
                                        <input type="tel" class="form-control" id="phone" name="phone" 
                                               placeholder="Enter your phone number" required
                                               value="${param.phone}">
                                        <c:if test="${not empty phoneError and empty emptyError}">
                                            <div class="invalid-feedback">${phoneError}</div>
                                        </c:if>
                                        <c:if test="${not empty phoneMessage}">
                                            <div class="alert alert-info mt-2 py-2">
                                                ${phoneMessage}
                                            </div>
                                        </c:if>
                                    </div>

                                    <!-- Address Field -->
                                    <div class="mb-4">
                                        <label for="address" class="form-label">
                                            Address <span class="required">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="address" name="address" 
                                               placeholder="Enter your address" required
                                               value="${param.address}">
                                    </div>

                                    <!-- Submit Buttons -->
                                    <div class="row g-3">
                                        <div class="col-md-8">
                                            <button type="submit" class="btn btn-primary w-100">
                                                Register
                                            </button>
                                        </div>
                                        <div class="col-md-4">
                                            <button type="reset" class="btn btn-secondary w-100">
                                                Reset
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- Password Toggle Script -->
        <script>
            function togglePassword(fieldId) {
                const passwordField = document.getElementById(fieldId);
                const icon = document.getElementById(fieldId + '-icon');
                
                if (passwordField.type === 'password') {
                    passwordField.type = 'text';
                    icon.classList.remove('fa-eye');
                    icon.classList.add('fa-eye-slash');
                } else {
                    passwordField.type = 'password';
                    icon.classList.remove('fa-eye-slash');
                    icon.classList.add('fa-eye');
                }
            }
        </script>
    </body>
</html>