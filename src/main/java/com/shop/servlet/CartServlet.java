package com.shop.servlet;

import com.shop.dao.CartDAO;
import com.shop.dao.ProductDAO;
import com.shop.model.CartItem;
import com.shop.model.CartItemView;
import com.shop.model.Product;
import com.shop.model.SessionCartItem;
import com.shop.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @SuppressWarnings("unchecked")
    private Map<Integer, SessionCartItem> getSessionCart(HttpSession session) {
        Map<Integer, SessionCartItem> cart = (Map<Integer, SessionCartItem>) session.getAttribute("sessionCart");
        if (cart == null) {
            cart = new ConcurrentHashMap<>();
            session.setAttribute("sessionCart", cart);
        }
        return cart;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        try {
            List<CartItemView> cartItemViews = new ArrayList<>();
            BigDecimal total = BigDecimal.ZERO;
            int itemCount = 0;

            if (user != null) {
                List<CartItem> cartItems = cartDAO.getCartByUserId(user.getId());
                for (CartItem item : cartItems) {
                    CartItemView view = new CartItemView();
                    view.setCartItemId(item.getId());
                    view.setProductId(item.getProductId());
                    view.setProductName(item.getProductName());
                    view.setPrice(item.getPrice());
                    view.setQuantity(item.getQuantity());
                    view.setStockQuantity(item.getStockQuantity());
                    view.setSubtotal(item.getSubtotal());
                    cartItemViews.add(view);
                    total = total.add(view.getSubtotal());
                    itemCount += view.getQuantity();
                }
            } else {
                Map<Integer, SessionCartItem> sessionCart = getSessionCart(req.getSession());
                for (SessionCartItem item : sessionCart.values()) {
                    CartItemView view = new CartItemView();
                    view.setCartItemId(item.getProductId());
                    view.setProductId(item.getProductId());
                    view.setProductName(item.getProductName());
                    view.setPrice(item.getPrice());
                    view.setQuantity(item.getQuantity());
                    view.setStockQuantity(item.getStockQuantity());
                    view.setSubtotal(item.getSubtotal());
                    cartItemViews.add(view);
                    total = total.add(view.getSubtotal());
                    itemCount += view.getQuantity();
                }
            }

            req.setAttribute("cartItems", cartItemViews);
            req.setAttribute("total", total);
            req.setAttribute("itemCount", itemCount);

            req.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Ошибка при загрузке корзины", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        String action = req.getParameter("action");

        try {
            if ("add".equals(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));

                Product product = productDAO.findById(productId);
                if (product == null) {
                    req.setAttribute("error", "Товар не найден");
                    doGet(req, resp);
                    return;
                }

                if (user != null) {
                    cartDAO.addToCart(user.getId(), productId, quantity);
                } else {
                    Map<Integer, SessionCartItem> sessionCart = getSessionCart(session);
                    SessionCartItem existing = sessionCart.get(productId);

                    if (existing != null) {
                        int newQuantity = existing.getQuantity() + quantity;
                        if (newQuantity > product.getStockQuantity()) {
                            req.setAttribute("error", "Доступно только " + product.getStockQuantity() + " шт. товара");
                            doGet(req, resp);
                            return;
                        }
                        existing.setQuantity(newQuantity);
                    } else {
                        if (quantity > product.getStockQuantity()) {
                            req.setAttribute("error", "Доступно только " + product.getStockQuantity() + " шт. товара");
                            doGet(req, resp);
                            return;
                        }
                        SessionCartItem newItem = new SessionCartItem(
                                product.getId(),
                                product.getName(),
                                product.getPrice(),
                                quantity,
                                product.getStockQuantity()
                        );
                        sessionCart.put(productId, newItem);
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/cart?added=true");

            } else if ("update".equals(action)) {
                int cartItemId = Integer.parseInt(req.getParameter("cartItemId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));

                if (user != null) {
                    cartDAO.updateQuantity(cartItemId, quantity);
                } else {
                    Map<Integer, SessionCartItem> sessionCart = getSessionCart(session);
                    SessionCartItem item = sessionCart.get(cartItemId);
                    if (item == null) {
                        req.setAttribute("error", "Элемент корзины не найден");
                        doGet(req, resp);
                        return;
                    }

                    Product product = productDAO.findById(cartItemId);
                    if (product == null) {
                        req.setAttribute("error", "Товар не найден");
                        doGet(req, resp);
                        return;
                    }

                    if (quantity > product.getStockQuantity()) {
                        req.setAttribute("error", "Доступно только " + product.getStockQuantity() + " шт. товара");
                        doGet(req, resp);
                        return;
                    }

                    if (quantity > 0) {
                        item.setQuantity(quantity);
                    } else {
                        sessionCart.remove(cartItemId);
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/cart");

            } else if ("remove".equals(action)) {
                int cartItemId = Integer.parseInt(req.getParameter("cartItemId"));

                if (user != null) {
                    cartDAO.removeFromCart(cartItemId);
                } else {
                    Map<Integer, SessionCartItem> sessionCart = getSessionCart(session);
                    sessionCart.remove(cartItemId);
                }
                resp.sendRedirect(req.getContextPath() + "/cart?removed=true");

            } else {
                resp.sendRedirect(req.getContextPath() + "/cart");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Некорректные данные");
            doGet(req, resp);
        }
    }
}