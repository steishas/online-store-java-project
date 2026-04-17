<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>${product.name}</title>
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

    <div class="container mt-5">
        <div class="row">
            <div class="col-md-8 mx-auto">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h3 class="mb-0">${product.name}</h3>
                    </div>
                    <div class="card-body">
                        <p><strong>Категория:</strong> ${product.categoryName}</p>
                        <p>${product.description}</p>
                        <div class="display-6 text-primary my-3">
                            <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₽"/>
                        </div>
                        <p class="text-secondary">Остаток на складе: ${product.stockQuantity} шт.</p>

                        <c:if test="${not empty sessionScope.user}">
                            <form method="post" action="${pageContext.request.contextPath}/cart" class="mt-3">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="${product.id}">
                                <div class="row g-3 align-items-center">
                                    <div class="col-auto">
                                        <label class="form-label">Количество:</label>
                                    </div>
                                    <div class="col-auto">
                                        <input type="number" name="quantity" value="1" min="1" max="${product.stockQuantity}" class="form-control" style="width: 80px;">
                                    </div>
                                    <div class="col-auto">
                                        <button type="submit" class="btn btn-success">Добавить в корзину</button>
                                    </div>
                                </div>
                            </form>
                        </c:if>

                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/catalog" class="btn btn-secondary">← Назад к каталогу</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>