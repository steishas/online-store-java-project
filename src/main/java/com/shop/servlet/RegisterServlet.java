package com.shop.servlet;

import com.shop.dao.UserDAO;
import com.shop.model.User;
import com.shop.util.Validator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String fullName = req.getParameter("fullName");

        Map<String, String> errors = new HashMap<>();

        // Валидация полей
        String usernameError = Validator.getUsernameError(username);
        if (usernameError != null) {
            errors.put("usernameError", usernameError);
        }

        String passwordError = Validator.getPasswordError(password);
        if (passwordError != null) {
            errors.put("passwordError", passwordError);
        }

        String emailError = Validator.getEmailError(email);
        if (emailError != null) {
            errors.put("emailError", emailError);
        }

        // Если есть ошибки валидации — возвращаем на форму
        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("username", username);
            req.setAttribute("email", email);
            req.setAttribute("fullName", fullName);
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        try {
            // Проверяем, существует ли пользователь
            if (userDAO.existsByUsername(username)) {
                errors.put("usernameError", "Пользователь с таким логином уже существует");
                req.setAttribute("errors", errors);
                req.setAttribute("username", username);
                req.setAttribute("email", email);
                req.setAttribute("fullName", fullName);
                req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
                return;
            }

            if (userDAO.existsByEmail(email)) {
                errors.put("emailError", "Пользователь с таким email уже существует");
                req.setAttribute("errors", errors);
                req.setAttribute("username", username);
                req.setAttribute("email", email);
                req.setAttribute("fullName", fullName);
                req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
                return;
            }

            // Создаем нового пользователя
            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setEmail(email);
            user.setFullName(fullName);

            userDAO.addUser(user);

            // Перенаправляем на страницу входа
            resp.sendRedirect(req.getContextPath() + "/login?registered=true");

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Ошибка при регистрации: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
        }
    }
}