
package com.campus.servlet;

import com.campus.config.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null
                || email.trim().isEmpty() || password.isEmpty()) {
            response.sendRedirect("login.jsp?error=empty");
            return;
        }

        email = email.trim().toLowerCase();

        String sql = "SELECT user_id, full_name, email, "
                + "password_hash, role FROM users WHERE email = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, email);

            try (ResultSet result = statement.executeQuery()) {

                if (result.next()) {
                    String storedHash = result.getString("password_hash");

                    if (storedHash != null
                            && BCrypt.checkpw(password, storedHash)) {

                        HttpSession oldSession = request.getSession(false);

                        if (oldSession != null) {
                            oldSession.invalidate();
                        }

                        HttpSession session = request.getSession(true);
                        session.setAttribute("userId",
                                result.getInt("user_id"));
                        session.setAttribute("fullName",
                                result.getString("full_name"));
                        session.setAttribute("email",
                                result.getString("email"));
                        session.setAttribute("role",
                                result.getString("role"));

                        session.setMaxInactiveInterval(30 * 60);

                        response.sendRedirect("dashboard.jsp");
                        return;
                    }
                }

                response.sendRedirect("login.jsp?error=invalid");
            }

        } catch (SQLException e) {
            throw new ServletException(
                    "Unable to log in. Please check the database connection.",
                    e);
        }
    }
}
