package com.shop.dao;

import com.shop.model.Order;
import com.shop.model.OrderItem;
import com.shop.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    private final CartDAO cartDAO = new CartDAO();
    private final ProductDAO productDAO = new ProductDAO();

    // Создание заказа из корзины
    public Order createOrderFromCart(int userId, String shippingAddress, String paymentMethod) throws SQLException {
        // Получаем корзину
        List<com.shop.model.CartItem> cartItems = cartDAO.getCartByUserId(userId);

        if (cartItems.isEmpty()) {
            throw new SQLException("Корзина пуста");
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Начинаем транзакцию

            // Создаем заказ
            Order order = new Order(userId, shippingAddress, paymentMethod);
            String orderSql = "INSERT INTO orders (user_id, shipping_address, payment_method, total_amount) " +
                    "VALUES (?, ?, ?, ?)";

            try (PreparedStatement orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                orderStmt.setInt(1, userId);
                orderStmt.setString(2, shippingAddress);
                orderStmt.setString(3, paymentMethod);
                orderStmt.setBigDecimal(4, BigDecimal.ZERO);
                orderStmt.executeUpdate();

                try (ResultSet rs = orderStmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        order.setId(rs.getInt(1));
                    }
                }
            }

            BigDecimal totalAmount = BigDecimal.ZERO;

            // Добавляем элементы заказа и уменьшаем остатки на складе
            String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, price_at_time) VALUES (?, ?, ?, ?)";

            try (PreparedStatement itemStmt = conn.prepareStatement(itemSql)) {
                for (com.shop.model.CartItem cartItem : cartItems) {
                    itemStmt.setInt(1, order.getId());
                    itemStmt.setInt(2, cartItem.getProductId());
                    itemStmt.setInt(3, cartItem.getQuantity());
                    itemStmt.setBigDecimal(4, cartItem.getPrice());
                    itemStmt.executeUpdate();

                    // Уменьшаем остаток на складе
                    productDAO.decreaseStock(cartItem.getProductId(), cartItem.getQuantity());

                    // Считаем общую сумму
                    totalAmount = totalAmount.add(cartItem.getPrice().multiply(BigDecimal.valueOf(cartItem.getQuantity())));
                }
            }

            // Обновляем общую сумму заказа
            String updateTotalSql = "UPDATE orders SET total_amount = ? WHERE id = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateTotalSql)) {
                updateStmt.setBigDecimal(1, totalAmount);
                updateStmt.setInt(2, order.getId());
                updateStmt.executeUpdate();
            }

            order.setTotalAmount(totalAmount);

            // Очищаем корзину
            cartDAO.clearCart(userId);

            conn.commit(); // Подтверждаем транзакцию

            return order;

        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback(); // Откатываем при ошибке
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    // Получение заказов пользователя
    public List<Order> getOrdersByUserId(int userId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username FROM orders o " +
                "JOIN users u ON o.user_id = u.id " +
                "WHERE o.user_id = ? ORDER BY o.order_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Order order = mapRowToOrder(rs);
                order.setItems(getOrderItemsByOrderId(order.getId()));
                orders.add(order);
            }
        }
        return orders;
    }

    // Получение заказа по ID
    public Order findById(int orderId) throws SQLException {
        String sql = "SELECT o.*, u.username FROM orders o " +
                "JOIN users u ON o.user_id = u.id " +
                "WHERE o.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Order order = mapRowToOrder(rs);
                order.setItems(getOrderItemsByOrderId(order.getId()));
                return order;
            }
        }
        return null;
    }

    // Получение всех заказов (для админа)
    public List<Order> findAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username FROM orders o " +
                "JOIN users u ON o.user_id = u.id ORDER BY o.order_date DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Order order = mapRowToOrder(rs);
                order.setItems(getOrderItemsByOrderId(order.getId()));
                orders.add(order);
            }
        }
        return orders;
    }

    // Обновление статуса заказа
    public void updateOrderStatus(int orderId, String status) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();
        }
    }

    // Получение элементов заказа
    private List<OrderItem> getOrderItemsByOrderId(int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.name as product_name FROM order_items oi " +
                "JOIN products p ON oi.product_id = p.id " +
                "WHERE oi.order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setProductName(rs.getString("product_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPriceAtTime(rs.getBigDecimal("price_at_time"));

                Timestamp timestamp = rs.getTimestamp("created_at");
                if (timestamp != null) {
                    item.setCreatedAt(timestamp.toLocalDateTime());
                }

                items.add(item);
            }
        }
        return items;
    }

    private Order mapRowToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setUsername(rs.getString("username"));

        Timestamp orderDate = rs.getTimestamp("order_date");
        if (orderDate != null) {
            order.setOrderDate(orderDate.toLocalDateTime());
        }

        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setPaymentMethod(rs.getString("payment_method"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            order.setCreatedAt(createdAt.toLocalDateTime());
        }

        return order;
    }
}
