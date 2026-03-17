--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2026-02-25 15:36:43

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 236 (class 1255 OID 34277)
-- Name: add_new_ticket(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_new_ticket(IN seat_id_in integer, IN show_id_in integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF NOT EXISTS
	(SELECT show.*
	FROM show
	WHERE show.show_id = show_id_in)
	THEN raise exception 'Нет такого показа';
	END IF;
	
	IF NOT EXISTS
	(SELECT seat.*
	FROM seat
	WHERE seat.seat_id = seat_id_in)
	THEN raise exception 'Нет такого места';
	END IF;
	
	IF NOT EXISTS
	(SELECT seat.*
	 FROM show,seat
	 WHERE seat.seat_id = seat_id_in and
	 seat.hall_number = show.hall_number and
	 show.show_id = show_id_in
	)
	THEN raise exception 'Зал на данном показе не имеет места с таким id';
	END IF;
	
	IF EXISTS
	(SELECT ticket.*
	 FROM ticket
	 WHERE ticket.seat_id = seat_id_in and
	 ticket.show_id = show_id_in
	)
	THEN raise exception 'Билет для этого показа и на это место уже куплен';
	END IF;
	
	INSERT into ticket(seat_id,show_id,ticket_result_price)
	VALUES(seat_id_in,show_id_in,0);
	
END;
$$;


ALTER PROCEDURE public.add_new_ticket(IN seat_id_in integer, IN show_id_in integer) OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 34278)
-- Name: calculate_final_cost(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calculate_final_cost() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE ticket
	SET ticket_result_price = 
	(
		SELECT S.show_base_price
		FROM ticket T INNER JOIN
		show S on S.show_id = T.show_id
		WHERE NEW.ticket_number = T.ticket_number
	)*
	(
		SELECT H.hall_coefficient
		FROM ticket T INNER JOIN
		show S on S.show_id = T.show_id
		INNER JOIN
		hall H on H.hall_number = S.hall_number
		WHERE NEW.ticket_number = T.ticket_number
	)
	+
	(
		SELECT S.show_base_price
		FROM ticket T INNER JOIN
		show S on S.show_id = T.show_id
		WHERE NEW.ticket_number = T.ticket_number
	)
	*
	(
		SELECT S.seat_coefficient
		FROM ticket T 
		inner join
		seat S on T.seat_id = S.seat_id
		WHERE NEW.ticket_number = T.ticket_number
	)
	-
	(
		SELECT S.show_base_price
		FROM ticket T INNER JOIN
		show S on S.show_id = T.show_id
		WHERE NEW.ticket_number = T.ticket_number
	)
	WHERE NEW.ticket_number = ticket.ticket_number;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.calculate_final_cost() OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 34279)
-- Name: restrict_adding_same_seat(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.restrict_adding_same_seat() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF EXISTS
	(SELECT 
	FROM seat S
	WHERE NEW.seat_id != S.seat_id and
	NEW.hall_number = S.hall_number and
	NEW.seat_number = S.seat_number and
	NEW.seat_row_number = S.seat_row_number)
	THEN
		raise exception 'Уже существует такое место';
	ELSE
		RETURN NEW;	
	END IF;
END;
$$;


ALTER FUNCTION public.restrict_adding_same_seat() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 235 (class 1259 OID 34460)
-- Name: account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account (
    password character varying,
    role character varying,
    id integer NOT NULL,
    login character varying
);


ALTER TABLE public.account OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 34280)
-- Name: acting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.acting (
    film_id integer NOT NULL,
    actor_id integer NOT NULL
);


ALTER TABLE public.acting OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 34283)
-- Name: actor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actor (
    actor_id integer NOT NULL,
    actor_name_and_surname character varying(64) NOT NULL
);


ALTER TABLE public.actor OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 34286)
-- Name: actor_actor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.actor_actor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.actor_actor_id_seq OWNER TO postgres;

--
-- TOC entry 4942 (class 0 OID 0)
-- Dependencies: 217
-- Name: actor_actor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.actor_actor_id_seq OWNED BY public.actor.actor_id;


--
-- TOC entry 218 (class 1259 OID 34287)
-- Name: contained; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contained (
    film_id integer NOT NULL,
    genre_name character varying(32) NOT NULL
);


ALTER TABLE public.contained OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 34290)
-- Name: country; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.country (
    country_name character varying(64) NOT NULL
);


ALTER TABLE public.country OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 34293)
-- Name: direct; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.direct (
    film_id integer NOT NULL,
    director_id integer NOT NULL
);


ALTER TABLE public.direct OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 34296)
-- Name: director; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.director (
    director_id integer NOT NULL,
    director_name_and_surname character varying(64) NOT NULL
);


ALTER TABLE public.director OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 34299)
-- Name: director_director_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.director_director_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.director_director_id_seq OWNER TO postgres;

--
-- TOC entry 4943 (class 0 OID 0)
-- Dependencies: 222
-- Name: director_director_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.director_director_id_seq OWNED BY public.director.director_id;


--
-- TOC entry 223 (class 1259 OID 34300)
-- Name: film; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.film (
    film_id integer NOT NULL,
    film_name character varying(128) NOT NULL,
    film_world_premiere_date date NOT NULL,
    film_duration integer NOT NULL,
    film_description text NOT NULL,
    film_age_rating integer,
    film_image_path character varying(128)
);


ALTER TABLE public.film OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 34305)
-- Name: film_film_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.film_film_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.film_film_id_seq OWNER TO postgres;

--
-- TOC entry 4944 (class 0 OID 0)
-- Dependencies: 224
-- Name: film_film_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.film_film_id_seq OWNED BY public.film.film_id;


--
-- TOC entry 225 (class 1259 OID 34306)
-- Name: genre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genre (
    genre_name character varying(32) NOT NULL
);


ALTER TABLE public.genre OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 34309)
-- Name: hall; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hall (
    hall_number integer NOT NULL,
    hall_type character varying(32) NOT NULL,
    hall_coefficient double precision NOT NULL
);


ALTER TABLE public.hall OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 34312)
-- Name: hall_hall_number_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hall_hall_number_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hall_hall_number_seq OWNER TO postgres;

--
-- TOC entry 4945 (class 0 OID 0)
-- Dependencies: 227
-- Name: hall_hall_number_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hall_hall_number_seq OWNED BY public.hall.hall_number;


--
-- TOC entry 228 (class 1259 OID 34313)
-- Name: location_of_studio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_of_studio (
    film_id integer NOT NULL,
    country_name character varying(64) NOT NULL
);


ALTER TABLE public.location_of_studio OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 34316)
-- Name: seat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seat (
    seat_id integer NOT NULL,
    hall_number integer NOT NULL,
    seat_coefficient double precision NOT NULL,
    seat_number integer NOT NULL,
    seat_row_number integer NOT NULL
);


ALTER TABLE public.seat OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 34319)
-- Name: seat_seat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seat_seat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seat_seat_id_seq OWNER TO postgres;

--
-- TOC entry 4946 (class 0 OID 0)
-- Dependencies: 230
-- Name: seat_seat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seat_seat_id_seq OWNED BY public.seat.seat_id;


--
-- TOC entry 231 (class 1259 OID 34320)
-- Name: show; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.show (
    show_id integer NOT NULL,
    hall_number integer NOT NULL,
    film_id integer NOT NULL,
    show_base_price numeric NOT NULL,
    show_duration integer NOT NULL,
    show_datetime timestamp without time zone NOT NULL
);


ALTER TABLE public.show OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 34325)
-- Name: show_show_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.show_show_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.show_show_id_seq OWNER TO postgres;

--
-- TOC entry 4947 (class 0 OID 0)
-- Dependencies: 232
-- Name: show_show_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.show_show_id_seq OWNED BY public.show.show_id;


--
-- TOC entry 233 (class 1259 OID 34326)
-- Name: ticket; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ticket (
    ticket_number integer NOT NULL,
    seat_id integer NOT NULL,
    show_id integer NOT NULL,
    ticket_result_price numeric NOT NULL
);


ALTER TABLE public.ticket OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 34331)
-- Name: ticket_ticket_number_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ticket_ticket_number_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ticket_ticket_number_seq OWNER TO postgres;

--
-- TOC entry 4948 (class 0 OID 0)
-- Dependencies: 234
-- Name: ticket_ticket_number_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ticket_ticket_number_seq OWNED BY public.ticket.ticket_number;


--
-- TOC entry 4695 (class 2604 OID 34332)
-- Name: actor actor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actor ALTER COLUMN actor_id SET DEFAULT nextval('public.actor_actor_id_seq'::regclass);


--
-- TOC entry 4696 (class 2604 OID 34333)
-- Name: director director_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.director ALTER COLUMN director_id SET DEFAULT nextval('public.director_director_id_seq'::regclass);


--
-- TOC entry 4697 (class 2604 OID 34334)
-- Name: film film_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.film ALTER COLUMN film_id SET DEFAULT nextval('public.film_film_id_seq'::regclass);


--
-- TOC entry 4698 (class 2604 OID 34335)
-- Name: hall hall_number; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hall ALTER COLUMN hall_number SET DEFAULT nextval('public.hall_hall_number_seq'::regclass);


--
-- TOC entry 4699 (class 2604 OID 34336)
-- Name: seat seat_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seat ALTER COLUMN seat_id SET DEFAULT nextval('public.seat_seat_id_seq'::regclass);


--
-- TOC entry 4700 (class 2604 OID 34337)
-- Name: show show_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.show ALTER COLUMN show_id SET DEFAULT nextval('public.show_show_id_seq'::regclass);


--
-- TOC entry 4701 (class 2604 OID 34338)
-- Name: ticket ticket_number; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket ALTER COLUMN ticket_number SET DEFAULT nextval('public.ticket_ticket_number_seq'::regclass);


--
-- TOC entry 4936 (class 0 OID 34460)
-- Dependencies: 235
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account (password, role, id, login) FROM stdin;
123	2	1	admin
123	1	2	director
123	3	3	worker
\.


--
-- TOC entry 4916 (class 0 OID 34280)
-- Dependencies: 215
-- Data for Name: acting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.acting (film_id, actor_id) FROM stdin;
1	3
3	11
5	12
4	8
15	2
15	3
14	8
12	7
3	9
7	7
17	17
17	38
16	4
1	2
2	3
3	3
4	4
5	5
7	37
8	36
9	35
10	34
11	33
12	32
13	31
14	30
15	29
16	24
17	23
18	22
19	21
20	17
\.


--
-- TOC entry 4917 (class 0 OID 34283)
-- Dependencies: 216
-- Data for Name: actor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.actor (actor_id, actor_name_and_surname) FROM stdin;
2	Тесса Томпсон
3	Марго Роби
4	Дуэйн Джонсон
6	Оливия Кук
7	Том Круз
8	Том Хэнкс
9	Кристина Хендрикс
10	Алисия Викандер
11	Бри Ларсон
12	Элизабет Мосс
13	Эмили Блант
14	Том Харди
15	Скарлетт Йоханссон
16	Крис Пратт
17	Джош Бролин
18	Джон Красински
19	Натали Дормер
20	Энн Хэтэуэй
21	Ванесса Кирби
22	Эмилия Кларк
23	Сирша Роман
24	Харисон Форд
25	Дженнифер Лоуренс
26	Роберт Дауни-младший
27	Том Холланд
28	Райан Рейнольдс
29	Бенедикт Камбербэтч
30	Киану Ривз
31	Эмма Стоун
32	Крис Пайн
33	Зак Эфрон
34	Джеймс Макэвой
35	Кира Найтли
36	Джейк Джилленхол
37	Мэтт Деймон
38	Хью Джекман
5	Эмми Адамс
1	Райан Гослинг
\.


--
-- TOC entry 4919 (class 0 OID 34287)
-- Dependencies: 218
-- Data for Name: contained; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contained (film_id, genre_name) FROM stdin;
1	Драма
2	Комедия
3	Ужасы
4	Комедия
5	Комедия
7	Драма
8	Комедия
9	Драма
10	Комедия
11	Детектив
12	Ужасы
13	Мистика
14	Триллер
15	Детектив
16	Мистика
17	Военное кино
18	Драма
19	Боевик
20	Боевик
21	Триллер
1	Триллер
2	Триллер
3	Триллер
4	Боевик
5	Боевик
7	Боевик
8	Триллер
9	Триллер
22	Боевик
\.


--
-- TOC entry 4920 (class 0 OID 34290)
-- Dependencies: 219
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.country (country_name) FROM stdin;
Россия
США
Германия
\.


--
-- TOC entry 4921 (class 0 OID 34293)
-- Dependencies: 220
-- Data for Name: direct; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.direct (film_id, director_id) FROM stdin;
2	2
3	3
4	4
5	5
7	7
8	8
9	9
10	10
11	9
12	8
13	7
14	6
15	5
16	4
17	3
18	2
20	5
1	10
4	2
8	3
12	4
11	5
16	6
20	7
19	8
18	9
17	10
20	6
\.


--
-- TOC entry 4922 (class 0 OID 34296)
-- Dependencies: 221
-- Data for Name: director; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.director (director_id, director_name_and_surname) FROM stdin;
2	Стивен Спилберг
3	Джеймс Кэмерон
4	Квентин Тарантино
5	Дэвид Финчер
6	Кристофер Нолан
7	Гильермо Дель Торо
8	Ридли Скотт
9	Питер Джексон
10	Тим Бёртон
\.


--
-- TOC entry 4924 (class 0 OID 34300)
-- Dependencies: 223
-- Data for Name: film; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.film (film_id, film_name, film_world_premiere_date, film_duration, film_description, film_age_rating, film_image_path) FROM stdin;
1	Лучше без меня	2021-01-01	189	Жена уходит от мужа, оставив ему сына. Мужчине придётся впервые по-настоящему взрослеть — вместе с ребёнком.	18	01_Лучше без меня.jpg
2	Когда часы 12 бьют	2020-01-01	20	Когда часы двенадцать бьют, все ждут исполнения желаний и новогодних чудес. О том же мечтал и менеджер Гришенька, опоздав к бою курантов и возвращаясь к жене Настеньке далеко за полночь. Но случилось чудо совсем другого толка\n	18	02_Когда часы 12 бьют.jpg
3	На краю детства	2015-01-01	142	Чтобы обеспечить питанием себя и свою младшую сестру в блокадном Ленинграде, а также не попасть в детский дом, как беспризорники, лишившиеся опекунства, юная Тамара решается устроиться работать на почту. Однако чтобы получить работу, девочке нужно показать себя: в условиях голода и холода разнеси пять писем по пяти адресам. Вскоре Тамара понимает насколько это ответственная работа и, что каждое письмо может изменить жизнь адресата\n	16	03_На краю детства.jpg
4	Поводок	2011-01-01	65	Подростковая радиовикторина с миллионным призом становится точкой пересечения судеб нескольких подростков, каждому из которых предстоит сделать выбор между выгодой и честностью\n	16	04_Поводок.jpg
5	Мафия	2024-01-01	12	Начальник фирмы с помощью игры в «Мафию» с подчиненными хочет выяснить, кто в компании ворует из бюджета. Но в какой-то момент невинная игра раскрывает и другие скелеты из шкафов.\n	16	05_Мафия.jpg
7	Воля	2026-01-01	35	Убежденный христианин отказывается исполнить последнюю волю погибшего сына — развеять его прах над Волгой, испытывает кризис веры, который заставляет его усомниться в ней\n 	12	06_Воля.jpg
8	Киноязык эпохи: Борис Барнет	2024-01-01	50	О жизни и творчестве Бориса Васильевича Барнета.	0	07_Киноязык эпохи Борис Барнет.jpg
9	Убеги, если сможешь	2024-01-01	11	Владелица логистической компании Алена ведёт изматывающую борьбу с влиятельным конкурентом. Когда её бизнес оказывается на грани краха из-за корпоративного саботажа, одна напряжённая ночь за рулём становится для неё проверкой на прочность, где цена ошибки — всё.\n 	16	08_Убеги если сможешь.jpg
10	Нима-Цырен	2017-01-01	17	Начало 1970-х годов, бурятская деревня. Жизнь Балмы остановилась, когда ее сын ушел на войну. С тех пор она только во снах видит своего ребенка и по-прежнему ждет его возвращения.	0	09_Нима-Цырен.jpg
11	Монах и лица	2023-01-01	154	Монаху приходится находить общий язык с людьми разного возраста и социального статуса, которых он исповедует в течение дня, от бывшего заключенного до депутата государственной думы.	0	10_Монах и лица.jpg
12	Эхо вчерашних нот	2001-01-01	5	Уставший от творческого кризиса и личной драмы рок-музыкант погружается в пучину саморазрушения. Приезд сестры и поддержка любимой женщины дают ему шанс найти в себе силы вернуться к жизни и музыке.	0	11_Эхо вчерашних нот.jpg
14	Стадия принятия	2022-01-01	10	Молодая девушка, заболевает раком, становится обузой для своей матери и теряет силы и надежду бороться с тяжёлым диагнозом, который убивает её по минутам. Любящая мать делает всё, для выздоровления дочери, в том числе подталкивает её на нелёгкий поступок, после которого девушка кардинально меняется.	16	13_Стадия принятия.jpg
20	Следы	2026-01-01	98	О человеке и его собаке на зимней тропе.	12	19_Следы.jpg
13	Кошмар закончится сегодня	2026-01-01	45	Олег Викторович — предприниматель средних лет, имеет успешный бизнес, требующий неусыпного внимания, красавицу жену. Сбросить заботы на управляющего ему мешает недоверие к людям, которое он успешно скрывает за фасадом добродушного, но справедливого руководителя. Накопленная усталость даёт о себе знать. На него сыпятся неудачи. На это накладывается начинающийся конфликт с сыном и размолвки с женой. Наступает полоса неудач.Олег начинает посещать психолога. 	6	12_Кошмар закончится сегодня.jpg
15	Срок годности	2026-01-01	21	Ольга — взрослая, красивая женщина, успешный врач. Она живёт по строгому правилу — никаких ошибок, только идеальность во всём: во внешности, в поведении, в работе и в отношениях. Свою девственность она бережёт, как основную ценность, уверенная, что настоящий, «идеальный»	12	14_Срок годности.jpg
18	Вечно эта любовь!	2026-01-01	68	Девушка влюбляется в своего ангела-хранителя, который только что стал человеком. Мужчина отправляет на свидание своего клона-робота, но тот влюбляется в его девушку. Ради любви к юной красавице внук готов отправить бабушку на тот свет. Четыре женщины так любят одного мужчину, что готовы его убить. В отношения бабушки и внучки вмешивается говорящий робот-пылесос\n 	12	17_Вечно эта любовь.jpg
16	Королев	2026-01-11	72	Зритель заново открывает для себя Сергея Королева — человека, который был и остается главным конструктором не только космических кораблей, но и самой мечты о космосе. Именно он сконструировал первый в СССР безмоторный самолет и создал первую советскую межконтинентальную баллистическую ракету, запустил в космос первый искусственный спутник Земли и отправил космические аппараты на поверхность Луны, руководил стартом космического корабля <Восток> с Юрием Гагариным на борту и спроектировал прототип многоместного пилотируемого корабля <Союз>. Как человек, прошедший ГУЛАГ и <долину смерти>, смог за 20 лет превратить СССР в ведущую космическую державу? Почему мир так и не узнал создателя первого спутника и космического корабля <Восток>? К достижению какой цели всю жизнь стремился ученый, и почему так и не смог ее осуществить?\n 	0	15_Королев.jpg
17	Ломоносов	2026-02-08	72	Его считали дебоширом, а он с кулаками защищал российскую науку. Он называл себя продолжателем дел Петра Первого, но присягнул на верность европейскому королю. Его хотели предать анафеме, но похоронили рядом с царями на церковной земле. Он проложил маршрут через русскую Арктику, но его картами воспользовались шведы. Он изучал мифы и сказания, чтобы открыть людям тайны человеческого организма, природы и космоса. Михаил Васильевич Ломоносов навсегда изменил историю России и отечественной науки. Именно он стал первым русским академиком, разработал проект Московского государственного университета, издал книгу <Российская грамматика>, создал прибор ночного видения и открыл атмосферу Венеры. Идеи Ломоносова в физике, химии, филологии, истории и географии опередили время. Малоизвестные страницы жизни Ломоносова: его службу в прусской армии, объявление в международный розыск, историю утраченных научных трудов и секретную карту арктического похода. О том, как наследие ученого продолжает влиять на современность, расскажут актер Михаил Горевой и эксперты в области истории, химии, филологии, географии, и экономики.\n	12	16_Ломоносов.jpg
19	Друзья. История в усадьбе	2024-01-01	14	Молодые люди отправляются на экскурсию в старинную усадьбу. Внезапно экскурсовод пропадает. А еще, кажется, в здании обитает призрак.	16	18_Друзья История в усадьбе.jpg
21	Извеков	2026-01-01	28	Популярный актёр Извеков во время спектакля отказывается идти по сценарию и срывает постановку. Когда актёр приходит в сознание то обнаруживает себя в психиатрической больнице. Врачи констатируют, что, актёр в огромном количестве исполняемых им ролей потерял себя и на обращения к нему отвечает репликами из ролей. \\nВ тоже время группа кинематографистов осаждает заведующего психиатрическим отделением, на предмет досъёма фильма с Извековым, ведь осталась всего последняя сцена.	16	20_Извеков.jpg
22	Дело дрянь	2026-01-01	95	Саша и Серёга — обычные парни, которые решают взять судьбу в свои руки. Они открывают небольшое дело: занимаются электромонтажом и мелкосрочным ремонтом, честно зарабатывают на жизнь и строят планы на будущее. Однажды Саша случайно встречает старого друга — Кузова, за фасадом успешной жизни которого скрывается мрачная правда: он стал наркодилером. С этого момента перед Сашей встаёт непростой выбор.",\n	12	21_Дело дрянь.jpg
\.


--
-- TOC entry 4926 (class 0 OID 34306)
-- Dependencies: 225
-- Data for Name: genre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genre (genre_name) FROM stdin;
Драма
Фантастика
Ужасы
Фаэнтези
Триллер
Криминал
Мистика
Мелодрама
Боевик
Комедия
Военное кино
Детектив
\.


--
-- TOC entry 4927 (class 0 OID 34309)
-- Dependencies: 226
-- Data for Name: hall; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hall (hall_number, hall_type, hall_coefficient) FROM stdin;
1	DBOX	1.3
2	IMAX	1.5
3	IMAX	1.5
4	3D	1.2
5	2D	1
6	IMAX	1.5
7	2D	1
8	IMAX	1.5
9	IMAX	1.5
10	DBOX	1.3
11	3D	1
12	2D	1
\.


--
-- TOC entry 4929 (class 0 OID 34313)
-- Dependencies: 228
-- Data for Name: location_of_studio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_of_studio (film_id, country_name) FROM stdin;
1	США
2	США
3	США
4	США
5	США
\.


--
-- TOC entry 4930 (class 0 OID 34316)
-- Dependencies: 229
-- Data for Name: seat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seat (seat_id, hall_number, seat_coefficient, seat_number, seat_row_number) FROM stdin;
12	1	1.2	1	2
13	1	1	3	1
1	1	1.1	2	2
15	3	1	1	1
14	3	1.1	2	1
2	1	1	1	2
3	1	1.2	3	1
4	1	1.2	2	1
5	1	1	1	1
6	2	1	2	2
7	2	1	1	2
8	2	1	3	1
9	2	1.2	2	1
10	2	1.2	1	1
24	1	1	3	3
23	1	1	13	13
\.


--
-- TOC entry 4932 (class 0 OID 34320)
-- Dependencies: 231
-- Data for Name: show; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.show (show_id, hall_number, film_id, show_base_price, show_duration, show_datetime) FROM stdin;
1	3	10	300.00	175	2026-02-26 21:00:00
2	3	9	350.00	170	2026-02-25 21:00:00
3	3	8	150.00	160	2026-02-25 22:00:00
4	3	7	300.00	180	2026-02-26 21:00:00
6	2	5	250.00	200	2026-02-26 12:00:00
7	2	4	300.00	160	2026-02-25 12:00:00
8	1	3	250.00	190	2026-02-26 13:00:00
9	1	2	300.00	180	2026-02-27 22:00:00
10	1	1	200.00	300	2026-02-27 09:00:00
11	3	8	300.00	175	2026-02-25 11:00:00
12	3	8	350.00	200	2026-02-28 14:00:00
13	3	10	322	175	2026-02-28 21:00:00
\.


--
-- TOC entry 4934 (class 0 OID 34326)
-- Dependencies: 233
-- Data for Name: ticket; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ticket (ticket_number, seat_id, show_id, ticket_result_price) FROM stdin;
3	8	8	2222.00
69	1	1	480.00
1	14	1	1.00
71	15	1	450.00
72	23	8	325.00
4	7	7	1.00
5	6	6	1.00
7	4	4	1.00
8	3	3	1.00
9	2	2	1.00
53	1	2	1.00
2	1	9	1.00
74	5	9	390
75	4	9	450
73	23	9	390
76	13	9	390
77	10	7	510
78	9	7	510
\.


--
-- TOC entry 4949 (class 0 OID 0)
-- Dependencies: 217
-- Name: actor_actor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.actor_actor_id_seq', 38, true);


--
-- TOC entry 4950 (class 0 OID 0)
-- Dependencies: 222
-- Name: director_director_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.director_director_id_seq', 21, true);


--
-- TOC entry 4951 (class 0 OID 0)
-- Dependencies: 224
-- Name: film_film_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.film_film_id_seq', 27, true);


--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 227
-- Name: hall_hall_number_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hall_hall_number_seq', 10, true);


--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 230
-- Name: seat_seat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seat_seat_id_seq', 24, true);


--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 232
-- Name: show_show_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.show_show_id_seq', 13, true);


--
-- TOC entry 4955 (class 0 OID 0)
-- Dependencies: 234
-- Name: ticket_ticket_number_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ticket_ticket_number_seq', 78, true);


--
-- TOC entry 4757 (class 2606 OID 34468)
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- TOC entry 4706 (class 2606 OID 34340)
-- Name: acting pk_acting; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acting
    ADD CONSTRAINT pk_acting PRIMARY KEY (film_id, actor_id);


--
-- TOC entry 4710 (class 2606 OID 34342)
-- Name: actor pk_actor; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actor
    ADD CONSTRAINT pk_actor PRIMARY KEY (actor_id);


--
-- TOC entry 4715 (class 2606 OID 34344)
-- Name: contained pk_contained; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contained
    ADD CONSTRAINT pk_contained PRIMARY KEY (film_id, genre_name);


--
-- TOC entry 4718 (class 2606 OID 34346)
-- Name: country pk_country; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT pk_country PRIMARY KEY (country_name);


--
-- TOC entry 4723 (class 2606 OID 34348)
-- Name: direct pk_direct; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.direct
    ADD CONSTRAINT pk_direct PRIMARY KEY (film_id, director_id);


--
-- TOC entry 4727 (class 2606 OID 34350)
-- Name: director pk_director; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.director
    ADD CONSTRAINT pk_director PRIMARY KEY (director_id);


--
-- TOC entry 4730 (class 2606 OID 34352)
-- Name: film pk_film; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.film
    ADD CONSTRAINT pk_film PRIMARY KEY (film_id);


--
-- TOC entry 4733 (class 2606 OID 34354)
-- Name: genre pk_genre; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT pk_genre PRIMARY KEY (genre_name);


--
-- TOC entry 4736 (class 2606 OID 34356)
-- Name: hall pk_hall; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hall
    ADD CONSTRAINT pk_hall PRIMARY KEY (hall_number);


--
-- TOC entry 4741 (class 2606 OID 34358)
-- Name: location_of_studio pk_location_of_studio; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_of_studio
    ADD CONSTRAINT pk_location_of_studio PRIMARY KEY (film_id, country_name);


--
-- TOC entry 4743 (class 2606 OID 34360)
-- Name: seat pk_seat; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seat
    ADD CONSTRAINT pk_seat PRIMARY KEY (seat_id);


--
-- TOC entry 4749 (class 2606 OID 34362)
-- Name: show pk_show; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.show
    ADD CONSTRAINT pk_show PRIMARY KEY (show_id);


--
-- TOC entry 4754 (class 2606 OID 34364)
-- Name: ticket pk_ticket; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT pk_ticket PRIMARY KEY (ticket_number);


--
-- TOC entry 4702 (class 1259 OID 34365)
-- Name: acting2_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX acting2_fk ON public.acting USING btree (actor_id);


--
-- TOC entry 4703 (class 1259 OID 34366)
-- Name: acting_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX acting_fk ON public.acting USING btree (film_id);


--
-- TOC entry 4704 (class 1259 OID 34367)
-- Name: acting_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX acting_pk ON public.acting USING btree (film_id, actor_id);


--
-- TOC entry 4707 (class 1259 OID 34368)
-- Name: actor_name_surname_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX actor_name_surname_index ON public.actor USING btree (actor_name_and_surname);


--
-- TOC entry 4708 (class 1259 OID 34369)
-- Name: actor_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX actor_pk ON public.actor USING btree (actor_id);


--
-- TOC entry 4711 (class 1259 OID 34370)
-- Name: contained2_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX contained2_fk ON public.contained USING btree (genre_name);


--
-- TOC entry 4712 (class 1259 OID 34371)
-- Name: contained_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX contained_fk ON public.contained USING btree (film_id);


--
-- TOC entry 4713 (class 1259 OID 34372)
-- Name: contained_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX contained_pk ON public.contained USING btree (film_id, genre_name);


--
-- TOC entry 4751 (class 1259 OID 34373)
-- Name: contains_info_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX contains_info_fk ON public.ticket USING btree (show_id);


--
-- TOC entry 4716 (class 1259 OID 34374)
-- Name: country_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX country_pk ON public.country USING btree (country_name);


--
-- TOC entry 4746 (class 1259 OID 34375)
-- Name: demonstrate_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX demonstrate_fk ON public.show USING btree (film_id);


--
-- TOC entry 4719 (class 1259 OID 34376)
-- Name: direct2_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX direct2_fk ON public.direct USING btree (director_id);


--
-- TOC entry 4720 (class 1259 OID 34377)
-- Name: direct_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX direct_fk ON public.direct USING btree (film_id);


--
-- TOC entry 4721 (class 1259 OID 34378)
-- Name: direct_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX direct_pk ON public.direct USING btree (film_id, director_id);


--
-- TOC entry 4724 (class 1259 OID 34379)
-- Name: director_name_surname_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX director_name_surname_index ON public.director USING btree (director_name_and_surname);


--
-- TOC entry 4725 (class 1259 OID 34380)
-- Name: director_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX director_pk ON public.director USING btree (director_id);


--
-- TOC entry 4728 (class 1259 OID 34381)
-- Name: film_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX film_pk ON public.film USING btree (film_id);


--
-- TOC entry 4731 (class 1259 OID 34382)
-- Name: genre_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX genre_pk ON public.genre USING btree (genre_name);


--
-- TOC entry 4734 (class 1259 OID 34383)
-- Name: hall_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX hall_pk ON public.hall USING btree (hall_number);


--
-- TOC entry 4747 (class 1259 OID 34384)
-- Name: happens_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX happens_fk ON public.show USING btree (hall_number);


--
-- TOC entry 4752 (class 1259 OID 34385)
-- Name: have_info_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX have_info_fk ON public.ticket USING btree (seat_id);


--
-- TOC entry 4737 (class 1259 OID 34386)
-- Name: location_of_studio2_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX location_of_studio2_fk ON public.location_of_studio USING btree (country_name);


--
-- TOC entry 4738 (class 1259 OID 34387)
-- Name: location_of_studio_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX location_of_studio_fk ON public.location_of_studio USING btree (film_id);


--
-- TOC entry 4739 (class 1259 OID 34388)
-- Name: location_of_studio_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX location_of_studio_pk ON public.location_of_studio USING btree (film_id, country_name);


--
-- TOC entry 4744 (class 1259 OID 34389)
-- Name: seat_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX seat_pk ON public.seat USING btree (seat_id);


--
-- TOC entry 4750 (class 1259 OID 34390)
-- Name: show_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX show_pk ON public.show USING btree (show_id);


--
-- TOC entry 4745 (class 1259 OID 34391)
-- Name: take_place_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX take_place_fk ON public.seat USING btree (hall_number);


--
-- TOC entry 4755 (class 1259 OID 34392)
-- Name: ticket_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ticket_pk ON public.ticket USING btree (ticket_number);


--
-- TOC entry 4771 (class 2620 OID 34393)
-- Name: seat add_new_seat; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER add_new_seat AFTER INSERT OR UPDATE OF seat_number, seat_row_number, hall_number ON public.seat FOR EACH ROW EXECUTE FUNCTION public.restrict_adding_same_seat();


--
-- TOC entry 4772 (class 2620 OID 34394)
-- Name: ticket add_new_ticket; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER add_new_ticket AFTER INSERT ON public.ticket FOR EACH ROW EXECUTE FUNCTION public.calculate_final_cost();


--
-- TOC entry 4758 (class 2606 OID 34395)
-- Name: acting fk_acting_acting2_actor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acting
    ADD CONSTRAINT fk_acting_acting2_actor FOREIGN KEY (actor_id) REFERENCES public.actor(actor_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4759 (class 2606 OID 34400)
-- Name: acting fk_acting_acting_film; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acting
    ADD CONSTRAINT fk_acting_acting_film FOREIGN KEY (film_id) REFERENCES public.film(film_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4760 (class 2606 OID 34405)
-- Name: contained fk_containe_contained_film; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contained
    ADD CONSTRAINT fk_containe_contained_film FOREIGN KEY (film_id) REFERENCES public.film(film_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4761 (class 2606 OID 34410)
-- Name: contained fk_containe_contained_genre; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contained
    ADD CONSTRAINT fk_containe_contained_genre FOREIGN KEY (genre_name) REFERENCES public.genre(genre_name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4762 (class 2606 OID 34415)
-- Name: direct fk_direct_direct2_director; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.direct
    ADD CONSTRAINT fk_direct_direct2_director FOREIGN KEY (director_id) REFERENCES public.director(director_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4763 (class 2606 OID 34420)
-- Name: direct fk_direct_direct_film; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.direct
    ADD CONSTRAINT fk_direct_direct_film FOREIGN KEY (film_id) REFERENCES public.film(film_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4764 (class 2606 OID 34425)
-- Name: location_of_studio fk_location_location__country; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_of_studio
    ADD CONSTRAINT fk_location_location__country FOREIGN KEY (country_name) REFERENCES public.country(country_name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4765 (class 2606 OID 34430)
-- Name: location_of_studio fk_location_location__film; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_of_studio
    ADD CONSTRAINT fk_location_location__film FOREIGN KEY (film_id) REFERENCES public.film(film_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4766 (class 2606 OID 34435)
-- Name: seat fk_seat_take_plac_hall; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seat
    ADD CONSTRAINT fk_seat_take_plac_hall FOREIGN KEY (hall_number) REFERENCES public.hall(hall_number) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4767 (class 2606 OID 34440)
-- Name: show fk_show_demonstra_film; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.show
    ADD CONSTRAINT fk_show_demonstra_film FOREIGN KEY (film_id) REFERENCES public.film(film_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4768 (class 2606 OID 34445)
-- Name: show fk_show_happens_hall; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.show
    ADD CONSTRAINT fk_show_happens_hall FOREIGN KEY (hall_number) REFERENCES public.hall(hall_number) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4769 (class 2606 OID 34450)
-- Name: ticket fk_ticket_contains__show; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk_ticket_contains__show FOREIGN KEY (show_id) REFERENCES public.show(show_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4770 (class 2606 OID 34455)
-- Name: ticket fk_ticket_have_info_seat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk_ticket_have_info_seat FOREIGN KEY (seat_id) REFERENCES public.seat(seat_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


-- Completed on 2026-02-25 15:36:44

--
-- PostgreSQL database dump complete
--

