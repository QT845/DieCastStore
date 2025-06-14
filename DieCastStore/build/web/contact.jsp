<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp" />
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Contact Us</title>
        <style>
            :root {
                --primary-color: #2E8B57; /* SeaGreen */
                --accent-color: #20c997;
                --background: #f9fdfb;
                --text-color: #333;
                --heading-color: #1d5c43;
                --input-border: #ccc;
                --input-focus: #20c997;
                --background-color: #f1f8e9;
            }

            body.contact-page {
                background-color: var(--background-color);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                color: var(--text-color);
            }

            .contact-container {
                max-width: 940px;
                margin: 60px auto;
                background: #fff;
                padding: 40px 30px;
                border-radius: 16px;
                box-shadow: 0 12px 30px rgba(0, 0, 0, 0.06);
                border-left: 8px solid var(--primary-color);
                transition: all 0.3s ease;
            }

            .contact-title {
                color: var(--primary-color);
                font-size: 30px;
                font-weight: 700;
                text-align: center;
                margin-bottom: 35px;
                letter-spacing: 0.5px;
            }

            .row {
                display: flex;
                flex-wrap: wrap;
                gap: 25px;
            }

            .col-half {
                flex: 1 1 48%;
            }

            .contact-info h5 {
                color: var(--heading-color);
                margin: 20px 0 8px;
                font-weight: 600;
            }

            .contact-info p {
                margin: 0 0 15px;
                color: var(--text-color);
                line-height: 1.5;
            }

            .form-label {
                display: block;
                margin-bottom: 6px;
                font-weight: 600;
                color: var(--primary-color);
                font-size: 15px;
            }

            .form-control {
                width: 100%;
                padding: 12px 14px;
                border: 1px solid var(--input-border);
                border-radius: 8px;
                font-size: 15px;
                margin-bottom: 20px;
                transition: border-color 0.3s, box-shadow 0.3s;
            }

            .form-control:focus {
                border-color: var(--input-focus);
                outline: none;
                box-shadow: 0 0 0 3px rgba(32, 201, 151, 0.2);
            }

            .btn-submit {
                background-color: var(--accent-color);
                color: white;
                padding: 12px 20px;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                cursor: pointer;
                width: 100%;
                font-weight: 600;
                transition: background-color 0.3s ease;
            }

            .btn-submit:hover {
                background-color: #17b198;
            }

            .map iframe {
                width: 100%;
                height: 300px;
                border-radius: 12px;
                border: 1px solid #ccc;
                margin-top: 10px;
            }

            @media (max-width: 768px) {
                .row {
                    flex-direction: column;
                }

                .col-half {
                    flex: 1 1 100%;
                }
            }
        </style>
    </head>
    <body class="contact-page">
        <div class="contact-container">
            <h2 class="contact-title">Contact Us</h2>

            <div class="row">
                <div class="col-half contact-info">
                    <h5>📍 Address</h5>
                    <p>7 D1 Street, Long Thanh My, Thu Duc, Ho Chi Minh City</p>

                    <h5>📞 Phone</h5>
                    <p>+84 123 456 789</p>

                    <h5>✉️ Email</h5>
                    <p>support@vnauto.com</p>

                    <div class="map">
                        <h5>📌 Store Location Map</h5>
                        <iframe 
                            src="https://www.google.com/maps?q=7+Đường+D1,+Long+Thạnh+Mỹ,+Thủ+Đức,+TP.HCM&output=embed" 
                            allowfullscreen="" loading="lazy">
                        </iframe>
                    </div>
                </div>

                <div class="col-half">
                    <form action="sendContact.jsp" method="post">
                        <label for="name" class="form-label">Full Name</label>
                        <input type="text" id="name" name="name" class="form-control" required>

                        <label for="email" class="form-label">Your Email</label>
                        <input type="email" id="email" name="email" class="form-control" required>

                        <label for="message" class="form-label">Message</label>
                        <textarea id="message" name="message" class="form-control" rows="5" required></textarea>

                        <button type="submit" class="btn-submit">Send Message</button>
                    </form>
                </div>
            </div>
        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>
