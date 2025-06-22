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
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Edit Profile</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
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
                padding: 2rem 0;
            }

            .edit-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 1rem;
            }

            .page-title {
                text-align: center;
                color: var(--navy-blue);
                font-weight: 700;
                font-size: 2.5rem;
                margin-bottom: 2rem;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
            }

            .edit-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                overflow: hidden;
                margin-bottom: 2rem;
                border: 1px solid var(--light-pastel-blue);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                height: fit-content;
            }

            .edit-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 15px 35px rgba(0,0,0,0.15);
            }

            .card-header {
                background: linear-gradient(135deg, var(--navy-blue) 0%, var(--gray-teal) 100%);
                color: white;
                padding: 1.5rem 2rem;
                border: none;
            }

            .card-header h3 {
                margin: 0;
                font-weight: 600;
                font-size: 1.4rem;
            }

            .card-body {
                padding: 2rem;
            }

            .password-card .card-body {
                padding: 1.5rem 2rem;
            }

            .form-group {
                margin-bottom: 1.5rem;
            }

            .password-card .form-group {
                margin-bottom: 1rem;
            }

            .form-label {
                color: var(--navy-blue);
                font-weight: 600;
                margin-bottom: 0.5rem;
                font-size: 0.95rem;
            }

            .required {
                color: #dc3545;
                font-weight: bold;
            }

            .form-control, .form-control:read-only {
                border: 2px solid var(--light-pastel-blue);
                border-radius: 10px;
                padding: 12px 15px;
                font-size: 1rem;
                transition: all 0.3s ease;
                background-color: #fafafa;
            }

            .form-control:read-only {
                background-color: #f8f9fa;
                color: var(--gray-teal);
                cursor: not-allowed;
            }

            .form-control:focus {
                border-color: var(--deep-sky-blue);
                box-shadow: 0 0 0 0.2rem rgba(74, 144, 226, 0.25);
                background-color: white;
            }

            .form-control::placeholder {
                color: #999;
                font-style: italic;
            }

            textarea.form-control {
                resize: vertical;
                min-height: 100px;
            }

            .password-input-group {
                position: relative;
            }

            .password-toggle {
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                border: none;
                background: none;
                color: var(--gray-teal);
                cursor: pointer;
                z-index: 10;
                padding: 0;
                font-size: 1.1rem;
                transition: color 0.3s ease;
            }

            .password-toggle:hover {
                color: var(--deep-sky-blue);
            }

            .password-input-group input {
                padding-right: 45px;
            }

            .alert {
                border-radius: 10px;
                margin-bottom: 1.5rem;
                font-weight: 500;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }

            .alert-success {
                background: linear-gradient(135deg, #e8f5e8 0%, #c8e6c9 100%);
                border: 1px solid #4caf50;
                color: #2e7d32;
            }

            .alert-danger {
                background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
                border: 1px solid #f44336;
                color: #c62828;
            }

            .alert-info {
                background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
                border: 1px solid #2196f3;
                color: #1565c0;
            }

            .error-message {
                color: #dc3545;
                font-size: 0.875rem;
                margin-top: 0.25rem;
                font-weight: 500;
            }

            .btn-primary {
                background: linear-gradient(135deg, var(--deep-sky-blue) 0%, #357abd 100%);
                border: none;
                color: white;
                padding: 12px 25px;
                border-radius: 25px;
                font-weight: 600;
                font-size: 1rem;
                transition: all 0.3s ease;
                box-shadow: 0 6px 20px rgba(74, 144, 226, 0.3);
                min-width: 150px;
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, #357abd 0%, var(--deep-sky-blue) 100%);
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(74, 144, 226, 0.4);
                color: white;
            }

            .btn-secondary {
                background: linear-gradient(135deg, var(--gray-teal) 0%, #4a6b68 100%);
                border: none;
                color: white;
                padding: 12px 25px;
                border-radius: 25px;
                font-weight: 600;
                font-size: 1rem;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(92, 125, 122, 0.3);
                min-width: 150px;
            }

            .btn-secondary:hover {
                background: linear-gradient(135deg, #4a6b68 0%, var(--gray-teal) 100%);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(92, 125, 122, 0.4);
                color: white;
            }

            .btn:active {
                transform: translateY(0) !important;
            }

            .btn-return {
                background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
                border: none;
                color: white;
                padding: 12px 30px;
                border-radius: 25px;
                font-weight: 500;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
                text-decoration: none;
                display: inline-block;
                font-size: 1rem;
            }

            .btn-return:hover {
                background: linear-gradient(135deg, #495057 0%, #6c757d 100%);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(108, 117, 125, 0.4);
                color: white;
                text-decoration: none;
            }

            .return-section {
                text-align: center;
                margin-top: 2rem;
            }

            /* Layout adjustments for side-by-side cards */
            .cards-row {
                display: flex;
                gap: 2rem;
                align-items: flex-start;
            }

            .profile-card {
                flex: 2;
            }

            .password-card {
                flex: 1;
                min-width: 350px;
            }

            @media (max-width: 992px) {
                .cards-row {
                    flex-direction: column;
                    gap: 1.5rem;
                }
                
                .profile-card,
                .password-card {
                    flex: 1;
                }
            }

            @media (max-width: 768px) {
                body {
                    padding: 1rem 0;
                }
                
                .edit-container {
                    padding: 0 0.5rem;
                }
                
                .page-title {
                    font-size: 2rem;
                    margin-bottom: 1.5rem;
                }
                
                .card-body {
                    padding: 1.5rem;
                }
                
                .password-card .card-body {
                    padding: 1.5rem;
                }
                
                .btn-primary,
                .btn-secondary {
                    width: 100%;
                    margin-bottom: 1rem;
                }

                .password-card {
                    min-width: unset;
                }
            }
        </style>
    </head>
    <body>
        <c:if test="${empty sessionScope.account}">
            <c:redirect url="login.jsp"/>
        </c:if>

        <div class="edit-container">
            <h1 class="page-title">Edit Profile</h1>

            <div class="cards-row">
                <!-- Profile Information Section -->
                <div class="edit-card profile-card">
                    <div class="card-header">
                        <h3>Profile Information</h3>
                    </div>
                    <div class="card-body">
                        <!-- Success and Error Messages -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success">
                                ${success}
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">
                                <strong>Error:</strong> ${error}
                            </div>
                        </c:if>
                        <c:if test="${not empty updateError}">
                            <div class="alert alert-danger">
                                <strong>Update Error:</strong> ${updateError}
                            </div>
                        </c:if>

                        <form action="MainController" method="POST">
                            <input type="hidden" name="action" value="updateProfile">

                            <div class="row">
                                <div class="col-md-6">
                                    <!-- Username (Read Only) -->
                                    <div class="form-group">
                                        <label for="userName" class="form-label">Username <span class="required">*</span></label>
                                        <input type="text" class="form-control" id="userName" name="userName" 
                                               value="${account.userName}" readonly/>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <!-- Customer ID (Read Only) -->
                                    <div class="form-group">
                                        <label for="customerId" class="form-label">Customer ID <span class="required">*</span></label>
                                        <input type="text" class="form-control" id="customerId" name="customerId" 
                                               value="${account.customerId}" readonly/>
                                    </div>
                                </div>
                            </div>

                            <!-- Full Name -->
                            <div class="form-group">
                                <label for="customerName" class="form-label">Full Name <span class="required">*</span></label>
                                <input type="text" class="form-control" id="customerName" name="customerName" 
                                       value="${not empty param.customerName ? param.customerName : customer.customerName}" required/>
                                <c:if test="${not empty nameError}">
                                    <div class="error-message">${nameError}</div>
                                </c:if>
                            </div>

                            <!-- Email -->
                            <div class="form-group">
                                <label for="email" class="form-label">Email <span class="required">*</span></label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       value="${not empty param.email ? param.email : customer.email}" required/>
                                <c:if test="${not empty emailError}">
                                    <div class="error-message">${emailError}</div>
                                </c:if>
                            </div>

                            <!-- Phone -->
                            <div class="form-group">
                                <label for="phone" class="form-label">Phone <span class="required">*</span></label>
                                <input type="tel" class="form-control" id="phone" name="phone" 
                                       value="${not empty param.phone ? param.phone : customer.phone}" required/>
                                <c:if test="${not empty phoneError}">
                                    <div class="error-message">${phoneError}</div>
                                </c:if>
                                <c:if test="${not empty phoneMessage}">
                                    <div class="alert alert-info mt-2">
                                        ${phoneMessage}
                                    </div>
                                </c:if>
                            </div>

                            <!-- Address -->
                            <div class="form-group">
                                <label for="address" class="form-label">Address <span class="required">*</span></label>
                                <textarea class="form-control" id="address" name="address" rows="3" required>${not empty param.address ? param.address : customer.address}</textarea>
                                <c:if test="${not empty addressError}">
                                    <div class="error-message">${addressError}</div>
                                </c:if>
                            </div>

                            <!-- Action Button -->
                            <div class="text-center">
                                <button type="submit" class="btn btn-primary">Update Profile</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Password Change Section -->
                <div class="edit-card password-card">
                    <div class="card-header">
                        <h3>Change Password</h3>
                    </div>
                    <div class="card-body">
                        <!-- Password Change Messages -->
                        <c:if test="${not empty successChanging}">
                            <div class="alert alert-success">
                                ${successChanging}
                            </div>
                        </c:if>
                        <c:if test="${not empty changeError}">
                            <div class="alert alert-danger">
                                <strong>Password Change Error:</strong> ${changeError}
                            </div>
                        </c:if>
                        <c:if test="${not empty passwordMessage}">
                            <div class="alert alert-info">
                                ${passwordMessage}
                            </div>
                        </c:if>

                        <form action="MainController" method="POST">
                            <input type="hidden" name="action" value="changePassword">

                            <div class="form-group">
                                <label for="oldPassword" class="form-label">Current Password</label>
                                <div class="password-input-group">
                                    <input type="password" class="form-control" id="oldPassword" name="oldPassword"/>
                                    <button type="button" class="password-toggle" onclick="togglePassword('oldPassword')">
                                        <i class="bi bi-eye-slash" id="oldPasswordIcon"></i>
                                    </button>
                                </div>
                                <c:if test="${not empty oldPasswordError}">
                                    <div class="error-message">${oldPasswordError}</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label for="newPassword" class="form-label">New Password</label>
                                <div class="password-input-group">
                                    <input type="password" class="form-control" id="newPassword" name="newPassword"/>
                                    <button type="button" class="password-toggle" onclick="togglePassword('newPassword')">
                                        <i class="bi bi-eye-slash" id="newPasswordIcon"></i>
                                    </button>
                                </div>
                                <c:if test="${not empty passwordError}">
                                    <div class="error-message">${passwordError}</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                <div class="password-input-group">
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"/>
                                    <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                        <i class="bi bi-eye-slash" id="confirmPasswordIcon"></i>
                                    </button>
                                </div>
                                <c:if test="${not empty confirmError}">
                                    <div class="error-message">${confirmError}</div>
                                </c:if>
                            </div>

                            <!-- Action Button -->
                            <div class="text-center">
                                <button type="submit" class="btn btn-secondary">Change Password</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Return Button -->
            <div class="return-section">
                <a href="MainController?action=viewProfile" class="btn-return">Return to Profile</a>
            </div>
        </div>
        
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- Password Toggle Script -->
        <script>
            function togglePassword(fieldId) {
                const passwordField = document.getElementById(fieldId);
                const icon = document.getElementById(fieldId + 'Icon');
                
                if (passwordField.type === 'password') {
                    passwordField.type = 'text';
                    icon.className = 'bi bi-eye';
                } else {
                    passwordField.type = 'password';
                    icon.className = 'bi bi-eye-slash';
                }
            }
        </script>
    </body>
</html>