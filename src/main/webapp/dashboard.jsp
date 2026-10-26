
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String fullName = (String) session.getAttribute("fullName");
    String role = (String) session.getAttribute("role");

    String safeName = org.apache.commons.text.StringEscapeUtils.escapeHtml4(
        fullName == null ? "User" : fullName
    );

    String safeRole = org.apache.commons.text.StringEscapeUtils.escapeHtml4(
        role == null ? "STUDENT" : role
    );
    if ("ADMIN".equals(role)) {
    response.sendRedirect("admin-dashboard.jsp");
    return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | CampusCare</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f6fb;
            color: #1f2937;
        }

        header {
            background: #173b70;
            color: white;
            padding: 20px 7%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
        }

        header a {
            color: white;
            text-decoration: none;
            background: #31578d;
            padding: 10px 16px;
            border-radius: 6px;
        }

        header a:hover {
            background: #426ba3;
        }

        main {
            max-width: 1000px;
            margin: 45px auto;
            padding: 20px;
        }

        .welcome, .card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
        }

        .welcome {
            margin-bottom: 25px;
        }

        h1, h2 {
            color: #173b70;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
            gap: 20px;
        }

        .card p {
            color: #64748b;
            line-height: 1.6;
        }

        .btn {
            display: inline-block;
            margin-top: 10px;
            padding: 12px 20px;
            background: #173b70;
            color: white;
            text-decoration: none;
            border-radius: 6px;
        }

        .btn:hover {
            background: #31578d;
        }

        .note {
            margin-top: 25px;
            color: #64748b;
            font-size: 14px;
        }

        @media (max-width: 600px) {
            main {
                margin: 20px auto;
            }

            header {
                padding: 18px 5%;
            }
        }
    </style>
</head>

<body>
    <header>
        <strong>CampusCare Dashboard</strong>
        <a href="logout">Logout</a>
    </header>

    <main>
        <section class="welcome">
            <h1>Welcome, <%= safeName %>!</h1>
            <p>You are logged in successfully.</p>
            <p>
                Account type:
                <strong><%= safeRole %></strong>
            </p>
        </section>

        <section class="cards">
            <div class="card">
                <h2>Submit a Complaint</h2>
                <p>
                    Report a campus issue related to academics,
                    hostel facilities, cleanliness, infrastructure,
                    or other campus services.
                </p>
                <a class="btn" href="submit-complaint.jsp">
                    Submit Complaint
                </a>
            </div>

            <div class="card">
                <h2>Track Complaints</h2>
                <p>
                    View your submitted complaints and check whether
                    they are Pending, In Progress, or Resolved.
                </p>
                <a class="btn" href="my-complaints.jsp">
                    Track My Complaints
                </a>
            </div>
        </section>

        <p class="note">
            Campus Complaint Management System
        </p>
    </main>
</body>
</html>
