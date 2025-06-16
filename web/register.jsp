<%-- 
    Document   : register
    Created on : Jun 14, 2025, 2:51:31 PM
    Author     : hqthi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Customer"%>
<%@page import="model.CustomerAccount"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Register</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-blue: #2C5AA0;
            --secondary-blue: #4A90C2;
            --accent-orange: #F39C12;
            --dark-navy: #1A252F;
            --light-gray: #F8F9FA;
            --silver: #BDC3C7;
            --success-green: #27AE60;
            --error-red: #E74C3C;
            --info-blue: #3498DB;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #1A252F 0%, #2C5AA0 25%, #4A90C2 75%, #E8F4FD 100%);
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                radial-gradient(circle at 15% 25%, rgba(44, 90, 160, 0.4) 0%, transparent 40%),
                radial-gradient(circle at 85% 75%, rgba(243, 156, 18, 0.3) 0%, transparent 40%),
                radial-gradient(circle at 45% 10%, rgba(74, 144, 194, 0.2) 0%, transparent 50%),
                radial-gradient(circle at 70% 90%, rgba(189, 195, 199, 0.2) 0%, transparent 40%);
            pointer-events: none;
            animation: backgroundShift 20s ease-in-out infinite;
        }

        @keyframes backgroundShift {
            0%, 100% { 
                transform: scale(1) rotate(0deg);
                opacity: 0.8;
            }
            50% { 
                transform: scale(1.1) rotate(1deg);
                opacity: 1;
            }
        }

        .register-container {
            position: relative;
            z-index: 1;
            animation: slideInUp 0.8s ease-out;
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 2px solid rgba(74, 144, 194, 0.2);
            border-radius: 24px;
            box-shadow: 
                0 25px 50px rgba(26, 37, 47, 0.15),
                0 0 0 1px rgba(255, 255, 255, 0.3) inset,
                0 8px 32px rgba(44, 90, 160, 0.1);
            transition: all 0.4s ease;
        }

        .card:hover {
            transform: translateY(-8px);
            box-shadow: 
                0 35px 70px rgba(26, 37, 47, 0.2),
                0 0 0 1px rgba(255, 255, 255, 0.4) inset,
                0 12px 48px rgba(44, 90, 160, 0.15);
        }

        .card-header {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 50%, var(--accent-orange) 100%);
            color: white;
            border: none;
            border-radius: 22px 22px 0 0 !important;
            padding: 2.5rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .card-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.15), transparent);
            transform: rotate(45deg);
            animation: shine 4s ease-in-out infinite;
        }

        .card-header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--accent-orange), var(--primary-blue), var(--accent-orange));
            animation: borderFlow 3s ease-in-out infinite;
        }

        @keyframes shine {
            0%, 100% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            50% { transform: translateX(100%) translateY(100%) rotate(45deg); }
        }

        @keyframes borderFlow {
            0%, 100% { opacity: 0.6; }
            50% { opacity: 1; }
        }

        .card-title {
            font-size: 2rem;
            font-weight: 700;
            margin: 0;
            position: relative;
            z-index: 1;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .form-label {
            color: var(--dark-navy);
            font-weight: 600;
            font-size: 0.95rem;
            margin-bottom: 0.5rem;
        }

        .required {
            color: var(--error-red);
            margin-left: 2px;
        }

        .form-control, .form-select {
            border: 2px solid rgba(189, 195, 199, 0.3);
            border-radius: 12px;
            padding: 0.875rem 1rem;
            font-size: 1rem;
            background: rgba(248, 249, 250, 0.9);
            transition: all 0.3s ease;
            position: relative;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 0.2rem rgba(44, 90, 160, 0.25);
            background: rgba(248, 249, 250, 1);
            transform: translateY(-2px);
        }

        .input-group {
            position: relative;
        }

        .input-group .form-control {
            padding-right: 3rem;
        }

        .password-toggle {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--dark-navy);
            font-size: 1.1rem;
            cursor: pointer;
            z-index: 10;
            padding: 0.5rem;
            border-radius: 8px;
            transition: all 0.2s ease;
        }

        .password-toggle:hover {
            background: rgba(44, 90, 160, 0.1);
            transform: translateY(-50%) scale(1.1);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 50%, var(--accent-orange) 100%);
            border: none;
            border-radius: 12px;
            padding: 1rem 2rem;
            font-weight: 600;
            font-size: 1.1rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-primary::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .btn-primary:hover::before {
            left: 100%;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, var(--accent-orange) 0%, var(--secondary-blue) 50%, var(--primary-blue) 100%);
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(44, 90, 160, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, var(--silver), var(--light-gray));
            border: 2px solid rgba(189, 195, 199, 0.5);
            color: var(--dark-navy);
            border-radius: 12px;
            padding: 1rem 2rem;
            font-weight: 600;
            font-size: 1.1rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background: linear-gradient(135deg, var(--light-gray), var(--silver));
            border-color: var(--primary-blue);
            color: var(--dark-navy);
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(26, 37, 47, 0.15);
        }

        .alert {
            border: none;
            border-radius: 12px;
            padding: 1rem 1.25rem;
            margin-bottom: 1.5rem;
            font-weight: 500;
        }

        .alert-danger {
            background: rgba(220, 20, 60, 0.1);
            color: var(--error-red);
            border-left: 4px solid var(--error-red);
        }

        .alert-success {
            background: rgba(34, 139, 34, 0.1);
            color: var(--success-green);
            border-left: 4px solid var(--success-green);
        }

        .alert-info {
            background: rgba(65, 105, 225, 0.1);
            color: var(--info-blue);
            border-left: 4px solid var(--info-blue);
        }

        .invalid-feedback {
            display: block;
            background: rgba(220, 20, 60, 0.1);
            color: var(--error-red);
            padding: 0.5rem 0.75rem;
            border-radius: 8px;
            font-size: 0.875rem;
            margin-top: 0.5rem;
            border-left: 3px solid var(--error-red);
        }

        .mb-3 {
            margin-bottom: 1.5rem !important;
        }

        /* Form validation styles */
        .form-control.is-invalid {
            border-color: var(--error-red);
            box-shadow: 0 0 0 0.2rem rgba(220, 20, 60, 0.25);
        }

        .form-control.is-valid {
            border-color: var(--success-green);
            box-shadow: 0 0 0 0.2rem rgba(39, 174, 96, 0.25);
        }

        /* Responsive improvements */
        @media (max-width: 768px) {
            .card-header {
                padding: 1.5rem;
            }
            
            .card-title {
                font-size: 1.5rem;
            }
            
            .btn-primary, .btn-secondary {
                width: 100%;
                margin-bottom: 0.5rem;
            }
        }

        /* Animation for form groups */
        .mb-3 {
            animation: fadeInLeft 0.6s ease-out;
            animation-fill-mode: both;
        }

        .mb-3:nth-child(1) { animation-delay: 0.1s; }
        .mb-3:nth-child(2) { animation-delay: 0.2s; }
        .mb-3:nth-child(3) { animation-delay: 0.3s; }
        .mb-3:nth-child(4) { animation-delay: 0.4s; }
        .mb-3:nth-child(5) { animation-delay: 0.5s; }
        .mb-3:nth-child(6) { animation-delay: 0.6s; }
        .mb-3:nth-child(7) { animation-delay: 0.7s; }
        .mb-3:nth-child(8) { animation-delay: 0.8s; }

        @keyframes fadeInLeft {
            from {
                opacity: 0;
                transform: translateX(-30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
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
                        
                        <div class="card-body p-4">
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
                            Customer customer = (Customer)request.getAttribute("customer");
                            CustomerAccount account = (CustomerAccount)request.getAttribute("account");
                            %>

                            <form action="MainController" method="POST" novalidate>
                                <input type="hidden" name="action" value="register" />

                                <!-- General Messages - Priority: Empty error should show first -->
                                <% if (emptyError != null && !emptyError.isEmpty()) { %>
                                <div class="alert alert-danger">
                                    <%= emptyError %>
                                </div>
                                <% } else if (error != null && !error.isEmpty()) { %>
                                <div class="alert alert-danger">
                                    <%= error %>
                                </div>
                                <% } %>
                                
                                <% if (success != null && !success.isEmpty()) { %>
                                <div class="alert alert-success">
                                    <%= success %>
                                </div>
                                <% } %>

                                <!-- Username Field -->
                                <div class="mb-3">
                                    <label for="userName" class="form-label">
                                        Username <span class="required">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="userName" name="userName" 
                                           placeholder="Enter your username" required
                                           value="<%=account!=null && account.getUserName()!=null ? account.getUserName() : ""%>">
                                    <% if (userNameError != null && !userNameError.isEmpty() && (emptyError == null || emptyError.isEmpty())) { %>
                                    <div class="invalid-feedback"><%= userNameError %></div>
                                    <% } %>
                                </div>

                                <!-- Password Field -->
                                <div class="mb-3">
                                    <label for="password" class="form-label">
                                        Password <span class="required">*</span>
                                    </label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="password" name="password" 
                                               placeholder="Enter your password" required>
                                        <button type="button" class="password-toggle" onclick="togglePassword('password')">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" id="password-icon">
                                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                                <circle cx="12" cy="12" r="3"/>
                                            </svg>
                                        </button>
                                    </div>
                                    <!-- Only show password length error if there's no empty error -->
                                    <% if (lengthError != null && !lengthError.isEmpty() && (emptyError == null || emptyError.isEmpty())) { %>
                                    <div class="invalid-feedback"><%= lengthError %></div>
                                    <% } %>
                                </div>

                                <!-- Confirm Password Field -->
                                <div class="mb-3">
                                    <label for="confirmPassword" class="form-label">
                                        Confirm Password <span class="required">*</span>
                                    </label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                               placeholder="Confirm your password" required>
                                        <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" id="confirmPassword-icon">
                                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                                <circle cx="12" cy="12" r="3"/>
                                            </svg>
                                        </button>
                                    </div>
                                    <% if (confirmError != null && !confirmError.isEmpty() && (emptyError == null || emptyError.isEmpty())) { %>
                                    <div class="invalid-feedback"><%= confirmError %></div>
                                    <% } %>
                                </div>

                                <!-- Full Name Field -->
                                <div class="mb-3">
                                    <label for="customerName" class="form-label">
                                        Full Name <span class="required">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="customerName" name="customerName" 
                                           placeholder="Enter your full name" required
                                           value="<%=customer!=null && customer.getCustomerName()!=null ? customer.getCustomerName() : ""%>">
                                </div>

                                <!-- Email Field -->
                                <div class="mb-3">
                                    <label for="email" class="form-label">
                                        Email <span class="required">*</span>
                                    </label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           placeholder="Enter your email address" required
                                           value="<%=customer!=null && customer.getEmail()!=null ? customer.getEmail() : ""%>">
                                    <% if (emailError != null && !emailError.isEmpty() && (emptyError == null || emptyError.isEmpty())) { %>
                                    <div class="invalid-feedback"><%= emailError %></div>
                                    <% } %>
                                </div>

                                <!-- Phone Field -->
                                <div class="mb-3">
                                    <label for="phone" class="form-label">
                                        Phone <span class="required">*</span>
                                    </label>
                                    <input type="tel" class="form-control" id="phone" name="phone" 
                                           placeholder="Enter your phone number" required
                                           value="<%=customer!=null && customer.getPhone()!=null ? customer.getPhone() : ""%>">
                                    <% if (phoneError != null && !phoneError.isEmpty() && (emptyError == null || emptyError.isEmpty())) { %>
                                    <div class="invalid-feedback"><%= phoneError %></div>
                                    <% } %>
                                    <% if (phoneMessage != null && !phoneMessage.isEmpty()) { %>
                                    <div class="alert alert-info mt-2 py-2">
                                        <%= phoneMessage %>
                                    </div>
                                    <% } %>
                                </div>

                                <!-- Address Field -->
                                <div class="mb-4">
                                    <label for="address" class="form-label">
                                        Address <span class="required">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="address" name="address" 
                                           placeholder="Enter your address" required
                                           value="<%=customer!=null && customer.getAddress()!=null ? customer.getAddress() : ""%>">
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

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function togglePassword(fieldId) {
            const passwordField = document.getElementById(fieldId);
            const icon = document.getElementById(fieldId + '-icon');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                icon.innerHTML = `
                    <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>
                    <line x1="1" y1="1" x2="23" y2="23"/>
                `;
            } else {
                passwordField.type = 'password';
                icon.innerHTML = `
                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                    <circle cx="12" cy="12" r="3"/>
                `;
            }
        }

        // Simplified client-side validation
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form');
            const requiredFields = document.querySelectorAll('input[required]');
            
            // Form submission validation 
            form.addEventListener('submit', function(e) {
                let emptyFields = [];
                let hasValidationErrors = false;
                
                // Check for empty required fields
                requiredFields.forEach(field => {
                    if (field.value.trim() === '') {
                        field.classList.add('is-invalid');
                        field.classList.remove('is-valid');
                        emptyFields.push(field);
                    } else {
                        // Check for specific validation errors (but don't prevent submission)
                        if (field.name === 'password' && field.value.length < 6) {
                            hasValidationErrors = true;
                        } else if (field.name === 'confirmPassword') {
                            const password = document.getElementById('password').value;
                            if (field.value !== password) {
                                hasValidationErrors = true;
                            }
                        } else if (field.name === 'email') {
                            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                            if (!emailRegex.test(field.value)) {
                                hasValidationErrors = true;
                            }
                        }
                        
                        field.classList.remove('is-invalid');
                        field.classList.add('is-valid');
                    }
                });
                
                // Nếu có trường trống, ngăn submit và hiện thông báo tổng quát
                if (emptyFields.length > 0) {
                    e.preventDefault();
                    
                    // Remove existing general error
                    const existingAlert = document.querySelector('.alert-danger');
                    if (existingAlert && existingAlert.textContent.includes('Please fill in all required fields')) {
                        existingAlert.remove();
                    }
                    
                    // Add new general error
                    const alertDiv = document.createElement('div');
                    alertDiv.className = 'alert alert-danger';
                    alertDiv.textContent = 'Please fill in all required fields';
                    
                    const form = document.querySelector('form');
                    const firstChild = form.querySelector('input[type="hidden"]').nextElementSibling;
                    form.insertBefore(alertDiv, firstChild);
                    
                    // Focus on first empty field
                    emptyFields[0].focus();
                }
                
                // Nếu không có trường trống nhưng có lỗi validation khác, để server xử lý
            });
            
            // Real-time validation để bỏ màu đỏ khi user nhập
            requiredFields.forEach(field => {
                field.addEventListener('input', function() {
                    if (this.value.trim() !== '') {
                        this.classList.remove('is-invalid');
                        this.classList.add('is-valid');
                        
                        // Remove general empty error if it exists
                        const existingAlert = document.querySelector('.alert-danger');
                        if (existingAlert && existingAlert.textContent.includes('Please fill in all required fields')) {
                            // Check if all required fields are now filled
                            const stillEmpty = Array.from(requiredFields).some(f => f.value.trim() === '');
                            if (!stillEmpty) {
                                existingAlert.remove();
                            }
                        }
                    }
                });
                
                field.addEventListener('blur', function() {
                    if (this.value.trim() === '') {
                        this.classList.add('is-invalid');
                        this.classList.remove('is-valid');
                    }
                });
            });

            // Enhanced form interactions
            const formControls = document.querySelectorAll('.form-control');
            
            formControls.forEach(control => {
                // Add focus/blur animations
                control.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'translateX(5px)';
                    this.parentElement.style.transition = 'transform 0.2s ease';
                });
                
                control.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'translateX(0)';
                });
            });

            // Form submission with loading state
            const submitBtn = document.querySelector('button[type="submit"]');
            
            form.addEventListener('submit', function() {
                const emptyFields = Array.from(requiredFields).filter(field => field.value.trim() === '');
                if (emptyFields.length === 0) {
                    submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Creating Account...';
                    submitBtn.disabled = true;
                }
            });

            // Auto-hide success alerts after 5 seconds
            const alerts = document.querySelectorAll('.alert-success, .alert-info');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.transition = 'opacity 0.5s ease';
                    alert.style.opacity = '0';
                    setTimeout(() => alert.remove(), 500);
                }, 5000);
            });
        });
    </script>
</body>
</html>