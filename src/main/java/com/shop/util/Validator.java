package com.shop.util;

import java.util.regex.Pattern;

public class Validator {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    private static final Pattern USERNAME_PATTERN =
            Pattern.compile("^[A-Za-z0-9_-]{3,50}$");

    // Проверка логина (3-50 символов, только буквы, цифры, _, -)
    public static boolean isValidUsername(String username) {
        if (username == null) return false;
        return USERNAME_PATTERN.matcher(username).matches();
    }

    // Проверка пароля (минимум 6 символов)
    public static boolean isValidPassword(String password) {
        if (password == null) return false;
        return password.length() >= 6;
    }

    // Проверка email
    public static boolean isValidEmail(String email) {
        if (email == null) return false;
        return EMAIL_PATTERN.matcher(email).matches();
    }

    // Проверка адреса доставки (не пустой, минимум 5 символов)
    public static boolean isValidAddress(String address) {
        if (address == null) return false;
        return address.trim().length() >= 5;
    }

    // Проверка номера карты (только цифры, 13-19 цифр)
    public static boolean isValidCardNumber(String cardNumber) {
        if (cardNumber == null || cardNumber.trim().isEmpty()) {
            return false;
        }
        String cleaned = cardNumber.replaceAll("[\\s-]", "");
        return cleaned.matches("\\d{13,19}");
    }

    // Получение сообщений об ошибках
    public static String getUsernameError(String username) {
        if (username == null || username.trim().isEmpty()) {
            return "Логин обязателен для заполнения";
        }
        if (!USERNAME_PATTERN.matcher(username).matches()) {
            return "Логин должен содержать 3-50 символов (буквы, цифры, _, -)";
        }
        return null;
    }

    public static String getPasswordError(String password) {
        if (password == null || password.trim().isEmpty()) {
            return "Пароль обязателен для заполнения";
        }
        if (password.length() < 6) {
            return "Пароль должен содержать минимум 6 символов";
        }
        return null;
    }

    public static String getEmailError(String email) {
        if (email == null || email.trim().isEmpty()) {
            return "Email обязателен для заполнения";
        }
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            return "Введите корректный email адрес";
        }
        return null;
    }

    public static String getAddressError(String address) {
        if (address == null || address.trim().isEmpty()) {
            return "Адрес доставки обязателен для заполнения";
        }
        if (address.trim().length() < 5) {
            return "Введите полный адрес (минимум 5 символов)";
        }
        return null;
    }

    public static String getCardNumberError(String cardNumber) {
        if (cardNumber == null || cardNumber.trim().isEmpty()) {
            return "Номер карты обязателен для заполнения";
        }
        String cleaned = cardNumber.replaceAll("[\\s-]", "");
        if (!cleaned.matches("\\d+")) {
            return "Номер карты должен содержать только цифры";
        }
        if (cleaned.length() < 13 || cleaned.length() > 19) {
            return "Номер карты должен содержать 13-19 цифр";
        }
        return null;
    }
}