<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Каталог - Купи-Маркет</title>
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
        <div class="row">
            <!-- Боковая панель с категориями -->
            <div class="col-md-3">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Категории</h5>
                    </div>
                    <div class="list-group list-group-flush">
                        <a href="${pageContext.request.contextPath}/catalog" class="list-group-item list-group-item-action ${empty selectedCategoryId ? 'active' : ''}">
                            Все категории
                        </a>
                        <c:forEach items="${categories}" var="cat">
                            <a href="${pageContext.request.contextPath}/catalog?categoryId=${cat.id}"
                               class="list-group-item list-group-item-action ${selectedCategoryId == cat.id ? 'active' : ''}">
                                ${cat.name}
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Основной контент с товарами -->
            <div class="col-md-9">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4>Товары</h4>
                    <span class="text-muted">
                        Всего: ${totalProducts}
                        <c:choose>
                            <c:when test="${totalProducts % 10 == 1 && totalProducts % 100 != 11}">товар</c:when>
                            <c:when test="${totalProducts % 10 >= 2 && totalProducts % 10 <= 4 && (totalProducts % 100 < 10 || totalProducts % 100 >= 20)}">товара</c:when>
                            <c:otherwise>товаров</c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div class="row g-4">
                    <c:forEach items="${products}" var="p">
                        <div class="col-md-6 col-lg-4">
                            <div class="card h-100 shadow-sm">
                                <div class="card-body">
                                    <h5 class="card-title">${p.name}</h5>
                                    <p class="card-text text-muted small">${p.description}</p>
                                    <div class="text-primary h4 mb-2">
                                        <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₽"/>
                                    </div>
                                    <div class="text-secondary small mb-3">Остаток: ${p.stockQuantity} шт.</div>
                                    <a href="${pageContext.request.contextPath}/product?id=${p.id}" class="btn btn-outline-primary btn-sm">Подробнее</a>
                                        <form method="post" action="${pageContext.request.contextPath}/cart" class="d-inline">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="productId" value="${p.id}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button type="submit" class="btn btn-success btn-sm">В корзину</button>
                                        </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Пагинация -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}${not empty selectedCategoryId ? '&categoryId='.concat(selectedCategoryId) : ''}">«</a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}${not empty selectedCategoryId ? '&categoryId='.concat(selectedCategoryId) : ''}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}${not empty selectedCategoryId ? '&categoryId='.concat(selectedCategoryId) : ''}">»</a>
                            </li>
                        </ul>
                    </nav>
                    <div class="text-center text-muted small">
                        Показано ${(currentPage-1)*12+1}-${currentPage*12 > totalProducts ? totalProducts : currentPage*12} из ${totalProducts} товаров
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>