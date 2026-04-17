<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Мои заказы</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">Купи-Маркет</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/catalog">Каталог</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart">Корзина</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/orders">Мои заказы</a></li>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <li class="nav-item"><span class="nav-link text-light">Привет, ${sessionScope.user.username}</span></li>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Выйти</a></li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/login">Вход</a></li>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/register">Регистрация</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="card shadow">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">Мои заказы</h3>
            </div>
            <div class="card-body">
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success">Заказ успешно оформлен!</div>
                </c:if>

                <c:choose>
                    <c:when test="${empty orders}">
                        <p>У вас еще нет заказов</p>
                        <a href="${pageContext.request.contextPath}/catalog" class="btn btn-primary">Перейти к покупкам</a>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${orders}" var="order">
                            <div class="card mb-3">
                                <div class="card-header bg-light">
                                    <div class="row">
                                        <div class="col-md-3">
                                            <strong>Заказ #${order.id}</strong>
                                        </div>
                                        <div class="col-md-3">
                                            Дата: ${order.orderDate}
                                        </div>
                                        <div class="col-md-3">
                                            <span class="badge bg-${order.status == 'DELIVERED' ? 'success' :
                                                              order.status == 'CANCELLED' ? 'danger' :
                                                              order.status == 'SHIPPED' ? 'info' : 'warning'}">
                                                ${order.status}
                                            </span>
                                        </div>
                                        <div class="col-md-3 text-end">
                                            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₽"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <p><strong>Адрес:</strong> ${order.shippingAddress}</p>
                                    <p><strong>Оплата:</strong> ${order.paymentMethod}</p>

                                    <table class="table table-sm">
                                        <thead>
                                            <tr>
                                                <th>Товар</th>
                                                <th>Количество</th>
                                                <th>Цена</th>
                                                <th>Сумма</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${order.items}" var="item">
                                                <tr>
                                                    <td>${item.productName}</td>
                                                    <td>${item.quantity}</td>
                                                    <td><fmt:formatNumber value="${item.priceAtTime}" type="currency" currencySymbol="₽"/></td>
                                                    <td><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₽"/></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>

                <div class="mt-3">
                    <a href="${pageContext.request.contextPath}/catalog" class="btn btn-secondary">Продолжить покупки</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>