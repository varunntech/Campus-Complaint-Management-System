
package com.campus.servlet;

import com.campus.config.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (fullName == null || email == null
                || password == null || confirmPassword == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Please complete all registration fields.");
            return;
        }

        fullName = fullName.trim();
        email = email.trim().toLowerCase();

        if (fullName.isEmpty() || email.isEmpty()
                || password.isEmpty() || confirmPassword.isEmpty()) {
            response.sendRedirect("register.jsp?error=empty");
            return;
        }

        if (fullName.length() > 100 || email.length() > 150) {
            response.sendRedirect("register.jsp?error=length");
            return;
        }

        if (!EMAIL_PATTERN.matcher(email).matches()) {
            response.sendRedirect("register.jsp?error=email");
            return;
        }

        if (password.length() < 8) {
            response.sendRedirect("register.jsp?error=password");
            return;
        }

        if (!password.equals(confirmPassword)) {
            response.sendRedirect("register.jsp?error=mismatch");
            return;
        }

        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt(12));

        String sql = "INSERT INTO users "
                + "(full_name, email, password_hash, role) "
                + "VALUES (?, ?, ?, 'STUDENT')";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, fullName);
            statement.setString(2, email);
            statement.setString(3, passwordHash);

            statement.executeUpdate();

            response.sendRedirect("login.jsp?registered=1");

        } catch (SQLException e) {
            if ("23000".equals(e.getSQLState())) {
                response.sendRedirect("register.jsp?error=exists");
            } else {
                throw new ServletException(
                        "Unable to register the student.", e);
            }
        }
    }
}
