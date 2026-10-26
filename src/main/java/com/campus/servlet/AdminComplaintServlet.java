
package com.campus.servlet;

import com.campus.config.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin-complaints")
public class AdminComplaintServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Only administrators can update complaints.");
            return;
        }

        String idValue = request.getParameter("complaintId");
        String status = request.getParameter("status");
        String remarks = request.getParameter("remarks");

        if (idValue == null || status == null || remarks == null) {
            response.sendRedirect("admin-dashboard.jsp?error=invalid");
            return;
        }

        int complaintId;

        try {
            complaintId = Integer.parseInt(idValue);
        } catch (NumberFormatException e) {
            response.sendRedirect("admin-dashboard.jsp?error=invalid");
            return;
        }

        if (complaintId <= 0
                || !("Pending".equals(status)
                || "In Progress".equals(status)
                || "Resolved".equals(status))
                || remarks.length() > 5000) {

            response.sendRedirect("admin-dashboard.jsp?error=invalid");
            return;
        }

        String sql = "UPDATE complaints SET status = ?, admin_remarks = ? "
                   + "WHERE complaint_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, remarks.trim());
            ps.setInt(3, complaintId);

            int updated = ps.executeUpdate();

            response.sendRedirect("admin-dashboard.jsp?updated="
                    + (updated == 1 ? "1" : "0"));

        } catch (SQLException e) {
            throw new ServletException("Unable to update complaint.", e);
        }
    }
}
