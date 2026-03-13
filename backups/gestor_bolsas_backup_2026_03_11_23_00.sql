--
-- PostgreSQL database dump
--

\restrict CRhE8xaPZ6uZGoE8BkG27INxaRubWXxGWlUIXfKairjmJpJGk16uA2BbV3jhQHS

-- Dumped from database version 18.2
-- Dumped by pg_dump version 18.2

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
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    whatsapp character varying(20) NOT NULL,
    archivo_codigo character varying(20) NOT NULL,
    direccion text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    localidad text
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- Name: clientes_codigo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clientes_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clientes_codigo_seq OWNER TO postgres;

--
-- Name: clientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clientes_id_seq OWNER TO postgres;

--
-- Name: clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;


--
-- Name: config_theme; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.config_theme (
    id integer NOT NULL,
    primary_color text,
    primary_hover text,
    bg_color text,
    card_color text,
    table_header text,
    estado_comprar text,
    estado_sena text,
    estado_terminado text,
    estado_entregado text
);


ALTER TABLE public.config_theme OWNER TO postgres;

--
-- Name: config_theme_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.config_theme_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.config_theme_id_seq OWNER TO postgres;

--
-- Name: config_theme_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.config_theme_id_seq OWNED BY public.config_theme.id;


--
-- Name: meses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meses (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date,
    activo boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.meses OWNER TO postgres;

--
-- Name: meses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.meses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.meses_id_seq OWNER TO postgres;

--
-- Name: meses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.meses_id_seq OWNED BY public.meses.id;


--
-- Name: pedido_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido_items (
    id integer NOT NULL,
    pedido_id integer,
    producto_id integer,
    cantidad integer,
    color_bolsa text,
    color_estampa text,
    doble_estampa boolean DEFAULT false,
    precio_item numeric,
    costo_item numeric,
    ganancia_item numeric
);


ALTER TABLE public.pedido_items OWNER TO postgres;

--
-- Name: pedido_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedido_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedido_items_id_seq OWNER TO postgres;

--
-- Name: pedido_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedido_items_id_seq OWNED BY public.pedido_items.id;


--
-- Name: pedidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedidos (
    id integer NOT NULL,
    cliente_id integer,
    fecha date,
    envio boolean DEFAULT false,
    fecha_entrega date,
    total_general numeric,
    sena numeric,
    restante numeric,
    estado text DEFAULT 'pendiente'::text
);


ALTER TABLE public.pedidos OWNER TO postgres;

--
-- Name: pedidos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedidos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedidos_id_seq OWNER TO postgres;

--
-- Name: pedidos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedidos_id_seq OWNED BY public.pedidos.id;


--
-- Name: precios_pack; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.precios_pack (
    id integer NOT NULL,
    producto_id integer,
    cantidad integer NOT NULL,
    precio_total numeric(10,2) NOT NULL,
    updated_at timestamp without time zone DEFAULT now(),
    costo_pack numeric
);


ALTER TABLE public.precios_pack OWNER TO postgres;

--
-- Name: precios_pack_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.precios_pack_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.precios_pack_id_seq OWNER TO postgres;

--
-- Name: precios_pack_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.precios_pack_id_seq OWNED BY public.precios_pack.id;


--
-- Name: productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productos (
    id integer NOT NULL,
    tamano character varying(50) CONSTRAINT "productos_tama¤o_not_null" NOT NULL,
    tipo_asa character varying(20) NOT NULL,
    precio_base numeric(10,2),
    activo boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    precio_venta_unitario numeric(10,2),
    costo_unitario numeric(10,2),
    costo_estampado_unitario numeric DEFAULT 50,
    precio_proveedor_unitario numeric
);


ALTER TABLE public.productos OWNER TO postgres;

--
-- Name: productos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.productos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.productos_id_seq OWNER TO postgres;

--
-- Name: productos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.productos_id_seq OWNED BY public.productos.id;


--
-- Name: ventas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ventas (
    id integer NOT NULL,
    fecha date NOT NULL,
    cliente_id integer,
    producto_id integer,
    cantidad integer NOT NULL,
    color_bolsa character varying(50),
    color_estampa character varying(50),
    doble_estampa boolean DEFAULT false,
    envio_domicilio boolean DEFAULT false,
    precio_final numeric(10,2) NOT NULL,
    sena numeric(10,2) DEFAULT 0,
    restante numeric(10,2),
    costo_total numeric(10,2),
    ganancia_total numeric(10,2),
    ganancia_taller numeric(10,2),
    ganancia_personal numeric(10,2),
    fecha_entrega date,
    factura boolean DEFAULT false,
    estado character varying(30) DEFAULT 'pendiente'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    arca boolean DEFAULT false,
    color_fila character varying(20),
    etapa character varying(20) DEFAULT 'comprar'::character varying,
    mes_id integer,
    envio_monto integer DEFAULT 0,
    codigo_seguimiento text
);


ALTER TABLE public.ventas OWNER TO postgres;

--
-- Name: ventas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ventas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ventas_id_seq OWNER TO postgres;

--
-- Name: ventas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ventas_id_seq OWNED BY public.ventas.id;


--
-- Name: clientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);


--
-- Name: config_theme id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config_theme ALTER COLUMN id SET DEFAULT nextval('public.config_theme_id_seq'::regclass);


--
-- Name: meses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meses ALTER COLUMN id SET DEFAULT nextval('public.meses_id_seq'::regclass);


--
-- Name: pedido_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_items ALTER COLUMN id SET DEFAULT nextval('public.pedido_items_id_seq'::regclass);


--
-- Name: pedidos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos ALTER COLUMN id SET DEFAULT nextval('public.pedidos_id_seq'::regclass);


--
-- Name: precios_pack id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.precios_pack ALTER COLUMN id SET DEFAULT nextval('public.precios_pack_id_seq'::regclass);


--
-- Name: productos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos ALTER COLUMN id SET DEFAULT nextval('public.productos_id_seq'::regclass);


--
-- Name: ventas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas ALTER COLUMN id SET DEFAULT nextval('public.ventas_id_seq'::regclass);


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientes (id, nombre, whatsapp, archivo_codigo, direccion, created_at, localidad) FROM stdin;
69	Navila Farias	11 6106-1346	CL-0059	\N	2026-03-10 13:26:30.882337	\N
70	Tacha	11 6761-6591	CL-0060	\N	2026-03-11 09:58:41.64409	\N
71	Jorgelina Mierke	9 3404 41-7419	CL-0061	\N	2026-03-11 12:59:09.874161	San Carlos Centro, provincia de Santa Fe
72	ThomateoFran	11 4022-3733	CL-0062	\N	2026-03-11 18:33:53.550909	\N
73	Carmen	 9 3869 60-7035	CL-0063	\N	2026-03-11 18:45:58.005361	Tucuman
18	Fedeex	11 6238-1269	CL-0008	\N	2026-02-28 00:12:16.381309	\N
19	Gaby Hijo	11 7050-6812	CL-0009	\N	2026-02-28 00:13:33.510714	\N
20	Brenda 3	11 4084-5546	CL-0010	\N	2026-02-28 00:14:05.077199	\N
21	Morena	11 4419-1129	CL-0011	\N	2026-02-28 00:14:25.156926	\N
22	Lourdes Lotito	11 2601-4346	CL-0012	\N	2026-02-28 00:14:45.798956	\N
23	Liam Babyshop	11 7036-8349	CL-0013	\N	2026-02-28 00:15:13.650695	\N
24	Uriel Jaime	11 7064-4644	CL-0014	\N	2026-02-28 00:15:36.614853	\N
25	Sofia Magali	11 5991-5890	CL-0015	\N	2026-02-28 00:16:05.592421	\N
26	Guapas	11 3342-5576	CL-0016	\N	2026-02-28 00:16:25.885976	\N
27	Beauty Mar	11 6251-8729	CL-0017	\N	2026-02-28 00:16:45.369827	\N
28	Johanna	11 2895-7593	CL-0018	\N	2026-02-28 00:17:30.864348	\N
29	DECOBA	11 6363-6355	CL-0019	\N	2026-02-28 00:17:48.785207	\N
30	Agus	11 6954-3392	CL-0020	\N	2026-02-28 00:18:13.305568	\N
31	Luisana	11 3420-8034	CL-0021	\N	2026-02-28 00:18:31.939681	\N
32	Mariel Tango	11 6802-1570	CL-0022	\N	2026-02-28 00:18:51.525075	\N
33	Bian	11 4062-4863	CL-0023	\N	2026-02-28 00:19:08.21514	\N
34	Ari	11 5807-3797	CL-0024	\N	2026-02-28 00:19:27.343975	\N
35	Renzo	11 5823-8118	CL-0025	\N	2026-02-28 00:19:45.642345	\N
36	Natalia	11 6866-5577	CL-0026	\N	2026-02-28 00:20:03.621176	\N
37	Yesica Acosta 	11 3002-4983	CL-0027	Prof. Antonio Marxer n°564	2026-02-28 20:36:45.062575	Monte grande 
38	ElectroDM	11 6478-1997	CL-0028	Calle 12 nro 4487	2026-03-04 23:55:58.502735	berazategui
39	Vero	11 2259-5833	CL-0029	\N	2026-03-04 23:56:35.376446	\N
40	Ambos Rose	11 2295-3485	CL-0030	\N	2026-03-04 23:57:15.408559	\N
41	Clara Mucho Ruido	11 6153-6270	CL-0031	\N	2026-03-04 23:57:35.442826	\N
42	Lu DOMUSTEC	11 6132-4348	CL-0032	\N	2026-03-04 23:57:55.975737	\N
43	Agustin Castro	11 3178-1487	CL-0033	\N	2026-03-04 23:58:28.715389	\N
44	Unica Boutique	9 2945 68-6283	CL-0034	\N	2026-03-08 11:59:20.506672	Pinamar
45	Evelin	 9 2227 47-0656	CL-0035	Alberdi 1480	2026-03-08 12:03:18.360075	Lobos cp7240
46	Lau	1169638663	CL-0036	Andrés baranda 1224	2026-03-08 12:06:19.328899	Quilmes
47	Mar	9 11 7103-0536	CL-0037	Homero 263	2026-03-08 12:09:03.635976	Lomas de Zamora
48	Rocio	9 11 5753-4401	CL-0038	\N	2026-03-08 12:11:11.239777	\N
49	Divain	9 2236 83-4989	CL-0039	\N	2026-03-08 12:13:10.595065	Mar del plata
50	Milu Lobos	11 6180-8047	CL-0040	\N	2026-03-08 12:14:19.380878	\N
51	Yanina	11 6850-5186	CL-0041	Mauricio Ravel 542	2026-03-08 12:15:57.906495	Temperley
52	Daniela	11 3063-5125	CL-0042	\N	2026-03-08 12:16:54.509191	\N
53	Pintitas	11 5702-8961	CL-0043	Lomas Valentinas 337 esq Republica Argentina 	2026-03-08 12:18:49.215153	Valentín Alsina
54	Super Posta	9 2215 86-8189	CL-0044	Av. 520 esquina 158	2026-03-08 12:21:23.160718	La plata
55	Lorena	 9 2983 56-0105	CL-0045	\N	2026-03-08 15:50:29.683403	Tres Arroyos
56	Antorena Jeans	9 3764 67-9829	CL-0046	\N	2026-03-08 20:36:00.97532	Posadas, Misiones.
57	Alondra	11 6309-6452	CL-0047	Calle 159a 3033	2026-03-08 22:12:44.143008	Berazategui
58	Carlitos Lujan	9 3512 03-9788	CL-0048	\N	2026-03-09 09:53:06.95642	Cordoba capital
59	Lykaena	11 3297-0592	CL-0049	Don segundo sombra 5702 esquina Isabel la católica	2026-03-09 10:37:02.292637	Paso del Rey
60	Sil	11 3261-8102	CL-0050	Santo Domingo 3900 (equina Bonavena)	2026-03-09 11:07:15.2176	Nueva Pompeya, Barrio comandante Espora.
61	Bendita Seas	 9 2314 62-6828	CL-0051	GENERAL PAZ 131	2026-03-09 12:40:50.901294	San Carlos de Bolivar
62	Loreley	9 2216 07-0471	CL-0052	calle 80 n 434 entre 3 y 4 villa elvira 	2026-03-09 13:13:05.534543	La Plata
63	Ramona	11 6433-1321	CL-0053	padilla 3030	2026-03-09 14:43:00.015203	Hurlingham
64	Jorgelina	 11 6844-3863	CL-0054	\N	2026-03-09 15:45:28.432994	Merlo
65	Romi	11 2850-3504	CL-0055	\N	2026-03-09 20:59:42.0756	\N
66	Judith	9 3884 73-9427	CL-0056	\N	2026-03-09 21:29:04.221181	Jujuy
67	Paola	9 11 6426-0181	CL-0057	\N	2026-03-10 13:14:53.860651	Tigre
68	Ivi	11 5793-9029	CL-0058	\N	2026-03-10 13:20:30.984844	Hurlingham
\.


--
-- Data for Name: config_theme; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.config_theme (id, primary_color, primary_hover, bg_color, card_color, table_header, estado_comprar, estado_sena, estado_terminado, estado_entregado) FROM stdin;
1	#4f46e5	#4338ca	#f1f5f9	#ffffff	#1e293b	#f87171	#facc15	#84cc16	#22c55e
\.


--
-- Data for Name: meses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meses (id, nombre, fecha_inicio, fecha_fin, activo, created_at) FROM stdin;
1	Febrero 2026	2026-02-28	\N	f	2026-02-28 12:57:37.797714
2	Febrero	2026-02-28	\N	f	2026-02-28 13:02:07.717816
3	febrero	2026-02-28	\N	f	2026-02-28 13:07:31.091494
4	Abril	2026-03-06	\N	f	2026-03-06 00:43:24.441861
5	Abril 2026	2026-03-08	\N	f	2026-03-08 13:12:07.477777
6	Abril 2026	2026-03-11	\N	t	2026-03-11 00:14:35.404162
\.


--
-- Data for Name: pedido_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedido_items (id, pedido_id, producto_id, cantidad, color_bolsa, color_estampa, doble_estampa, precio_item, costo_item, ganancia_item) FROM stdin;
\.


--
-- Data for Name: pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedidos (id, cliente_id, fecha, envio, fecha_entrega, total_general, sena, restante, estado) FROM stdin;
\.


--
-- Data for Name: precios_pack; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.precios_pack (id, producto_id, cantidad, precio_total, updated_at, costo_pack) FROM stdin;
7	1	50	30000.00	2026-03-08 00:04:01.058101	14550.00
13	2	50	24000.00	2026-03-08 00:05:34.75735	6650.00
14	2	100	40000.00	2026-03-08 00:05:46.652048	13300.00
15	2	200	60000.00	2026-03-08 00:05:59.129581	26600.00
16	2	300	80000.00	2026-03-08 00:06:08.786302	39900.00
8	1	100	48000.00	2026-02-25 21:53:59.909417	29100.00
25	4	50	28000.00	2026-02-27 00:29:17.952417	13100.00
26	4	100	52000.00	2026-02-27 00:29:31.119878	26200.00
27	4	200	99000.00	2026-02-27 00:29:41.293425	52400.00
28	4	300	147000.00	2026-02-27 00:29:53.746466	78600.00
29	4	400	194000.00	2026-02-27 00:30:05.20571	104800.00
30	4	500	242000.00	2026-02-27 00:30:15.31331	131000.00
11	1	400	168000.00	2026-02-27 00:31:01.642851	116400.00
12	1	500	208000.00	2026-02-27 00:31:09.888714	145500.00
43	7	50	33000.00	2026-02-27 00:31:23.718057	16850.00
44	7	100	56000.00	2026-02-27 00:31:38.059103	33700.00
45	7	200	112000.00	2026-02-27 00:31:48.391979	67400.00
46	7	300	158000.00	2026-02-27 00:31:57.851204	101100.00
47	7	400	209000.00	2026-02-27 00:32:13.131625	134800.00
48	7	500	260000.00	2026-02-27 00:32:22.319074	168500.00
49	8	50	36000.00	2026-02-27 00:32:35.304795	19150.00
50	8	100	65000.00	2026-02-27 00:32:47.941657	38300.00
51	8	200	125000.00	2026-02-27 00:33:01.582831	76600.00
52	8	300	185000.00	2026-02-27 00:33:14.750618	114900.00
53	8	400	240000.00	2026-02-27 00:33:25.801754	153200.00
54	8	500	290000.00	2026-02-27 00:33:34.648241	191500.00
17	2	400	110000.00	2026-03-08 00:06:20.622295	53200.00
18	2	500	130000.00	2026-03-08 00:06:30.920956	66500.00
19	3	50	27000.00	2026-03-08 00:06:44.760537	9200.00
20	3	100	42000.00	2026-03-08 00:06:58.699484	18400.00
21	3	200	71000.00	2026-03-08 00:07:08.050928	36800.00
22	3	300	100000.00	2026-03-08 00:07:17.983959	55200.00
23	3	400	133000.00	2026-03-08 00:07:28.829557	73600.00
31	5	50	32000.00	2026-03-08 00:07:47.81651	14050.00
32	5	100	50000.00	2026-03-08 00:07:56.713889	28100.00
33	5	200	84000.00	2026-03-08 00:08:29.078336	56200.00
34	5	300	119000.00	2026-03-08 00:08:38.115917	84300.00
35	5	400	159000.00	2026-03-08 00:08:48.65368	112400.00
36	5	500	198000.00	2026-03-08 00:09:11.278164	140500.00
9	1	200	93000.00	2026-03-08 11:53:28.809137	58200.00
10	1	300	128000.00	2026-03-08 11:53:37.246171	87300.00
24	3	500	167000.00	2026-03-08 11:54:29.444753	92000.00
55	9	50	41000.00	2026-02-27 00:33:50.074424	21000.00
56	9	100	77000.00	2026-02-27 00:33:58.60619	42000.00
57	9	200	149000.00	2026-02-27 00:34:10.101429	84000.00
58	9	300	221000.00	2026-02-27 00:34:21.149057	126000.00
59	9	400	293000.00	2026-02-27 00:34:30.282417	168000.00
60	9	500	365000.00	2026-02-27 00:34:39.989916	210000.00
61	10	50	41000.00	2026-02-27 00:34:54.323445	21500.00
62	10	100	79000.00	2026-02-27 00:35:02.876659	43000.00
63	10	200	155000.00	2026-02-27 00:35:12.742185	86000.00
64	10	300	230000.00	2026-02-27 00:35:23.119936	129000.00
65	10	400	300000.00	2026-02-27 00:35:32.16323	172000.00
66	10	500	370000.00	2026-03-08 11:56:30.716159	215000.00
\.


--
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.productos (id, tamano, tipo_asa, precio_base, activo, created_at, precio_venta_unitario, costo_unitario, costo_estampado_unitario, precio_proveedor_unitario) FROM stdin;
2	15x20	RINON	\N	t	2026-02-25 19:40:46.155152	\N	133.00	50	\N
4	30x30	ASAS	\N	t	2026-02-25 19:40:46.155152	\N	262.00	50	\N
5	30x40	RINON	\N	t	2026-02-25 19:40:46.155152	\N	281.00	50	\N
1	30x40	ASAS	500.00	t	2026-02-23 18:47:18.307792	\N	291.00	50	231
3	20x30	RINON	\N	t	2026-02-25 19:40:46.155152	\N	184.00	50	\N
10	60x50	ASAS	\N	t	2026-02-25 19:40:46.155152	\N	430.00	50	\N
7	45x40	ASAS	\N	t	2026-02-25 19:40:46.155152	\N	337.00	50	\N
8	50x40	ASAS	\N	t	2026-02-25 19:40:46.155152	\N	383.00	50	\N
9	60x40	ASAS	\N	t	2026-02-25 19:40:46.155152	\N	420.00	50	\N
\.


--
-- Data for Name: ventas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ventas (id, fecha, cliente_id, producto_id, cantidad, color_bolsa, color_estampa, doble_estampa, envio_domicilio, precio_final, sena, restante, costo_total, ganancia_total, ganancia_taller, ganancia_personal, fecha_entrega, factura, estado, created_at, arca, color_fila, etapa, mes_id, envio_monto, codigo_seguimiento) FROM stdin;
83	2026-03-05	45	4	100	Crudo	Negro	f	t	60000.00	30000.00	30000.00	26200.00	25800.00	1290.00	24510.00	2026-03-10	t	sena_pagada	2026-03-08 12:04:28.77589	f	\N	terminado	4	0	\N
81	2026-03-04	44	2	50	Negro	Rosa	f	f	24000.00	12000.00	12000.00	6650.00	17350.00	867.50	16482.50	2026-03-09	t	sena_pagada	2026-03-08 12:00:47.417896	f	\N	terminado	4	0	\N
70	2026-03-03	37	1	50	Negro	Blanco	f	t	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-03-03	t	sena_pagada	2026-03-08 11:40:55.910226	f	\N	entregado	4	0	\N
72	2026-03-03	40	5	100	Celeste	Negro	f	t	58000.00	29000.00	29000.00	28100.00	21900.00	1095.00	20805.00	2026-03-03	t	sena_pagada	2026-03-08 11:42:26.832715	f	\N	entregado	4	0	\N
71	2026-03-03	39	1	50	Blanco	Negro	f	f	30000.00	15000.00	15000.00	14550.00	15450.00	772.50	14677.50	2026-03-03	t	sena_pagada	2026-03-08 11:41:25.93701	f	\N	entregado	4	0	\N
69	2026-03-02	38	9	100	Negro	Blanco	t	t	123500.00	61750.00	61750.00	42000.00	73500.00	3675.00	69825.00	2026-03-09	t	sena_pagada	2026-03-08 11:34:04.630865	f	\N	entregado	4	0	\N
57	2026-03-01	31	7	50	Negro	Blanco	f	t	41000.00	20500.00	20500.00	16850.00	24150.00	1207.50	22942.50	2026-03-02	t	sena_pagada	2026-03-08 01:35:32.631712	f	\N	entregado	4	0	\N
58	2026-03-01	32	1	50	Blanco	Negro	f	f	30000.00	15000.00	15000.00	14550.00	15450.00	772.50	14677.50	2026-03-02	t	sena_pagada	2026-03-08 11:15:46.013602	f	\N	entregado	4	0	\N
107	2026-03-08	57	7	50	Negro	Blanco	f	f	33000.00	16500.00	16500.00	16850.00	16150.00	807.50	15342.50	2026-03-13	f	sena_pagada	2026-03-08 22:13:33.069359	f	\N	sena	5	0	\N
73	2026-03-03	41	1	100	Blanco	Rojo	f	f	48000.00	24000.00	24000.00	29100.00	18900.00	945.00	17955.00	2026-03-03	t	sena_pagada	2026-03-08 11:43:02.156312	f	\N	entregado	4	0	\N
74	2026-03-03	41	7	100	Blanco	Rojo	f	f	56000.00	28000.00	28000.00	33700.00	22300.00	1115.00	21185.00	2026-03-03	t	sena_pagada	2026-03-08 11:43:36.289121	f	\N	entregado	4	0	\N
59	2026-03-01	29	10	50	Crudo	Negro	f	f	41000.00	20500.00	20500.00	21500.00	19500.00	975.00	18525.00	2026-03-02	t	sena_pagada	2026-03-08 11:16:39.795018	f	\N	entregado	4	0	\N
77	2026-03-04	42	3	100	Negro	Blanco	f	f	42000.00	21000.00	21000.00	18400.00	23600.00	1180.00	22420.00	2026-03-09	t	sena_pagada	2026-03-08 11:45:22.367469	f	\N	entregado	4	0	\N
87	2026-03-06	46	4	50	Crudo	Negro	f	f	28000.00	14000.00	14000.00	13100.00	14900.00	745.00	14155.00	2026-03-10	t	sena_pagada	2026-03-08 12:07:25.625559	f	\N	terminado	4	0	\N
88	2026-03-06	46	1	50	Crudo	Negro	f	f	30000.00	15000.00	15000.00	14550.00	15450.00	772.50	14677.50	2026-03-10	t	sena_pagada	2026-03-08 12:07:44.35786	f	\N	terminado	4	0	\N
80	2026-03-04	44	7	50	Rosa	Negro	f	t	41000.00	20500.00	20500.00	16850.00	16150.00	807.50	15342.50	2026-03-09	t	sena_pagada	2026-03-08 12:00:26.377704	f	\N	terminado	4	0	\N
84	2026-03-05	45	7	100	Crudo	Negro	f	f	56000.00	28000.00	28000.00	33700.00	22300.00	1115.00	21185.00	2026-03-10	t	sena_pagada	2026-03-08 12:04:51.406684	f	\N	terminado	4	0	\N
95	2026-03-07	50	3	50	Blanco	Verde Agua	f	f	27000.00	13500.00	13500.00	9200.00	17800.00	890.00	16910.00	2026-03-11	t	sena_pagada	2026-03-08 12:15:23.097435	f	\N	entregado	4	0	\N
78	2026-03-04	43	1	200	Negro	Blanco	f	f	93000.00	46500.00	46500.00	58200.00	34800.00	1740.00	33060.00	2026-03-09	f	sena_pagada	2026-03-08 11:57:04.502191	f	\N	sena	4	0	\N
79	2026-03-05	22	1	50	Negro	Blanco	f	t	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-03-09	t	sena_pagada	2026-03-08 11:57:42.778183	f	\N	entregado	4	0	\N
75	2026-03-04	42	10	50	Negro	Blanco	f	f	41000.00	20500.00	20500.00	21500.00	19500.00	975.00	18525.00	2026-03-09	t	sena_pagada	2026-03-08 11:44:35.430345	f	\N	entregado	4	0	\N
85	2026-03-05	45	8	100	Crudo	Negro	f	f	65000.00	32500.00	32500.00	38300.00	26700.00	1335.00	25365.00	2026-03-10	t	sena_pagada	2026-03-08 12:05:08.137126	f	\N	terminado	4	0	\N
86	2026-03-06	46	3	50	Crudo	Negro	f	t	35000.00	17500.00	17500.00	9200.00	17800.00	890.00	16910.00	2026-03-10	t	sena_pagada	2026-03-08 12:07:05.91468	f	\N	terminado	4	0	\N
65	2026-03-02	35	3	50	Blanco	Negro	f	t	35000.00	17500.00	17500.00	9200.00	17800.00	890.00	16910.00	2026-03-03	t	sena_pagada	2026-03-08 11:28:55.857915	f	\N	entregado	4	0	\N
63	2026-03-01	34	8	100	Negro	Blanco	f	f	65000.00	32500.00	32500.00	38300.00	26700.00	1335.00	25365.00	2026-03-02	t	sena_pagada	2026-03-08 11:19:31.647229	f	\N	entregado	4	0	\N
62	2026-03-01	34	1	100	Blanco	Negro	f	f	48000.00	24000.00	24000.00	29100.00	18900.00	945.00	17955.00	2026-03-02	t	sena_pagada	2026-03-08 11:19:08.457578	f	\N	entregado	4	0	\N
61	2026-03-01	34	4	100	Negro	Blanco	f	f	52000.00	26000.00	26000.00	26200.00	25800.00	1290.00	24510.00	2026-03-02	t	sena_pagada	2026-03-08 11:18:28.474991	f	\N	entregado	4	0	\N
60	2026-03-01	33	7	100	Negro	Blanco	f	f	56000.00	28000.00	28000.00	33700.00	22300.00	1115.00	21185.00	2026-03-02	t	sena_pagada	2026-03-08 11:17:27.365442	f	\N	entregado	4	0	\N
89	2026-03-06	47	7	100	Negro	Rosa	f	t	64000.00	32000.00	32000.00	33700.00	22300.00	1115.00	21185.00	2026-03-11	f	sena_pagada	2026-03-08 12:09:40.217007	f	\N	sena	4	0	\N
68	2026-03-02	36	3	50	Crudo	Marrón	f	f	27000.00	13500.00	13500.00	9200.00	17800.00	890.00	16910.00	2026-03-03	t	sena_pagada	2026-03-08 11:33:08.773604	f	\N	entregado	4	0	\N
67	2026-03-02	36	7	100	Crudo	Marrón	f	f	56000.00	28000.00	28000.00	33700.00	22300.00	1115.00	21185.00	2026-03-03	t	sena_pagada	2026-03-08 11:32:44.943298	f	\N	entregado	4	0	\N
66	2026-03-02	36	10	50	Crudo	Marrón	f	t	49000.00	24500.00	24500.00	21500.00	19500.00	975.00	18525.00	2026-03-03	t	sena_pagada	2026-03-08 11:31:45.452137	f	\N	entregado	4	0	\N
90	2026-03-06	47	4	100	Negro	Rosa	f	f	52000.00	26000.00	26000.00	26200.00	25800.00	1290.00	24510.00	2026-03-11	f	sena_pagada	2026-03-08 12:09:58.631037	f	\N	sena	4	0	\N
91	2026-03-07	48	7	50	Fucsia	Negro	f	f	33000.00	16500.00	16500.00	16850.00	16150.00	807.50	15342.50	2026-03-11	t	sena_pagada	2026-03-08 12:11:52.277328	f	\N	terminado	4	0	\N
92	2026-03-07	48	7	50	Amarillo	Negro	f	f	33000.00	16500.00	16500.00	16850.00	16150.00	807.50	15342.50	2026-03-11	t	sena_pagada	2026-03-08 12:12:04.548569	f	\N	terminado	4	0	\N
93	2026-03-07	49	5	50	Rosa	Negro	f	t	40000.00	20000.00	20000.00	14050.00	17950.00	897.50	17052.50	2026-03-11	f	sena_pagada	2026-03-08 12:13:42.264452	f	\N	sena	4	0	\N
102	2026-03-07	54	7	100	Amarillo	Negro	t	f	84000.00	42000.00	42000.00	33700.00	50300.00	2515.00	47785.00	2026-03-12	f	sena_pagada	2026-03-08 12:22:41.93923	f	\N	sena	4	0	\N
101	2026-03-07	54	7	100	Rojo	Negro	t	t	92000.00	46000.00	46000.00	33700.00	50300.00	2515.00	47785.00	2026-03-12	f	sena_pagada	2026-03-08 12:22:26.580563	f	\N	sena	4	0	\N
106	2026-03-08	57	4	100	Negro	Blanco	f	t	60000.00	30000.00	30000.00	26200.00	25800.00	1290.00	24510.00	2026-03-13	f	sena_pagada	2026-03-08 22:13:17.665071	f	\N	sena	5	0	\N
104	2026-03-08	55	5	50	Negro	Fucsia	f	t	40000.00	20000.00	20000.00	14050.00	17950.00	897.50	17052.50	2026-03-13	f	sena_pagada	2026-03-08 15:51:05.49135	f	\N	sena	5	0	\N
100	2026-03-07	53	1	50	Crudo	Dorado	f	t	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-03-12	f	sena_pagada	2026-03-08 12:19:16.485071	f	\N	sena	4	0	\N
99	2026-03-07	52	8	100	Blanco	Dorado	f	f	65000.00	32500.00	32500.00	38300.00	26700.00	1335.00	25365.00	2026-03-12	f	sena_pagada	2026-03-08 12:18:08.695771	f	\N	sena	4	0	\N
98	2026-03-07	52	4	100	Blanco	Dorado	f	f	52000.00	26000.00	26000.00	26200.00	25800.00	1290.00	24510.00	2026-03-12	f	sena_pagada	2026-03-08 12:17:48.014727	f	\N	sena	4	0	\N
97	2026-03-07	52	2	50	Blanco	Dorado	f	t	32000.00	16000.00	16000.00	6650.00	17350.00	867.50	16482.50	2026-03-12	f	sena_pagada	2026-03-08 12:17:27.430627	f	\N	sena	4	0	\N
96	2026-03-07	51	1	100	Crudo	Negro	f	t	56000.00	28000.00	28000.00	29100.00	18900.00	945.00	17955.00	2026-03-11	f	sena_pagada	2026-03-08 12:16:31.185265	f	\N	sena	4	0	\N
94	2026-03-07	50	4	50	Blanco	Verde Agua	f	f	28000.00	14000.00	14000.00	13100.00	14900.00	745.00	14155.00	2026-03-11	t	sena_pagada	2026-03-08 12:15:01.452481	f	\N	entregado	4	0	\N
112	2026-03-09	61	7	100	Negro	Blanco	f	t	64000.00	32000.00	32000.00	33700.00	22300.00	1115.00	21185.00	2026-03-13	f	sena_pagada	2026-03-09 12:51:45.423465	f	\N	sena	5	0	\N
129	2026-03-09	66	7	100	Fucsia	Negro	f	f	56000.00	28000.00	28000.00	33700.00	22300.00	1115.00	21185.00	2026-03-17	f	sena_pagada	2026-03-09 21:29:46.661045	f	\N	sena	5	0	\N
130	2026-03-09	66	1	100	Celeste	Negro	f	f	48000.00	24000.00	24000.00	29100.00	18900.00	945.00	17955.00	2026-03-17	f	sena_pagada	2026-03-09 21:30:04.780969	f	\N	sena	5	0	\N
117	2026-03-09	63	1	50	Crudo	Negro	f	f	30000.00	15000.00	15000.00	14550.00	15450.00	772.50	14677.50	2026-03-16	f	sena_pagada	2026-03-09 14:44:09.277662	f	\N	sena	5	0	\N
115	2026-03-09	62	5	100	Crudo	Negro	f	t	58000.00	29000.00	29000.00	28100.00	21900.00	1095.00	20805.00	2026-03-16	f	sena_pagada	2026-03-09 13:18:10.391475	f	\N	sena	5	0	\N
113	2026-03-09	61	7	100	Blanco	Negro	f	f	56000.00	28000.00	28000.00	33700.00	22300.00	1115.00	21185.00	2026-03-13	f	sena_pagada	2026-03-09 12:52:06.429812	f	\N	sena	5	0	\N
111	2026-03-09	60	7	50	Crudo	Negro	f	t	41000.00	20500.00	20500.00	16850.00	16150.00	807.50	15342.50	2026-03-13	f	sena_pagada	2026-03-09 11:07:44.737781	f	\N	sena	5	0	\N
110	2026-03-09	59	4	50	Blanco	Violeta	f	t	36000.00	18000.00	18000.00	13100.00	14900.00	745.00	14155.00	2026-03-13	f	sena_pagada	2026-03-09 10:37:24.267592	f	\N	sena	5	0	\N
109	2026-03-09	58	1	50	Crudo	Marrón	f	t	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-03-13	f	sena_pagada	2026-03-09 10:22:09.310048	f	\N	sena	5	0	\N
116	2026-03-09	63	1	50	Rojo	Blanco	f	t	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-03-16	f	sena_pagada	2026-03-09 14:43:55.881577	f	\N	sena	5	0	\N
127	2026-03-09	65	3	100	Crudo	Bordó	f	f	42000.00	21000.00	21000.00	18400.00	23600.00	1180.00	22420.00	2026-03-16	t	sena_pagada	2026-03-09 21:02:47.130383	f	\N	comprar	5	0	\N
118	2026-03-09	64	8	50	Crudo	Negro	f	t	44000.00	22000.00	22000.00	19150.00	16850.00	842.50	16007.50	2026-03-16	t	sena_pagada	2026-03-09 15:48:22.615098	f	\N	comprar	5	0	\N
76	2026-03-04	42	1	50	Negro	Blanco	f	f	30000.00	15000.00	15000.00	14550.00	15450.00	772.50	14677.50	2026-03-09	t	sena_pagada	2026-03-08 11:45:04.934001	f	\N	entregado	4	0	\N
126	2026-03-09	56	7	50	Negro	Dorado	f	f	42000.00	21000.00	21000.00	16850.00	16150.00	807.50	15342.50	2026-03-16	t	sena_pagada	2026-03-09 20:58:52.241282	f	\N	comprar	5	9000	\N
128	2026-03-09	66	4	100	Fucsia	Negro	f	f	70000.00	35000.00	35000.00	26200.00	25800.00	1290.00	24510.00	2026-03-17	f	sena_pagada	2026-03-09 21:29:30.262786	f	\N	sena	5	18000	asdfsdfsdfsdf22
131	2026-03-10	67	8	50	Crudo	Negro	f	f	44000.00	22000.00	22000.00	19150.00	16850.00	842.50	16007.50	2026-03-16	t	sena_pagada	2026-03-10 13:15:20.830791	f	\N	comprar	5	8000	\N
132	2026-03-10	68	2	50	Blanco	Negro	f	f	32000.00	16000.00	16000.00	6650.00	17350.00	867.50	16482.50	2026-03-17	t	sena_pagada	2026-03-10 13:20:52.828629	f	\N	comprar	5	8000	\N
82	2026-03-04	44	3	50	Rosa	Negro	f	f	27000.00	13500.00	13500.00	9200.00	17800.00	890.00	16910.00	2026-03-09	t	sena_pagada	2026-03-08 12:01:31.750773	f	\N	terminado	4	0	\N
133	2026-03-10	68	3	100	Blanco	Negro	f	f	42000.00	21000.00	21000.00	18400.00	23600.00	1180.00	22420.00	2026-03-18	t	sena_pagada	2026-03-10 13:21:07.122248	f	\N	comprar	5	0	\N
134	2026-03-11	69	1	50	Crudo	Negro	f	f	40000.00	20000.00	20000.00	14550.00	15450.00	772.50	14677.50	2026-03-18	t	sena_pagada	2026-03-10 23:25:01.031485	f	\N	comprar	5	10000	\N
136	2026-03-11	70	1	50	Negro	Blanco	f	f	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-03-18	t	sena_pagada	2026-03-11 10:01:37.458772	f	\N	comprar	6	8000	\N
137	2026-03-11	71	8	50	Crudo	Negro	f	f	46000.00	23000.00	23000.00	19150.00	16850.00	842.50	16007.50	2026-03-18	t	sena_pagada	2026-03-11 12:59:30.802609	f	\N	comprar	6	10000	\N
\.


--
-- Name: clientes_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_codigo_seq', 63, true);


--
-- Name: clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_id_seq', 73, true);


--
-- Name: config_theme_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.config_theme_id_seq', 1, true);


--
-- Name: meses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.meses_id_seq', 6, true);


--
-- Name: pedido_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedido_items_id_seq', 1, false);


--
-- Name: pedidos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedidos_id_seq', 1, false);


--
-- Name: precios_pack_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.precios_pack_id_seq', 66, true);


--
-- Name: productos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.productos_id_seq', 10, true);


--
-- Name: ventas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ventas_id_seq', 138, true);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- Name: config_theme config_theme_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config_theme
    ADD CONSTRAINT config_theme_pkey PRIMARY KEY (id);


--
-- Name: meses meses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meses
    ADD CONSTRAINT meses_pkey PRIMARY KEY (id);


--
-- Name: pedido_items pedido_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_items
    ADD CONSTRAINT pedido_items_pkey PRIMARY KEY (id);


--
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (id);


--
-- Name: precios_pack precios_pack_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.precios_pack
    ADD CONSTRAINT precios_pack_pkey PRIMARY KEY (id);


--
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id);


--
-- Name: ventas ventas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_pkey PRIMARY KEY (id);


--
-- Name: pedido_items pedido_items_pedido_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_items
    ADD CONSTRAINT pedido_items_pedido_id_fkey FOREIGN KEY (pedido_id) REFERENCES public.pedidos(id) ON DELETE CASCADE;


--
-- Name: pedido_items pedido_items_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_items
    ADD CONSTRAINT pedido_items_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.productos(id);


--
-- Name: pedidos pedidos_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.clientes(id);


--
-- Name: precios_pack precios_pack_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.precios_pack
    ADD CONSTRAINT precios_pack_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.productos(id) ON DELETE CASCADE;


--
-- Name: ventas ventas_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.clientes(id) ON DELETE CASCADE;


--
-- Name: ventas ventas_mes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_mes_id_fkey FOREIGN KEY (mes_id) REFERENCES public.meses(id);


--
-- Name: ventas ventas_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.productos(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict CRhE8xaPZ6uZGoE8BkG27INxaRubWXxGWlUIXfKairjmJpJGk16uA2BbV3jhQHS

