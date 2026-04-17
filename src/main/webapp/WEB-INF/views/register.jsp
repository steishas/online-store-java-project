<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Регистрация</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5" style="max-width: 500px;">
        <div class="card shadow">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">Регистрация</h3>
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form method="post">
                    <div class="mb-3">
                        <label class="form-label">Логин *</label>
                        <input type="text" name="username" class="form-control ${not empty errors.usernameError ? 'is-invalid' : ''}"
                               value="${username}" required>
                        <c:if test="${not empty errors.usernameError}">
                            <div class="invalid-feedback">${errors.usernameError}</div>
                        </c:if>
                        <div class="form-text">3-50 символов (буквы, цифры, _, -)</div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Пароль *</label>
                        <input type="password" name="password" class="form-control ${not empty errors.passwordError ? 'is-invalid' : ''}" required>
                        <c:if test="${not empty errors.passwordError}">
                            <div class="invalid-feedback">${errors.passwordError}</div>
                        </c:if>
                        <div class="form-text">Минимум 6 символов</div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Email *</label>
                        <input type="email" name="email" class="form-control ${not empty errors.emailError ? 'is-invalid' : ''}"
                               value="${email}" required>
                        <c:if test="${not empty errors.emailError}">
                            <div class="invalid-feedback">${errors.emailError}</div>
                        </c:if>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Полное имя</label>
                        <input type="text" name="fullName" class="form-control" value="${fullName}">
                    </div>

                    <button type="submit" class="btn btn-primary w-100">Зарегистрироваться</button>
                </form>

                <div class="text-center mt-3">
                    <a href="${pageContext.request.contextPath}/login">Уже есть аккаунт? Войти</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>