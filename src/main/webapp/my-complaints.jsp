
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.campus.config.DBConnection" %>
<%@ page import="org.apache.commons.text.StringEscapeUtils" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (Integer) session.getAttribute("userId");
    String message = request.getParameter("submitted");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Complaints | CampusCare</title>
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
            padding: 20px 7%;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        header a { color: white; text-decoration: none; }
        main { max-width: 1100px; margin: 35px auto; padding: 20px; }
        .panel {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,.06);
            overflow-x: auto;
        }
        h1 { color: #173b70; }
        .success {
            padding: 12px;
            background: #dcfce7;
            color: #166534;
            border-radius: 6px;
        }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; border-bottom: 1px solid #e2e8f0; text-align: left; }
        th { background: #eaf0f9; color: #173b70; }
        .status { font-weight: bold; }
        .empty { color: #64748b; padding: 20px 0; }
        .btn {
            display: inline-block;
            background: #173b70;
            color: white;
            padding: 11px 16px;
            border-radius: 6px;
            text-decoration: none;
            margin: 10px 8px 0 0;
        }
    </style>
</head>
<body>
<header>
    <strong>CampusCare — My Complaints</strong>
    <a href="logout">Logout</a>
</header>

<main>
    <section class="panel">
        <h1>My Complaints</h1>
        <p>View the status and remarks for your submitted complaints.</p>

        <% if ("1".equals(message)) { %>
            <p class="success">Your complaint was submitted successfully.</p>
        <% } %>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Category</th>
                    <th>Description</th>
                    <th>Status</th>
                    <th>Admin Remarks</th>
                    <th>Submitted</th>
                </tr>
            </thead>
            <tbody>
            <%
                String sql = "SELECT complaint_id, title, category, description, "
                           + "status, admin_remarks, created_at "
                           + "FROM complaints WHERE user_id = ? "
                           + "ORDER BY created_at DESC";

                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(sql)) {

                    ps.setInt(1, userId);

                    try (ResultSet rs = ps.executeQuery()) {
                        boolean found = false;

                        while (rs.next()) {
                            found = true;
            %>
                <tr>
                    <td><%= rs.getInt("complaint_id") %></td>
                    <td><%= StringEscapeUtils.escapeHtml4(rs.getString("title")) %></td>
                    <td><%= StringEscapeUtils.escapeHtml4(rs.getString("category")) %></td>
                    <td><%= StringEscapeUtils.escapeHtml4(rs.getString("description")) %></td>
                    <td class="status"><%= StringEscapeUtils.escapeHtml4(rs.getString("status")) %></td>
                    <td><%= StringEscapeUtils.escapeHtml4(
                        rs.getString("admin_remarks") == null
                            ? "No remarks yet" : rs.getString("admin_remarks")) %></td>
                    <td><%= rs.getTimestamp("created_at") %></td>
                </tr>
            <%
                        }

                        if (!found) {
            %>
                <tr>
                    <td colspan="7" class="empty">
                        You have not submitted any complaints yet.
                    </td>
                </tr>
            <%
                        }
                    }
                } catch (SQLException e) {
                    application.log("Unable to load student complaints.", e);
            %>
                <tr>
                    <td colspan="7">Unable to load complaints. Please check the server log.</td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>

        <a class="btn" href="submit-complaint.jsp">Submit Another Complaint</a>
        <a class="btn" href="dashboard.jsp">Back to Dashboard</a>
    </section>
</main>
</body>
</html>

