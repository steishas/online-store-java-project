package com.shop.servlet;

import com.shop.dao.CartDAO;
import com.shop.dao.UserDAO;
import com.shop.model.SessionCartItem;
import com.shop.model.User;
import com.shop.util.Validator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Проверяем параметр registered для отображения сообщения
        if (req.getParameter("registered") != null) {
            req.setAttribute("success", "Регистрация прошла успешно! Войдите в систему.");
        }

        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || password == null) {
            req.setAttribute("error", "Введите логин и пароль");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        try {
            User user = userDAO.findByUsername(username);

            if (user == null) {
                req.setAttribute("error", "Пользователь не найден");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }

            // Проверяем пароль (с поддержкой BCrypt)
            boolean passwordMatches;
            try {
                // Если пароль начинается с $2a$ — это хеш BCrypt
                if (user.getPassword().startsWith("$2a$")) {
                    passwordMatches = org.mindrot.jbcrypt.BCrypt.checkpw(password, user.getPassword());
                } else {
                    // Для обратной совместимости (если пароль не хеширован)
                    passwordMatches = user.getPassword().equals(password);
                }
            } catch (Exception e) {
                passwordMatches = user.getPassword().equals(password);
            }

            if (!passwordMatches) {
                req.setAttribute("error", "Неверный пароль");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }

            // Создаем сессию
            HttpSession session = req.getSession();

            // ========== ПЕРЕНОС КОРЗИНЫ ИЗ СЕССИИ В БД ==========
            @SuppressWarnings("unchecked")
            Map<Integer, SessionCartItem> sessionCart = (Map<Integer, SessionCartItem>) session.getAttribute("sessionCart");

            if (sessionCart != null && !sessionCart.isEmpty()) {
                for (SessionCartItem item : sessionCart.values()) {
                    try {
                        cartDAO.addToCart(user.getId(), item.getProductId(), item.getQuantity());
                    } catch (SQLException e) {
                        // Логируем ошибку, но не прерываем вход
                        System.err.println("Ошибка при переносе товара в корзину: " + e.getMessage());
                    }
                }
                // Очищаем сессионную корзину после переноса
                session.removeAttribute("sessionCart");
            }
            // =====================================================

            // Сохраняем пользователя в сессии
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());

            // Перенаправляем на главную страницу или в каталог
            resp.sendRedirect(req.getContextPath() + "/catalog");

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Ошибка при входе: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }
}