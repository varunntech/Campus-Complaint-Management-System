
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.campus.config.DBConnection" %>
<%@ page import="org.apache.commons.text.StringEscapeUtils" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (!"ADMIN".equals(session.getAttribute("role"))) {
        response.sendError(403, "Administrator access required.");
        return;
    }

    String updated = request.getParameter("updated");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | CampusCare</title>
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
        }
        header a { color: white; text-decoration: none; }
        main { max-width: 1250px; margin: 30px auto; padding: 20px; }
        .panel {
            background: white;
            padding: 25px;
            border-radius: 12px;
            overflow-x: auto;
        }
        h1 { color: #173b70; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #e2e8f0;
            text-align: left;
            vertical-align: top;
        }
        th { background: #eaf0f9; color: #173b70; }
        input, select, textarea {
            width: 100%;
            padding: 8px;
            margin: 4px 0;
            border: 1px solid #cbd5e1;
            border-radius: 5px;
            font: inherit;
        }
        textarea { min-width: 180px; min-height: 65px; }
        button {
            background: #173b70;
            color: white;
            padding: 9px 13px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .message {
            padding: 12px;
            border-radius: 6px;
            background: #dcfce7;
            color: #166534;
        }
        .error { background: #fee2e2; color: #991b1b; }
    </style>
</head>
<body>
<header>
    <strong>CampusCare — Admin Dashboard</strong>
    <a href="logout">Logout</a>
</header>

<main>
    <section class="panel">
        <h1>Manage Complaints</h1>
        <p>Review student complaints and update their progress.</p>

        <% if ("1".equals(updated)) { %>
            <p class="message">Complaint updated successfully.</p>
        <% } else if ("0".equals(updated)) { %>
            <p class="message error">Complaint not found.</p>
        <% } %>

        <% if ("invalid".equals(error)) { %>
            <p class="message error">Invalid complaint update. Please check the fields.</p>
        <% } %>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Student</th>
                    <th>Title / Description</th>
                    <th>Category</th>
                    <th>Current Status</th>
                    <th>Update Complaint</th>
                    <th>Submitted</th>
                </tr>
            </thead>
            <tbody>
            <%
                String sql = "SELECT c.complaint_id, c.title, c.description, "
                           + "c.category, c.status, c.admin_remarks, c.created_at, "
                           + "u.full_name, u.email "
                           + "FROM complaints c JOIN users u ON c.user_id = u.user_id "
                           + "ORDER BY c.created_at DESC";

                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {

                    boolean found = false;

                    while (rs.next()) {
                        found = true;
                        int id = rs.getInt("complaint_id");
                        String currentStatus = rs.getString("status");
                        String currentRemarks = rs.getString("admin_remarks");
            %>
                <tr>
                    <td><%= id %></td>
                    <td>
                        <%= StringEscapeUtils.escapeHtml4(rs.getString("full_name")) %><br>
                        <%= StringEscapeUtils.escapeHtml4(rs.getString("email")) %>
                    </td>
                    <td>
                        <strong><%= StringEscapeUtils.escapeHtml4(rs.getString("title")) %></strong>
                        <p><%= StringEscapeUtils.escapeHtml4(rs.getString("description")) %></p>
                    </td>
                    <td><%= StringEscapeUtils.escapeHtml4(rs.getString("category")) %></td>
                    <td><%= StringEscapeUtils.escapeHtml4(currentStatus) %></td>
                    <td>
                        <form action="admin-complaints" method="post">
                            <input type="hidden" name="complaintId" value="<%= id %>">

                            <label>Status</label>
                            <select name="status" required>
                                <option value="Pending"
                                    <%= "Pending".equals(currentStatus) ? "selected" : "" %>>
                                    Pending
                                </option>
                                <option value="In Progress"
                                    <%= "In Progress".equals(currentStatus) ? "selected" : "" %>>
                                    In Progress
                                </option>
                                <option value="Resolved"
                                    <%= "Resolved".equals(currentStatus) ? "selected" : "" %>>
                                    Resolved
                                </option>
                            </select>

                            <label>Admin remarks</label>
                            <textarea name="remarks" maxlength="5000" required><%= StringEscapeUtils.escapeHtml4(
                                currentRemarks == null ? "" : currentRemarks) %></textarea>

                            <button type="submit">Save Update</button>
                        </form>
                    </td>
                    <td><%= rs.getTimestamp("created_at") %></td>
                </tr>
            <%
                    }

                    if (!found) {
            %>
                <tr><td colspan="7">No complaints have been submitted yet.</td></tr>
            <%
                    }
                } catch (SQLException e) {
                    application.log("Unable to load admin complaints.", e);
            %>
                <tr><td colspan="7">Unable to load complaints. Check the server log.</td></tr>
            <%
                }
            %>
            </tbody>
        </table>
    </section>
</main>
</body>
</html>
