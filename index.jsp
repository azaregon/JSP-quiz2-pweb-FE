<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Redirect based on authentication status
    String authToken = (String) session.getAttribute("auth_token");
    if (authToken != null && !authToken.isEmpty()) {
        response.sendRedirect("JSP/project/projects.jsp");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Akusigmak - Project Management</title>

    <link href="https://fonts.googleapis.com/css2?family=Zen+Kaku+Gothic+Antique&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/reseter.css">
    <style>
        body {
            font-family: "Zen Kaku Gothic Antique", sans-serif;
            margin: 0;
            padding: 0;
            background-image: url("./images/Desktop\ -\ 1.svg");
            background-size: cover;
            background-position: center;
            color: #fff;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .landing-container {
            text-align: center;
            background: rgba(10, 11, 1, 0.7);
            padding: 60px 40px;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            max-width: 600px;
            animation: slideIn 0.6s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .logo {
            font-size: 48px;
            margin-bottom: 20px;
            color: #d5ff01;
            font-weight: bold;
        }

        h1 {
            font-size: 2.5rem;
            margin: 20px 0 10px 0;
            color: #fff;
            font-weight: 700;
        }

        .subtitle {
            font-size: 1.1rem;
            color: #d0d0d0;
            margin-bottom: 40px;
            line-height: 1.6;
        }

        .cta-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 40px;
        }

        .btn {
            padding: 12px 32px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            font-family: "Zen Kaku Gothic Antique", sans-serif;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background-color: #4D5C00;
            color: #fff;
            border: 2px solid #d5ff01;
        }

        .btn-primary:hover {
            background-color: #a6c700;
            box-shadow: 0 0 20px rgba(87, 113, 1, 0.5);
            transform: translateY(-2px);
        }

        .btn-secondary {
            background-color: transparent;
            color: #fff;
            border: 2px solid #fff;
        }

        .btn-secondary:hover {
            background-color: rgba(255, 255, 255, 0.1);
            box-shadow: 0 0 20px rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }

        .features {
            margin-top: 50px;
            padding-top: 30px;
            border-top: 2px solid rgba(255, 255, 255, 0.2);
            text-align: left;
        }

        .features h3 {
            text-align: center;
            margin-bottom: 20px;
            color: #d5ff01;
        }

        .feature-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .feature-list li {
            padding: 8px 0;
            color: #d0d0d0;
        }

        .feature-list li::before {
            content: "✓ ";
            color: #d5ff01;
            font-weight: bold;
            margin-right: 10px;
        }

        .footer {
            margin-top: 40px;
            font-size: 0.85rem;
            color: #999;
        }

        @media (max-width: 600px) {
            .landing-container {
                padding: 40px 20px;
                margin: 20px;
            }

            h1 {
                font-size: 1.8rem;
            }

            .subtitle {
                font-size: 0.95rem;
            }

            .cta-buttons {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }
    </style>
    <script src="${pageContext.request.contextPath}/js/api.js"></script>
</head>
<body>
    <div class="landing-container">
        <div class="logo">📊</div>
        <h1>Akusigmak</h1>
        <p class="subtitle">
            A modern project management platform connecting seamlessly with your backend infrastructure
        </p>

        <div class="cta-buttons">
            <a href="JSP/auth/login.jsp" class="btn btn-primary">Login</a>
            <a href="JSP/auth/register.jsp" class="btn btn-secondary">Create Account</a>
        </div>

        <div class="features">
            <h3>Why Akusigmak?</h3>
            <ul class="feature-list">
                <li>Manage projects efficiently</li>
                <li>Collaborate with your team</li>
                <li>Track project progress</li>
                <li>Modern and intuitive UI</li>
                <li>Secure authentication</li>
            </ul>
        </div>

        <div class="footer">
            <p>Akusigmak © 2025 - Powered by JSP & Python Backend</p>
        </div>
    </div>

    <script>
        // Auto-redirect if user is already authenticated
        window.addEventListener('load', function() {
            if (TokenAPI.isAuthenticated()) {
                window.location.href = 'JSP/project/projects.jsp';
            }
        });
    </script>
</body>
</html>
