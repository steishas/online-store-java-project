# Купи-Маркет — Интернет-магазин

Веб-приложение интернет-магазина на Java с использованием PostgreSQL, MVC архитектуры и Bootstrap.

## Технологии

- **Java 17**
- **PostgreSQL 14+**
- **Apache Tomcat 9+**
- **Maven**
- **Servlets + JSP + JSTL**
- **Bootstrap 5**
- **BCrypt** (хеширование паролей)

## Функционал

- Регистрация и вход (пароли хешируются BCrypt)
- Каталог товаров с пагинацией (12 товаров на странице)
- Фильтрация по категориям
- Карточка товара
- Корзина (работает без регистрации)
- Оформление заказа (требуется вход)
- История заказов
- Валидация форм (логин, пароль, email, адрес, номер карты)
- Проверка остатка товара при добавлении в корзину

## Установка и запуск

### Требования

- JDK 17 или выше
- Apache Tomcat 9+ (или Maven с плагином tomcat7)
- PostgreSQL 14+

### 1. Клонирование репозитория

```bash
git clone https://github.com/steishas/online-store-java-project.git
cd online-store-java-project
```

### 2. Настройка базы данных

```bash
# Создайте базу данных
psql -U postgres -c "CREATE DATABASE online_store;"

# Выполните SQL-скрипт
psql -U postgres -d online_store -f online_store_db.sql
```
### 3. Настройка подключения

Отредактируйте файл `src/main/resources/database.properties`

```bash
db.url=jdbc:postgresql://localhost:5432/online_store
db.user=postgres
db.password=ВАШ_ПАРОЛЬ
```

### 4. Сборка и запуск

```bash
mvn clean package
mvn tomcat7:run
```

Приложение будет доступно по адресу: `http://localhost:8080/online-store/`

#### Альтернативный запуск через Tomcat

```bash
mvn clean package
cp target/online-store.war /путь_к_tomcat/webapps/
cd /путь_к_tomcat/bin
./startup.sh   # или startup.bat для Windows
```


## Тестовые данные
Логин - admin	

Пароль - admin

100 товаров в 3 категориях.
Корзина и заказы пусты.

## Структура проекта

```text
online-store/
├── src/main/java/com/shop/
│   ├── dao/            # Data Access Objects
│   ├── filter/         # EncodingFilter (UTF-8)
│   ├── model/          # Bean-классы
│   ├── servlet/        # Контроллеры (7 сервлетов)
│   └── util/           # DBConnection, Validator
├── src/main/resources/
│   └── database.properties
├── src/main/webapp/
│   ├── WEB-INF/views/  # JSP страницы (6 файлов)
│   └── index.jsp
├── online_store_db.sql
├── pom.xml
└── README.md
```
## Возможные проблемы
1. Ошибка подключения к БД
Убедитесь, что:
- PostgreSQL запущен
- Пароль в database.properties правильный
- База данных online_store создана

2. Ошибка 404
Проверьте, что Tomcat запущен и контекст приложения online-store развёрнут.

**Автор**: Смирнова Анастасия
**Лицензия**: Учебный проект
