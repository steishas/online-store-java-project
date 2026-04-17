--
-- PostgreSQL database dump
--

\restrict JeiJcbXeqFa7RcH7P1PDVyUw2boTXsybWgi0dbIik2dFfnYmzIrpJyeu2QoehAE

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2026-04-17 14:31:04 MSK

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 226 (class 1259 OID 25155)
-- Name: cart; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cart (
    id integer NOT NULL,
    user_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    added_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT cart_quantity_check CHECK ((quantity > 0))
);


--
-- TOC entry 225 (class 1259 OID 25154)
-- Name: cart_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3905 (class 0 OID 0)
-- Dependencies: 225
-- Name: cart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cart_id_seq OWNED BY public.cart.id;


--
-- TOC entry 222 (class 1259 OID 25122)
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 221 (class 1259 OID 25121)
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3906 (class 0 OID 0)
-- Dependencies: 221
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- TOC entry 230 (class 1259 OID 25201)
-- Name: order_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    price_at_time numeric(10,2) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT order_items_price_at_time_check CHECK ((price_at_time >= (0)::numeric)),
    CONSTRAINT order_items_quantity_check CHECK ((quantity > 0))
);


--
-- TOC entry 229 (class 1259 OID 25200)
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3907 (class 0 OID 0)
-- Dependencies: 229
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- TOC entry 228 (class 1259 OID 25180)
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer NOT NULL,
    order_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total_amount numeric(10,2) NOT NULL,
    status character varying(50) DEFAULT 'PENDING'::character varying,
    shipping_address text,
    payment_method character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT orders_total_amount_check CHECK ((total_amount >= (0)::numeric))
);


--
-- TOC entry 227 (class 1259 OID 25179)
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3908 (class 0 OID 0)
-- Dependencies: 227
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- TOC entry 224 (class 1259 OID 25134)
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    category_id integer,
    stock_quantity integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT products_price_check CHECK ((price >= (0)::numeric)),
    CONSTRAINT products_stock_quantity_check CHECK ((stock_quantity >= 0))
);


--
-- TOC entry 223 (class 1259 OID 25133)
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3909 (class 0 OID 0)
-- Dependencies: 223
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- TOC entry 220 (class 1259 OID 25104)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(100) NOT NULL,
    full_name character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 219 (class 1259 OID 25103)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3910 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3702 (class 2604 OID 25158)
-- Name: cart id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart ALTER COLUMN id SET DEFAULT nextval('public.cart_id_seq'::regclass);


--
-- TOC entry 3697 (class 2604 OID 25125)
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- TOC entry 3708 (class 2604 OID 25204)
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- TOC entry 3704 (class 2604 OID 25183)
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- TOC entry 3699 (class 2604 OID 25137)
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- TOC entry 3695 (class 2604 OID 25107)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3895 (class 0 OID 25155)
-- Dependencies: 226
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3891 (class 0 OID 25122)
-- Dependencies: 222
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.categories VALUES (1, 'Электроника', 'Смартфоны, ноутбуки, планшеты и другая техника', '2026-03-31 18:24:54.116665');
INSERT INTO public.categories VALUES (2, 'Одежда', 'Мужская, женская и детская одежда', '2026-03-31 18:24:54.116665');
INSERT INTO public.categories VALUES (3, 'Книги', 'Художественная литература, учебники, программирование', '2026-03-31 18:24:54.116665');


--
-- TOC entry 3899 (class 0 OID 25201)
-- Dependencies: 230
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3897 (class 0 OID 25180)
-- Dependencies: 228
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3893 (class 0 OID 25134)
-- Dependencies: 224
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.products VALUES (2, 'Ноутбук Aspire 7', 'Игровой ноутбук с видеокартой RTX 3050 и 16 ГБ ОЗУ', 78990.00, 1, 12, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (3, 'Футболка хлопковая белая', 'Классическая футболка из 100 процентов хлопка размеры от S до XXL', 890.00, 2, 150, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (5, 'Война и мир', 'Роман эпопея Льва Толстого в двух томах', 450.00, 3, 25, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (6, 'Планшет Tab S6', 'Планшет с S Pen 11 дюймов 128 ГБ памяти', 45990.00, 1, 8, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (7, 'Пуховик зимний', 'Утепленный пуховик с капюшоном цвет черный', 5990.00, 2, 34, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (8, 'Изучаем Python', 'Самоучитель по программированию для начинающих', 1250.00, 3, 60, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (9, 'Наушники TWS Pro', 'Беспроводные наушники с шумоподавлением', 3450.00, 1, 210, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (10, 'Свитер шерстяной', 'Теплый свитер с высоким воротником цвет серый', 2100.00, 2, 45, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (11, 'Мастер и Маргарита', 'Легендарный роман Михаила Булгакова', 520.00, 3, 40, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (12, 'Смарт часы Watch 5', 'Умные часы с GPS и мониторингом здоровья', 15990.00, 1, 23, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (13, 'Юбка миди', 'Кожаная юбка карандаш цвет черный', 3450.00, 2, 17, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (14, 'Программирование на C плюс плюс', 'Полное руководство по C++20', 2100.00, 3, 14, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (15, 'Микроволновая печь', 'Микроволновая печь 20 литров 800 Вт', 4990.00, 1, 9, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (16, 'Кроссовки беговые', 'Легкие кроссовки для бега размеры от 39 до 45', 3990.00, 2, 56, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (17, '1984', 'Роман антиутопия Джорджа Оруэлла', 380.00, 3, 89, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (18, 'Телевизор 43 дюйма', '4K UHD Smart TV поддержка HDR', 29990.00, 1, 6, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (19, 'Платье вечернее', 'Длинное платье из атласа цвет бордовый', 7590.00, 2, 11, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (20, 'Цветы для Элджернона', 'Научно фантастический рассказ', 420.00, 3, 33, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (21, 'Робот пылесос', 'Робот пылесос с лазерной навигацией самоочистка', 18990.00, 1, 4, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (22, 'Шорты спортивные', 'Шорты из дышащей ткани с сеткой', 990.00, 2, 110, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (23, 'Гарри Поттер и философский камень', 'Первая книга о юном волшебнике', 650.00, 3, 72, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (24, 'Клавиатура механическая', 'Механическая клавиатура с подсветкой RGB красные свичи', 7890.00, 1, 31, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (25, 'Блузка шелковая', 'Блузка с бантом цвет бежевый', 2890.00, 2, 22, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (26, 'Мышка беспроводная', 'Эргономичная мышь с тихими кнопками', 1290.00, 1, 84, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (27, 'Детектив Нуар', 'Сборник лучших детективных рассказов', 490.00, 3, 19, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (28, 'Фен профессиональный', 'Фен мощностью 2200 Вт с ионизацией', 3490.00, 1, 27, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (29, 'Куртка джинсовая', 'Классическая джинсовая куртка синего цвета', 2890.00, 2, 45, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (30, 'Скотный двор', 'Сатирическая повесть притча Джорджа Оруэлла', 350.00, 3, 61, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (31, 'Смартфон X100 Pro', 'Камера 200 МП 12 ГБ ОЗУ 512 ГБ памяти', 99990.00, 1, 7, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (32, 'Лосины для фитнеса', 'Высокая посадка непрозрачные черные', 1190.00, 2, 94, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (33, 'Странная история доктора Джекила', 'Мистическая повесть Роберта Стивенсона', 290.00, 3, 43, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (34, 'Зарядное устройство GaN', 'Быстрая зарядка 65 Вт 3 порта', 2490.00, 1, 136, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (35, 'Бейсболка хлопковая', 'Универсальная бейсболка цвет черный', 790.00, 2, 200, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (36, 'Атлант расправил плечи', 'Философский роман Айн Рэнд', 1150.00, 3, 12, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (37, 'SSD накопитель 1TB', 'Внутренний SSD M2 NVMe скорость 5000 МБс', 6590.00, 1, 52, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (38, 'Рубашка поло', 'Хлопковая рубашка поло с воротником', 1590.00, 2, 67, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (39, 'Коллекционное издание Властелин колец', 'Трилогия в кожаном переплете', 4500.00, 3, 5, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (40, 'Монитор 27 дюймов', 'IPS панель 144 Гц 2K разрешение', 21990.00, 1, 15, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (41, 'Спортивный костюм', 'Костюм из футера с капюшоном', 3990.00, 2, 32, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (42, 'Идиот', 'Роман Федора Достоевского', 480.00, 3, 29, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (43, 'Видеокарта RTX 4070', '12 ГБ видеопамяти поддержка трассировки лучей', 58990.00, 1, 3, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (44, 'Носки хлопковые', 'Набор 5 пар черные белые размер 39-42', 590.00, 2, 280, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (45, 'Дюна', 'Фантастический роман Фрэнка Герберта', 720.00, 3, 38, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (46, 'Умная лампочка', 'LED лампочка с управлением по Wi-Fi 16 млн цветов', 890.00, 1, 75, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (47, 'Пальто осеннее', 'Двубортное пальто из кашемира цвет бежевый', 11990.00, 2, 9, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (48, 'Преступление и наказание', 'Классический роман Достоевского', 430.00, 3, 88, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (49, 'Электрочайник', 'Стеклянный чайник с подсветкой 1.7 литра', 1990.00, 1, 41, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (50, 'Толстовка оверсайз', 'Толстовка с капюшоном и кенгуру карманом', 2590.00, 2, 73, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (51, 'Пикник на обочине', 'Фантастическая повесть братьев Стругацких', 390.00, 3, 50, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (1, 'Смартфон Galaxy A15', 'Смартфон с 6.5 дюймовым экраном и батареей 5000 мАч', 18990.00, 1, 44, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (52, 'Беспроводная зарядка', 'Магнитная зарядка MagSafe 15 Вт', 1590.00, 1, 120, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (53, 'Сандалии летние', 'Открытые сандалии на плоской подошве', 1990.00, 2, 28, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (54, 'Три товарища', 'Роман Эриха Марии Ремарка', 550.00, 3, 47, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (55, 'Внешний жесткий диск', '2 ТБ USB 3.2 ударопрочный корпус', 6990.00, 1, 22, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (56, 'Комбинезон детский', 'Детский комбинезон для мальчика утепленный', 2890.00, 2, 19, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (57, 'Марсианские хроники', 'Сборник рассказов Рэя Брэдбери', 470.00, 3, 35, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (58, 'Роутер Wi-Fi 6', 'Двухдиапазонный роутер для дома и офиса', 4490.00, 1, 17, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (59, 'Купальник раздельный', 'Пляжный комплект с юбкой', 1590.00, 2, 44, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (60, 'Сто лет одиночества', 'Роман Габриэля Гарсиа Маркеса', 610.00, 3, 62, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (61, 'Кофеварка капельная', 'Кофеварка на 12 чашек с таймером', 3490.00, 1, 13, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (62, 'Пижама женская', 'Шелковая пижама с кружевом', 3290.00, 2, 26, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (63, 'Стивен Кинг Корпорация Бросайте курить', 'Роман ужасов', 720.00, 3, 21, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (64, 'Сетевое хранилище NAS', '2 дисковое сетевое хранилище без дисков', 15990.00, 1, 6, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (65, 'Ремень кожаный', 'Классический ремень с автоматической пряжкой', 1290.00, 2, 93, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (66, 'Алиса в Стране чудес', 'Сказка с иллюстрациями', 890.00, 3, 58, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (67, 'Игровая приставка', 'Портативная игровая консоль с 5000 играми', 8990.00, 1, 11, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (68, 'Плащ непромокаемый', 'Тонкий плащ дождевик цвет оливковый', 1990.00, 2, 37, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (69, 'Богатый папа бедный папа', 'Книга о финансовой грамотности', 450.00, 3, 140, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (70, 'Фитнес браслет', 'Трекер активности с пульсометром и шагомером', 2490.00, 1, 82, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (71, 'Костюм деловой', 'Классический костюм двойка цвет синий', 10990.00, 2, 8, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (72, 'Маленький принц', 'Философская сказка Антуана де Сент Экзюпери', 290.00, 3, 210, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (73, 'Web камера 4K', 'Камера для стримов с автофокусом', 7890.00, 1, 24, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (74, 'Вязаное платье', 'Платье свитер цвет серый', 2790.00, 2, 31, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (75, 'Автостопом по галактике', 'Юмористическая фантастика', 520.00, 3, 46, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (76, 'Звуковая колонка', 'Портативная колонка 20 Вт защита от воды', 3990.00, 1, 65, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (77, 'Сумка шоппер', 'Вместительная сумка из экокожи', 1890.00, 2, 74, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (78, 'Граф Монте Кристо', 'Приключенческий роман Александра Дюма', 890.00, 3, 39, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (79, 'Мышь геймерская', 'Проводная мышь с 6 программируемыми кнопками', 1990.00, 1, 55, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (80, 'Кеды на платформе', 'Кеды высокие цвет белый', 3490.00, 2, 19, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (81, '451 градус по Фаренгейту', 'Роман антиутопия Рэя Брэдбери', 400.00, 3, 82, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (82, 'Сплит система', 'Кондиционер 7 кВт инверторный тип', 34990.00, 1, 5, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (83, 'Брюки чинос', 'Брюки хлопковые цвет хаки', 2590.00, 2, 49, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (84, 'Шантарам', 'Приключенческий роман Грегори Дэвида Робертса', 890.00, 3, 27, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (85, 'Селфи монопод', 'Тренога с Bluetooth пультом', 1190.00, 1, 103, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (86, 'Жилет утепленный', 'Мужской жилет на синтепоне', 1690.00, 2, 33, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (87, 'Норвежский лес', 'Роман Харуки Мураками', 620.00, 3, 44, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (88, 'Ортопедическая подушка', 'Подушка с эффектом памяти', 2990.00, 1, 18, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (89, 'Шарф кашне', 'Теплый шарф из мериноса', 990.00, 2, 76, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (90, 'Метро 2033', 'Постапокалиптический роман Дмитрия Глуховского', 540.00, 3, 51, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (91, 'Смарт розетка', 'Wi-Fi розетка с контролем энергопотребления', 690.00, 1, 210, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (92, 'Фартук для кухни', 'Водоотталкивающий фартук цвет в полоску', 490.00, 2, 130, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (93, 'Человек который принял жену за шляпу', 'Книга о неврологических историях', 680.00, 3, 23, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (94, 'USB хаб', 'Активный хаб на 4 порта USB 3.0', 890.00, 1, 147, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (95, 'Галстук классический', 'Шелковый галстук синего цвета', 1290.00, 2, 61, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (96, 'Бойцовский клуб', 'Роман Чака Паланика', 470.00, 3, 84, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (97, 'Аккумулятор повербанк', '20000 мАч быстрая зарядка 22.5 Вт', 2590.00, 1, 92, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (98, 'Перчатки кожаные', 'Мужские перчатки на подкладке', 1590.00, 2, 38, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (99, 'Собачье сердце', 'Повесть Михаила Булгакова', 320.00, 3, 105, '2026-03-31 19:18:10.968307');
INSERT INTO public.products VALUES (4, 'Джинсы классические синие', 'Прямые джинсы из плотного денима', 2990.00, 2, 77, '2026-03-31 19:18:10.968307');


--
-- TOC entry 3889 (class 0 OID 25104)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users VALUES (3, 'admin', '$2a$10$C6mpTlf7DhM0LAPSMhYp2e1OqN43WpsK1xReay1M70T9aJRhKzzay', 'admin@example.com', 'Администратор', '2026-04-17 14:22:05.860533');


--
-- TOC entry 3911 (class 0 OID 0)
-- Dependencies: 225
-- Name: cart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cart_id_seq', 6, true);


--
-- TOC entry 3912 (class 0 OID 0)
-- Dependencies: 221
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categories_id_seq', 3, true);


--
-- TOC entry 3913 (class 0 OID 0)
-- Dependencies: 229
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.order_items_id_seq', 2, true);


--
-- TOC entry 3914 (class 0 OID 0)
-- Dependencies: 227
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.orders_id_seq', 2, true);


--
-- TOC entry 3915 (class 0 OID 0)
-- Dependencies: 223
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.products_id_seq', 99, true);


--
-- TOC entry 3916 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- TOC entry 3727 (class 2606 OID 25166)
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);


--
-- TOC entry 3729 (class 2606 OID 25168)
-- Name: cart cart_user_id_product_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_user_id_product_id_key UNIQUE (user_id, product_id);


--
-- TOC entry 3723 (class 2606 OID 25132)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 3734 (class 2606 OID 25214)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3732 (class 2606 OID 25194)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- TOC entry 3725 (class 2606 OID 25148)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 3717 (class 2606 OID 25120)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3719 (class 2606 OID 25116)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3721 (class 2606 OID 25118)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 3730 (class 1259 OID 25225)
-- Name: idx_cart_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cart_user ON public.cart USING btree (user_id);


--
-- TOC entry 3736 (class 2606 OID 25174)
-- Name: cart cart_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 3737 (class 2606 OID 25169)
-- Name: cart cart_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3739 (class 2606 OID 25215)
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- TOC entry 3740 (class 2606 OID 25220)
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 3738 (class 2606 OID 25195)
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3735 (class 2606 OID 25149)
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL;


-- Completed on 2026-04-17 14:31:04 MSK

--
-- PostgreSQL database dump complete
--

\unrestrict JeiJcbXeqFa7RcH7P1PDVyUw2boTXsybWgi0dbIik2dFfnYmzIrpJyeu2QoehAE

