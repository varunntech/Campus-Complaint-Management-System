
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("userId") != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    String error = request.getParameter("error");
    String registered = request.getParameter("registered");
    String logout = request.getParameter("logout");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | CampusCare</title>
    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f6fb;
            color: #1f2937;
        }

        header {
            background: #173b70;
            color: white;
            padding: 20px 8%;
        }

        .container {
            max-width: 430px;
            margin: 55px auto;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }

        h1 { color: #173b70; text-align: center; }

        label {
            display: block;
            margin: 16px 0 7px;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 15px;
        }

        button {
            width: 100%;
            margin-top: 22px;
            padding: 13px;
            border: none;
            border-radius: 6px;
            background: #173b70;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }

        .message {
            padding: 11px;
            border-radius: 6px;
            margin: 12px 0;
            background: #fee2e2;
            color: #991b1b;
        }

        .success {
            background: #dcfce7;
            color: #166534;
        }

        .footer {
            text-align: center;
            margin-top: 20px;
        }

        a { color: #173b70; }
    </style>
</head>
<body>
    <header>
        <strong>Campus Complaint Management System</strong>
    </header>

    <main class="container">
        <h1>Login</h1>
        <p style="text-align:center;">Sign in to your CampusCare account.</p>

        <% if ("1".equals(registered)) { %>
            <div class="message success">
                Registration successful! Please log in.
            </div>
        <% } %>

        <% if ("1".equals(logout)) { %>
            <div class="message success">
                You have been logged out successfully.
            </div>
        <% } %>

        <% if ("empty".equals(error)) { %>
            <div class="message">Please enter your email and password.</div>
        <% } else if ("invalid".equals(error)) { %>
            <div class="message">Incorrect email or password.</div>
        <% } %>

        <form action="login" method="post">
            <label for="email">Email address</label>
            <input type="email" id="email" name="email"
                   maxlength="150" required autocomplete="email">

            <label for="password">Password</label>
            <input type="password" id="password" name="password"
                   required autocomplete="current-password">

            <button type="submit">Login</button>
        </form>

        <div class="footer">
            Don't have an account?
            <a href="register.jsp">Register here</a>
            <p><a href="index.html">Back to Home</a></p>
        </div>
    </main>
</body>
</html>
