package com.shop.dao;

import com.shop.model.CartItem;
import com.shop.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    // Добавление товара в корзину с проверкой остатка
    public void addToCart(int userId, int productId, int quantity) throws SQLException {
        int stock = getProductStock(productId);
        if (quantity > stock) {
            throw new SQLException("Доступно только " + stock + " шт. товара");
        }

        String checkSql = "SELECT id, quantity FROM cart WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

            checkStmt.setInt(1, userId);
            checkStmt.setInt(2, productId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                int currentQuantity = rs.getInt("quantity");
                int newQuantity = currentQuantity + quantity;
                if (newQuantity > stock) {
                    throw new SQLException("В корзине уже " + currentQuantity +
                            " шт. Всего можно добавить не более " + (stock - currentQuantity));
                }
                String updateSql = "UPDATE cart SET quantity = ? WHERE id = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setInt(1, newQuantity);
                    updateStmt.setInt(2, rs.getInt("id"));
                    updateStmt.executeUpdate();
                }
            } else {
                String insertSql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    insertStmt.setInt(1, userId);
                    insertStmt.setInt(2, productId);
                    insertStmt.setInt(3, quantity);
                    insertStmt.executeUpdate();
                }
            }
        }
    }

    // Получение корзины пользователя (с остатком товара)
    public List<CartItem> getCartByUserId(int userId) throws SQLException {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT c.id, c.user_id, c.product_id, c.quantity, c.added_at, " +
                "p.name as product_name, p.price, p.stock_quantity " +
                "FROM cart c JOIN products p ON c.product_id = p.id " +
                "WHERE c.user_id = ? ORDER BY c.added_at";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setId(rs.getInt("id"));
                item.setUserId(rs.getInt("user_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setProductName(rs.getString("product_name"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setQuantity(rs.getInt("quantity"));
                item.setStockQuantity(rs.getInt("stock_quantity"));
                Timestamp ts = rs.getTimestamp("added_at");
                if (ts != null) item.setAddedAt(ts.toLocalDateTime());
                cartItems.add(item);
            }
        }
        return cartItems;
    }

    // Обновление количества в корзине с проверкой остатка
    public void updateQuantity(int cartItemId, int newQuantity) throws SQLException {
        // Получаем product_id
        String selectSql = "SELECT product_id FROM cart WHERE id = ?";
        int productId;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {
            selectStmt.setInt(1, cartItemId);
            ResultSet rs = selectStmt.executeQuery();
            if (!rs.next()) {
                throw new SQLException("Элемент корзины не найден");
            }
            productId = rs.getInt("product_id");
        }

        int stock = getProductStock(productId);
        if (newQuantity > stock) {
            throw new SQLException("Доступно только " + stock + " шт. товара");
        }

        String updateSql = "UPDATE cart SET quantity = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
            updateStmt.setInt(1, newQuantity);
            updateStmt.setInt(2, cartItemId);
            updateStmt.executeUpdate();
        }
    }

    // Удаление товара из корзины
    public void removeFromCart(int cartItemId) throws SQLException {
        String sql = "DELETE FROM cart WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartItemId);
            stmt.executeUpdate();
        }
    }

    // Очистка корзины пользователя
    public void clearCart(int userId) throws SQLException {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        }
    }

    // Получение общего количества товаров в корзине
    public int getCartItemCount(int userId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(quantity), 0) as total FROM cart WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    // Получение общей суммы корзины
    public BigDecimal getCartTotal(int userId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(p.price * c.quantity), 0) as total " +
                "FROM cart c JOIN products p ON c.product_id = p.id " +
                "WHERE c.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
        }
        return BigDecimal.ZERO;
    }

    // Вспомогательный метод для получения остатка товара
    private int getProductStock(int productId) throws SQLException {
        String sql = "SELECT stock_quantity FROM products WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("stock_quantity");
            }
            return 0;
        }
    }
}