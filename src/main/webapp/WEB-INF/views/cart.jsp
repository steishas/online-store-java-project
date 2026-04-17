<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Корзина - Купи-Маркет</title>
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
                <h3 class="mb-0">Корзина</h3>
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <c:choose>
                    <c:when test="${empty cartItems}">
                        <p>Корзина пуста</p>
                        <a href="${pageContext.request.contextPath}/catalog" class="btn btn-primary">Перейти к покупкам</a>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead class="table-light">
                                    <tr>
                                        <th>Товар</th>
                                        <th>Цена</th>
                                        <th>Количество</th>
                                        <th>Сумма</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${cartItems}" var="item">
                                        <tr>
                                            <td>${item.productName}</td>
                                            <td><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₽"/></td>
                                            <td>
                                                <form method="post" style="display: inline-block;">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                                    <div class="input-group" style="width: 130px;">
                                                        <input type="number" name="quantity" value="${item.quantity}"
                                                               min="1" max="${item.stockQuantity}" class="form-control form-control-sm">
                                                        <button type="submit" class="btn btn-sm btn-outline-secondary">Обн.</button>
                                                    </div>
                                                </form>
                                                <div class="small text-muted">Доступно: ${item.stockQuantity}</div>
                                            </td>
                                            <td><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₽"/></td>
                                            <td>
                                                <form method="post" style="display: inline;">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                                    <button type="submit" class="btn btn-sm btn-danger">Удалить</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <div class="text-end mt-3">
                            <h4>Итого: <fmt:formatNumber value="${total}" type="currency" currencySymbol="₽"/></h4>
                        </div>

                        <hr>

                        <!-- Форма оформления заказа (доступна всем, но проверит авторизацию) -->
                        <form method="post" action="${pageContext.request.contextPath}/orders">
                            <input type="hidden" name="action" value="checkout">

                            <div class="mb-3">
                                <label class="form-label">Адрес доставки *</label>
                                <textarea name="shippingAddress" rows="2" class="form-control" required>${shippingAddress}</textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Способ оплаты *</label>
                                <select name="paymentMethod" id="paymentMethod" class="form-select" onchange="toggleCardNumber()" required>
                                    <option value="Банковская карта" ${paymentMethod == 'Банковская карта' ? 'selected' : ''}>Банковская карта</option>
                                    <option value="Наличными при получении" ${paymentMethod == 'Наличными при получении' ? 'selected' : ''}>Наличными при получении</option>
                                    <option value="Карта при получении" ${paymentMethod == 'Карта при получении' ? 'selected' : ''}>Карта при получении</option>
                                </select>
                            </div>

                            <div class="mb-3" id="cardNumberGroup" style="${paymentMethod == 'Банковская карта' ? 'display:block' : 'display:none'}">
                                <label class="form-label">Номер карты</label>
                                <input type="text" name="cardNumber" id="cardNumber" class="form-control"
                                       placeholder="0000 0000 0000 0000" value="${cardNumber}"
                                       ${paymentMethod == 'Банковская карта' ? 'required' : ''}>
                                <div class="form-text">13-19 цифр, можно вводить с пробелами</div>
                                <c:if test="${not empty cardError}">
                                    <div class="text-danger">${cardError}</div>
                                </c:if>
                            </div>

                            <button type="submit" class="btn btn-success">Оформить заказ</button>
                            <a href="${pageContext.request.contextPath}/catalog" class="btn btn-secondary">Продолжить покупки</a>
                        </form>

                        <c:if test="${empty sessionScope.user}">
                            <div class="alert alert-info mt-3">
                                <strong>Внимание!</strong> При оформлении заказа потребуется <a href="${pageContext.request.contextPath}/login">войти</a> или <a href="${pageContext.request.contextPath}/register">зарегистрироваться</a>.
                                Товары в корзине будут сохранены после входа.
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        function toggleCardNumber() {
            var paymentMethod = document.getElementById("paymentMethod").value;
            var cardGroup = document.getElementById("cardNumberGroup");
            var cardInput = document.getElementById("cardNumber");

            if (paymentMethod === "Банковская карта") {
                cardGroup.style.display = "block";
                cardInput.setAttribute("required", "required");
            } else {
                cardGroup.style.display = "none";
                cardInput.removeAttribute("required");
            }
        }

        toggleCardNumber();

        document.getElementById("cardNumber")?.addEventListener("input", function(e) {
            var value = this.value.replace(/\s/g, '');
            if (value.length > 0) {
                var formatted = value.match(/.{1,4}/g);
                if (formatted) {
                    this.value = formatted.join(' ');
                }
            }
        });
    </script>
</body>
</html>