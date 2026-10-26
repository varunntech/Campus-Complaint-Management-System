
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

@WebServlet("/submit-complaint")
public class ComplaintServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String description = request.getParameter("description");

        if (title == null || category == null || description == null
                || title.trim().isEmpty()
                || category.trim().isEmpty()
                || description.trim().isEmpty()) {
            response.sendRedirect("submit-complaint.jsp?error=empty");
            return;
        }

        title = title.trim();
        category = category.trim();
        description = description.trim();

        if (title.length() > 150 || category.length() > 60
                || description.length() > 5000) {
            response.sendRedirect("submit-complaint.jsp?error=length");
            return;
        }

        String sql = "INSERT INTO complaints "
                + "(user_id, title, category, description) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, (Integer) session.getAttribute("userId"));
            statement.setString(2, title);
            statement.setString(3, category);
            statement.setString(4, description);

            statement.executeUpdate();

            response.sendRedirect("my-complaints.jsp?submitted=1");

        } catch (SQLException e) {
            throw new ServletException("Unable to submit complaint.", e);
        }
    }
}

