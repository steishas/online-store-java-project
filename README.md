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

#### Настройка проекта в IntelliJ IDEA
Откройте проект
Запустите IntelliJ IDEA
Нажмите Open (или File → Open)
Выберите папку с проектом
Дождитесь загрузки Maven зависимостей (появится внизу)

Настройте подключение к базе данных
Откройте файл: src/main/resources/database.properties

Измените пароль на свой:
```bash
properties
db.url=jdbc:postgresql://localhost:5432/online_store
db.user=postgres
db.password=ВАШ_ПАРОЛЬ      # замените на пароль PostgreSQL
```

Настройте Tomcat в IDEA
Нажмите Run → Edit Configurations (или ⌘ + , на Mac)

Нажмите + → Tomcat Server → Local

В разделе Server:
- Name: Tomcat 9
- Application server: нажмите Configure... → выберите папку с Tomcat
- HTTP port: 8080

Перейдите на вкладку Deployment:
Нажмите + → Artifact
Выберите online-store:war exploded
Application context: /online-store

Нажмите `OK`

### 4. Сборка и запуск
**Способ 1:** Запуск через Tomcat в IDEA (рекомендуется)
- Выберите конфигурацию Tomcat 9 в правом верхнем углу
- Нажмите Shift + F10
- Дождитесь запуска Tomcat

**Способ 2:** Запуск через Maven (без установки Tomcat)
В терминале IntelliJ IDEA (Alt + F12) выполните:

```bash
mvn clean package
mvn tomcat7:run
```
**Способ 3:** Через Maven панель
- Откройте Maven панель справа (иконка m)
- Разверните online-store → Lifecycle
- Дважды кликните clean
- Дважды кликните package
- Разверните Plugins → tomcat7
- Дважды кликните tomcat7:run

Приложение будет доступно по адресу: `http://localhost:8080/online-store/`

#### Альтернативный запуск через Tomcat

```bash
mvn clean package
cp target/online-store.war /путь_к_tomcat/webapps/
cd /путь_к_tomcat/bin
./startup.sh   # или startup.bat для Windows
```


## Тестовые данные
**Логин** - admin	

**Пароль** - adminexample

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

2. Ошибка 404:
   
Проверьте, что Tomcat запущен и контекст приложения online-store развёрнут.

3. Ошибка: mvn: command not found
   
В IntelliJ IDEA есть встроенный Maven. Используйте Maven панель справа вместо терминала.

4. Ошибка: Порт 8080 уже используется
   
Остановите программу, использующую порт 8080, или измените порт в настройках Tomcat.

5.  Ошибка компиляции
Выполните:
```bash
mvn clean compile
```
**Автор**: Смирнова Анастасия

**Лицензия**: Учебный проект
