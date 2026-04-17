package com.shop.servlet;

import com.shop.dao.CartDAO;
import com.shop.dao.OrderDAO;
import com.shop.model.CartItem;
import com.shop.model.Order;
import com.shop.model.User;
import com.shop.util.Validator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("/WEB-INF/views/orders.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Ошибка при загрузке истории заказов", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = req.getParameter("action");

        if ("checkout".equals(action)) {
            String shippingAddress = req.getParameter("shippingAddress");
            String paymentMethod = req.getParameter("paymentMethod");
            String cardNumber = req.getParameter("cardNumber");

            // Валидация адреса
            String addressError = Validator.getAddressError(shippingAddress);
            if (addressError != null) {
                req.setAttribute("error", addressError);
                loadCartAndForward(req, resp, user);
                return;
            }

            // Валидация номера карты (только для "Банковская карта")
            if ("Банковская карта".equals(paymentMethod)) {
                String cardError = Validator.getCardNumberError(cardNumber);
                if (cardError != null) {
                    req.setAttribute("cardError", cardError);
                    loadCartAndForward(req, resp, user);
                    return;
                }
            }

            // Оформление заказа
            try {
                Order order = orderDAO.createOrderFromCart(user.getId(), shippingAddress, paymentMethod);
                resp.sendRedirect(req.getContextPath() + "/orders?success=true&orderId=" + order.getId());
            } catch (SQLException e) {
                e.printStackTrace();
                req.setAttribute("error", "Ошибка при оформлении заказа: " + e.getMessage());
                loadCartAndForward(req, resp, user);
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/orders");
        }
    }

    private void loadCartAndForward(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        try {
            // Сохраняем введённые значения
            req.setAttribute("shippingAddress", req.getParameter("shippingAddress"));
            req.setAttribute("paymentMethod", req.getParameter("paymentMethod"));
            req.setAttribute("cardNumber", req.getParameter("cardNumber"));

            List<CartItem> cartItems = cartDAO.getCartByUserId(user.getId());
            BigDecimal total = cartDAO.getCartTotal(user.getId());
            int itemCount = cartDAO.getCartItemCount(user.getId());

            req.setAttribute("cartItems", cartItems);
            req.setAttribute("total", total);
            req.setAttribute("itemCount", itemCount);

            req.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Ошибка при загрузке корзины", e);
        }
    }
}