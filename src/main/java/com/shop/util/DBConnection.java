package com.shop.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    private static String url;
    private static String user;
    private static String password;

    static {
        try {
            // Загружаем драйвер
            Class.forName("org.postgresql.Driver");

            // Загружаем конфигурацию
            Properties props = new Properties();
            try (InputStream input = DBConnection.class
                    .getClassLoader()
                    .getResourceAsStream("database.properties")) {

                if (input == null) {
                    throw new RuntimeException(
                            "Файл database.properties не найден! " +
                                    "Скопируйте database.properties.example в database.properties и укажите параметры."
                    );
                }
                props.load(input);
            }

            url = props.getProperty("db.url");
            user = props.getProperty("db.user");
            password = props.getProperty("db.password");

            // Проверка на заглушку
            if ("your_password_here".equals(password)) {
                System.err.println("ВНИМАНИЕ: Пароль в database.properties не изменён! " +
                        "Укажите свой пароль для подключения к БД.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Ошибка загрузки конфигурации БД", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, password);
    }

    // Для тестирования
    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            System.out.println("Подключение к БД успешно!");
        } catch (SQLException e) {
            System.err.println("Ошибка подключения: " + e.getMessage());
        }
    }
}