
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("userId") != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | CampusCare</title>

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
            max-width: 480px;
            margin: 40px auto;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }

        h1 {
            text-align: center;
            color: #173b70;
        }

        label {
            display: block;
            margin: 15px 0 7px;
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
            padding: 12px;
            margin: 14px 0;
            border-radius: 6px;
            background: #fee2e2;
            color: #991b1b;
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
        <h1>Create Account</h1>
        <p style="text-align:center;">
            Register as a campus student.
        </p>

        <% if ("empty".equals(error)) { %>
            <div class="message">Please fill in every field.</div>
        <% } else if ("length".equals(error)) { %>
            <div class="message">Your name or email is too long.</div>
        <% } else if ("email".equals(error)) { %>
            <div class="message">Please enter a valid email address.</div>
        <% } else if ("password".equals(error)) { %>
            <div class="message">Your password must contain at least 8 characters.</div>
        <% } else if ("mismatch".equals(error)) { %>
            <div class="message">The passwords do not match.</div>
        <% } else if ("exists".equals(error)) { %>
            <div class="message">An account with this email already exists.</div>
        <% } %>

        <form action="register" method="post">
            <label for="fullName">Full name</label>
            <input type="text" id="fullName" name="fullName"
                   maxlength="100" required autocomplete="name">

            <label for="email">Email address</label>
            <input type="email" id="email" name="email"
                   maxlength="150" required autocomplete="email">

            <label for="password">Password</label>
            <input type="password" id="password" name="password"
                   minlength="8" required autocomplete="new-password">

            <label for="confirmPassword">Confirm password</label>
            <input type="password" id="confirmPassword"
                   name="confirmPassword" minlength="8"
                   required autocomplete="new-password">

            <button type="submit">Register</button>
        </form>

        <div class="footer">
            Already have an account?
            <a href="login.jsp">Login here</a>
            <p><a href="index.html">Back to Home</a></p>
        </div>
    </main>
</body>
</html>

