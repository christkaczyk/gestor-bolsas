--
-- PostgreSQL database dump
--

\restrict eQzyZrSrkFNXcPgdatpmhctfEPXi6Q61lxSbXZIWhWie2VN9KVTQnPzhVZ9ghfb

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
    localidad text,
    imagen_diseno text
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

COPY public.clientes (id, nombre, whatsapp, archivo_codigo, direccion, created_at, localidad, imagen_diseno) FROM stdin;
69	Navila Farias	11 6106-1346	CL-0059	\N	2026-03-10 13:26:30.882337	\N	\N
70	Tacha	11 6761-6591	CL-0060	\N	2026-03-11 09:58:41.64409	\N	\N
71	Jorgelina Mierke	9 3404 41-7419	CL-0061	\N	2026-03-11 12:59:09.874161	San Carlos Centro, provincia de Santa Fe	\N
72	ThomateoFran	11 4022-3733	CL-0062	\N	2026-03-11 18:33:53.550909	\N	\N
73	Carmen	 9 3869 60-7035	CL-0063	\N	2026-03-11 18:45:58.005361	Tucuman	\N
74	Lu	11 2336-6109	CL-0064	\N	2026-03-12 08:45:03.185902	\N	\N
75	LB3D	11 3193-2902	CL-0065	\N	2026-03-12 11:35:51.591475	\N	\N
76	Gi	9 3416 61-3042	CL-0066		2026-03-12 12:49:54.833256	Perez, Santa Fe	\N
77	Evelyn Portillo	11 5972-7135	CL-0067	\N	2026-03-12 17:58:18.720952	\N	\N
78	Beni Moda	11 3410-1753	CL-0068	\N	2026-03-12 18:12:36.941064	\N	\N
80	Sabrina	11 2500-6447	CL-0070	\N	2026-03-13 21:26:37.144385	\N	\N
81	Winston	11 5880-0127	CL-0071	\N	2026-03-14 12:51:55.50912	\N	\N
82	Uniformes Escolares	11 5898-4938	CL-0072	\N	2026-03-14 13:18:24.85205	\N	\N
18	Fedeex	11 6238-1269	CL-0008	\N	2026-02-28 00:12:16.381309	\N	\N
19	Gaby Hijo	11 7050-6812	CL-0009	\N	2026-02-28 00:13:33.510714	\N	\N
20	Brenda 3	11 4084-5546	CL-0010	\N	2026-02-28 00:14:05.077199	\N	\N
21	Morena	11 4419-1129	CL-0011	\N	2026-02-28 00:14:25.156926	\N	\N
22	Lourdes Lotito	11 2601-4346	CL-0012	\N	2026-02-28 00:14:45.798956	\N	\N
23	Liam Babyshop	11 7036-8349	CL-0013	\N	2026-02-28 00:15:13.650695	\N	\N
24	Uriel Jaime	11 7064-4644	CL-0014	\N	2026-02-28 00:15:36.614853	\N	\N
25	Sofia Magali	11 5991-5890	CL-0015	\N	2026-02-28 00:16:05.592421	\N	\N
26	Guapas	11 3342-5576	CL-0016	\N	2026-02-28 00:16:25.885976	\N	\N
27	Beauty Mar	11 6251-8729	CL-0017	\N	2026-02-28 00:16:45.369827	\N	\N
28	Johanna	11 2895-7593	CL-0018	\N	2026-02-28 00:17:30.864348	\N	\N
29	DECOBA	11 6363-6355	CL-0019	\N	2026-02-28 00:17:48.785207	\N	\N
30	Agus	11 6954-3392	CL-0020	\N	2026-02-28 00:18:13.305568	\N	\N
31	Luisana	11 3420-8034	CL-0021	\N	2026-02-28 00:18:31.939681	\N	\N
32	Mariel Tango	11 6802-1570	CL-0022	\N	2026-02-28 00:18:51.525075	\N	\N
33	Bian	11 4062-4863	CL-0023	\N	2026-02-28 00:19:08.21514	\N	\N
34	Ari	11 5807-3797	CL-0024	\N	2026-02-28 00:19:27.343975	\N	\N
35	Renzo	11 5823-8118	CL-0025	\N	2026-02-28 00:19:45.642345	\N	\N
36	Natalia	11 6866-5577	CL-0026	\N	2026-02-28 00:20:03.621176	\N	\N
37	Yesica Acosta 	11 3002-4983	CL-0027	Prof. Antonio Marxer n°564	2026-02-28 20:36:45.062575	Monte grande 	\N
38	ElectroDM	11 6478-1997	CL-0028	Calle 12 nro 4487	2026-03-04 23:55:58.502735	berazategui	\N
39	Vero	11 2259-5833	CL-0029	\N	2026-03-04 23:56:35.376446	\N	\N
40	Ambos Rose	11 2295-3485	CL-0030	\N	2026-03-04 23:57:15.408559	\N	\N
41	Clara Mucho Ruido	11 6153-6270	CL-0031	\N	2026-03-04 23:57:35.442826	\N	\N
42	Lu DOMUSTEC	11 6132-4348	CL-0032	\N	2026-03-04 23:57:55.975737	\N	\N
43	Agustin Castro	11 3178-1487	CL-0033	\N	2026-03-04 23:58:28.715389	\N	\N
44	Unica Boutique	9 2945 68-6283	CL-0034	\N	2026-03-08 11:59:20.506672	Pinamar	\N
45	Evelin	 9 2227 47-0656	CL-0035	Alberdi 1480	2026-03-08 12:03:18.360075	Lobos cp7240	\N
46	Lau	1169638663	CL-0036	Andrés baranda 1224	2026-03-08 12:06:19.328899	Quilmes	\N
47	Mar	9 11 7103-0536	CL-0037	Homero 263	2026-03-08 12:09:03.635976	Lomas de Zamora	\N
48	Rocio	9 11 5753-4401	CL-0038	\N	2026-03-08 12:11:11.239777	\N	\N
49	Divain	9 2236 83-4989	CL-0039	\N	2026-03-08 12:13:10.595065	Mar del plata	\N
50	Milu Lobos	11 6180-8047	CL-0040	\N	2026-03-08 12:14:19.380878	\N	\N
51	Yanina	11 6850-5186	CL-0041	Mauricio Ravel 542	2026-03-08 12:15:57.906495	Temperley	\N
52	Daniela	11 3063-5125	CL-0042	\N	2026-03-08 12:16:54.509191	\N	\N
53	Pintitas	11 5702-8961	CL-0043	Lomas Valentinas 337 esq Republica Argentina 	2026-03-08 12:18:49.215153	Valentín Alsina	\N
54	Super Posta	9 2215 86-8189	CL-0044	Av. 520 esquina 158	2026-03-08 12:21:23.160718	La plata	\N
55	Lorena	 9 2983 56-0105	CL-0045	\N	2026-03-08 15:50:29.683403	Tres Arroyos	\N
56	Antorena Jeans	9 3764 67-9829	CL-0046	\N	2026-03-08 20:36:00.97532	Posadas, Misiones.	\N
57	Alondra	11 6309-6452	CL-0047	Calle 159a 3033	2026-03-08 22:12:44.143008	Berazategui	\N
58	Carlitos Lujan	9 3512 03-9788	CL-0048	\N	2026-03-09 09:53:06.95642	Cordoba capital	\N
59	Lykaena	11 3297-0592	CL-0049	Don segundo sombra 5702 esquina Isabel la católica	2026-03-09 10:37:02.292637	Paso del Rey	\N
60	Sil	11 3261-8102	CL-0050	Santo Domingo 3900 (equina Bonavena)	2026-03-09 11:07:15.2176	Nueva Pompeya, Barrio comandante Espora.	\N
61	Bendita Seas	 9 2314 62-6828	CL-0051	GENERAL PAZ 131	2026-03-09 12:40:50.901294	San Carlos de Bolivar	\N
62	Loreley	9 2216 07-0471	CL-0052	calle 80 n 434 entre 3 y 4 villa elvira 	2026-03-09 13:13:05.534543	La Plata	\N
63	Ramona	11 6433-1321	CL-0053	padilla 3030	2026-03-09 14:43:00.015203	Hurlingham	\N
64	Jorgelina	 11 6844-3863	CL-0054	\N	2026-03-09 15:45:28.432994	Merlo	\N
65	Romi	11 2850-3504	CL-0055	\N	2026-03-09 20:59:42.0756	\N	\N
66	Judith	9 3884 73-9427	CL-0056	\N	2026-03-09 21:29:04.221181	Jujuy	\N
67	Paola	9 11 6426-0181	CL-0057	\N	2026-03-10 13:14:53.860651	Tigre	\N
68	Ivi	11 5793-9029	CL-0058	\N	2026-03-10 13:20:30.984844	Hurlingham	\N
83	Vir	 9 3412 82-3056	CL-0073		2026-03-14 13:18:57.002104	Rosario, Santa Fe	\N
84	Nicca	11 6209-1954	CL-0074	Lisandro de la torre 3193	2026-03-14 14:39:12.260316	Don Torcuato	\N
79	Lore	11 4169-3308	CL-0069	El Aljibe 187	2026-03-13 13:54:43.783881	Gobernador costa, Fcio Varela	\N
85	Sabry	9 3547 63-3421	CL-0075	\N	2026-03-15 11:13:49.090492	Malvinas Argentinas	\N
86	Agustin	11 6883-9441	CL-0076	\N	2026-03-15 13:03:06.889533	Quilmes	\N
87	Celez	11 2784-3230	CL-0077	\N	2026-03-16 09:33:50.301871	\N	\N
88	Azul Cielo	11 4082-4453	CL-0078	\N	2026-03-16 16:12:16.290512	Wilde	\N
89	Grafica Rocket	11 3365-5963	CL-0079	\N	2026-03-16 17:28:16.826143	\N	\N
90	Viviana	3464 56-2317	CL-0080	\N	2026-03-16 17:52:17.586541	Santa Fé	\N
91	Importados God	11 6231-1820	CL-0081	\N	2026-03-16 18:06:58.791931	San Martin	\N
92	Karen Braganza	2281 55-9098	CL-0082	\N	2026-03-16 19:36:39.937556	Azul, Prov. Buenos Aires	\N
93	Greboyras3	3825 58-5495	CL-0083	\N	2026-03-17 08:33:20.367272	Poman, Catamarca	\N
94	Mariana	9 3885 72-2013	CL-0084	\N	2026-03-17 11:51:01.497571	Jujuy	\N
95	Fausto	9 2214 95-5497	CL-0085	\N	2026-03-17 13:44:12.284717	La Plata	\N
96	Pia & Co Store	9 2216 32-7105	CL-0086	\N	2026-03-17 14:35:42.523314	\N	\N
97	Silvana	9 2664 38-9275	CL-0087	\N	2026-03-17 15:29:25.381606	San Luis	\N
98	Nikitoo	11 3059-0426	CL-0088	\N	2026-03-17 15:49:49.03552	Moreno	\N
99	Shiori	2262 66-3822	CL-0089	Perú 245	2026-03-18 11:35:53.023519	Montserrat, CABA	\N
100	Jaime	9 2994 11-2915	CL-0090	\N	2026-03-18 11:57:36.085665	Centenario, Neuquen	\N
101	Naty Reyna	11 3181-6116	CL-0091	\N	2026-03-18 12:37:36.781287	Moreno	\N
102	Vale	9 3412 17-7685	CL-0092	\N	2026-03-18 13:25:27.172305	Pavón, Santa Fé	\N
103	Roxana	9 3794 04-6623	CL-0093	\N	2026-03-18 13:56:12.578824	Corrientes	\N
104	Brenda	9 11 2248-1015	CL-0094	\N	2026-03-18 17:54:13.409357	\N	\N
105	Morena Pesce	9 3446 58-1807	CL-0095	\N	2026-03-19 12:35:37.606404	\N	\N
106	Mr.Pato	11 6451-4354	CL-0096	\N	2026-03-19 13:43:55.037779	Gonzales Catán	\N
107	Mayra Yumila	3482 30-8787	CL-0097	\N	2026-03-20 08:27:32.864142	Reconquista, Santa Fé	\N
108	Manos Artisticas	 11 5943-0919	CL-0098	\N	2026-03-20 13:26:51.415314	La Florida, Quilmes Oeste	\N
109	Electro Jireh	11 6619-3907	CL-0099	\N	2026-03-20 13:52:21.052085	Virrey del pino	\N
110	Espiritu Retro	11 5565-6951	CL-0100		2026-03-20 15:34:15.256075	Ituzaingó	\N
111	Florencia	11 5997-3935	CL-0101	\N	2026-03-20 16:41:21.165125	Wilde, Avellaneda	\N
112	Santa Elena	11 3850-8083	CL-0102	\N	2026-03-20 22:27:23.379646	\N	\N
113	Pablo	11 3852-2081	CL-0103	\N	2026-03-21 16:03:33.617358	Caballito	\N
114	Alejandra	11 3361-1723	CL-0104	\N	2026-03-21 20:05:36.946446	Lanus	\N
115	Mela Galvan	9 3405 50-2906	CL-0105	\N	2026-03-22 21:13:17.457613	\N	\N
117	Camila	11 2509-4491	CL-0107	\N	2026-03-23 11:26:15.412522	Morón	\N
118	Romina	11 3138-1065	CL-0108	\N	2026-03-23 11:43:03.274168	\N	\N
119	Yanina Paola Monzon	9 3489 59-4111	CL-0109	\N	2026-03-23 17:36:11.078518	Campana	\N
120	Selene	9 3471 60-8892	CL-0110	\N	2026-03-24 10:46:32.1605	Cañada de Gomes, Santa Fé	\N
121	Luciana Gomez	11 4066-5785	CL-0111	\N	2026-03-24 12:41:45.225419	Moreno	\N
122	Karo Zorio	11 2696-0435	CL-0112	\N	2026-03-24 16:16:52.763189	Villa Bosch	\N
123	Danii	11 3170-7406	CL-0113	\N	2026-03-24 20:47:50.437791	\N	\N
124	Clausol	9 3888 46-9000	CL-0114	\N	2026-03-24 20:48:09.451969	Jujuy	\N
125	Nico	11 3004-1140	CL-0115	\N	2026-03-25 12:43:15.45691	\N	\N
126	Natalia Pereyra	11 3111-7306	CL-0116	\N	2026-03-25 12:50:44.551874	Villa Celina	\N
127	Flor	11 3641-0321	CL-0117	\N	2026-03-25 14:12:58.341519	\N	\N
128	Ivana	11 5690-1769	CL-0118	\N	2026-03-25 19:15:05.341251	\N	\N
129	Furka Box	11 6214-1175	CL-0119	\N	2026-03-26 19:01:38.785891	villa Lugano	\N
130	Viviana Alamo	11 3085-7501	CL-0120	\N	2026-03-26 20:45:00.334385	\N	\N
131	Yassu	2920 36-1694	CL-0121	\N	2026-03-26 21:23:24.045061	Rio Negro	\N
132	Melina Carballeda	 2345 41-6793	CL-0122	\N	2026-03-27 16:21:53.069613	Saladillo	\N
133	Alejandro	11 3580-6500	CL-0123	\N	2026-03-27 20:54:50.836121	\N	\N
134	Andre	11 5982-0870	CL-0124	\N	2026-03-28 08:35:02.17373	San Isidro	\N
135	Vanesa Leone	11 6307-5766	CL-0125	\N	2026-03-28 09:21:41.49756	San Miguel	\N
136	Veronica Verón	3735 56-9748	CL-0126	\N	2026-03-28 11:15:41.481825	Chaco	\N
137	Juli	11 6848-9805	CL-0127	\N	2026-03-28 14:00:54.060514	San Fernando	\N
138	Chefy	11 6849-4699	CL-0128	\N	2026-03-28 14:21:35.45916	Avellaneda	\N
139	Samy	11 5325-6053	CL-0129	\N	2026-03-28 14:22:43.365931	Monte Chingolo	\N
140	Micaela	11 6920-5521	CL-0130	\N	2026-03-30 09:50:30.720997	\N	\N
141	Golden Closet	11 2525-8294	CL-0131	\N	2026-03-30 10:54:46.61975	\N	\N
142	Pets Club	11 2847-3468	CL-0132	\N	2026-03-31 09:11:10.550137	Ituzaingo	\N
143	Daniela Dusso	9 3405 51-0442	CL-0133	\N	2026-03-31 10:46:24.001469	Santa Fé	\N
144	Agus	11 5310-5792	CL-0134	\N	2026-04-01 08:04:12.31825	Laferrere	\N
145	Orita	11 6196-9161	CL-0135	\N	2026-04-01 10:19:30.466356	\N	\N
146	Eighteen	11 5220-9134	CL-0136	\N	2026-04-01 13:54:19.913118	Longchamps	\N
147	Maria Angela	2920 32-7936	CL-0137	\N	2026-04-03 12:00:36.803852	Carmen de Patagones	\N
148	Marcelo Peyrat	2625 41-4444	CL-0138	\N	2026-04-03 12:17:31.627513	Mendoza	\N
149	Vero	11 5318-0782	CL-0139	\N	2026-04-03 14:54:32.927858	\N	\N
150	Edu	2302 53-1564	CL-0140	\N	2026-04-03 20:17:03.522165	La Pampa	\N
151	Estefania	3402 52-7034	CL-0141	\N	2026-04-06 08:32:54.712138	Santa Fé	\N
152	Antonio	11 6286-0478	CL-0142	\N	2026-04-06 10:06:56.914013	San Cristobal, CABA	\N
153	Laurisima	3465 66-5503	CL-0143	\N	2026-04-06 13:31:49.038583	Santa Fé	\N
154	Patitas	3464 54-3526	CL-0144	\N	2026-04-06 13:51:00.691227	Santa Fé	\N
155	Lour	3412 51-5026	CL-0145	\N	2026-04-06 13:58:27.100632	Santa Fé	\N
156	Veronica	11 3598-9553	CL-0146	\N	2026-04-06 14:02:19.869455	Haedo	\N
157	Flor Rojas	11 6566-6427	CL-0147	\N	2026-04-07 19:45:29.817617	\N	\N
158	Araceli	11 2404-0543	CL-0148	\N	2026-04-08 14:44:44.332268	\N	\N
159	Matias CAEF	2235 85-4364	CL-0149	\N	2026-04-08 16:26:04.160923	Lomas de zamora	\N
160	Juann	3364 03-4572	CL-0150	\N	2026-04-08 17:03:08.647221	Santa Fé, Rosario	\N
161	Gaby	11 4446-5150	CL-0151	\N	2026-04-09 20:10:31.281096	\N	\N
162	Juan Gonzales	11 4176-8875	CL-0152	\N	2026-04-10 11:22:48.245001	\N	\N
163	Jorge Gswhindy	3416 54-8573	CL-0153	\N	2026-04-10 19:28:23.23298	Rosario, Santa Fé	\N
164	Noe	2364 53-4865	CL-0154	\N	2026-04-13 19:15:48.534463	Junin	\N
165	Tiari	1138897771	CL-0155	\N	2026-04-16 11:14:15.176147	\N	\N
166	Gafit	11 2655-8938	CL-0156	\N	2026-04-20 11:03:49.652465	\N	\N
167	Pau	11 3006-9942	CL-0157	\N	2026-04-22 13:22:21.737463	\N	\N
168	Mates del Mar	11 5850-1384	CL-0158	\N	2026-04-22 14:24:16.002078	\N	\N
169	Adela	3483 41-9927	CL-0159	\N	2026-04-24 09:36:01.533074	Vera, Santa Fé	\N
170	Brenda B	11 7117-6285	CL-0160	\N	2026-04-24 12:29:56.581804	\N	\N
171	Lia	11 5795-3969	CL-0161	\N	2026-04-24 13:52:17.290918	Tres de febrero	\N
172	Maru	11 5699-4164	CL-0162	\N	2026-04-25 15:01:18.837702	Hudson	\N
173	Ana Romero	11 3565-7008	CL-0163	\N	2026-04-26 17:09:16.849369	Temperley	\N
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
6	Abril 2026	2026-03-11	\N	f	2026-03-11 00:14:35.404162
7	Abril 2026	2026-03-20	\N	f	2026-03-20 08:27:41.004844
8	Abril 2026	2026-03-20	\N	f	2026-03-20 08:28:33.653524
9	Mayo	2026-04-22	\N	f	2026-04-22 13:34:38.217418
10	Mayo	2026-04-24	\N	t	2026-04-24 10:45:46.195146
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
52	8	300	203000.00	2026-04-23 19:30:47.512565	114900.00
53	8	400	264000.00	2026-04-23 19:31:00.306053	153200.00
54	8	500	320000.00	2026-04-23 19:31:16.496881	191500.00
14	2	100	46000.00	2026-04-23 19:33:57.894783	13300.00
15	2	200	72000.00	2026-04-23 19:34:11.602045	26600.00
16	2	300	98000.00	2026-04-23 19:34:24.472971	39900.00
17	2	400	134000.00	2026-04-23 19:34:36.697766	53200.00
18	2	500	160000.00	2026-04-23 19:34:50.331047	66500.00
20	3	100	48000.00	2026-04-23 19:35:19.463005	18400.00
21	3	200	83000.00	2026-04-23 19:35:34.515955	36800.00
22	3	300	118000.00	2026-04-23 19:35:46.076817	55200.00
23	3	400	157000.00	2026-04-23 19:35:57.866428	73600.00
24	3	500	197000.00	2026-04-23 19:36:16.889121	92000.00
32	5	100	56000.00	2026-04-23 19:36:39.744063	28100.00
33	5	200	96000.00	2026-04-23 19:36:57.074321	56200.00
34	5	300	137000.00	2026-04-23 19:37:08.825733	84300.00
35	5	400	183000.00	2026-04-23 19:37:21.022624	112400.00
36	5	500	228000.00	2026-04-23 19:37:31.340215	140500.00
7	1	50	33000.00	2026-04-24 10:42:41.061592	14550.00
13	2	50	27000.00	2026-04-24 10:42:54.547142	6650.00
19	3	50	30000.00	2026-04-24 10:43:05.386712	9200.00
25	4	50	31000.00	2026-04-24 10:43:14.439854	13100.00
31	5	50	35000.00	2026-04-24 10:43:27.417763	14050.00
43	7	50	36000.00	2026-04-24 10:43:45.423634	16850.00
49	8	50	39000.00	2026-04-24 10:43:59.210146	19150.00
26	4	100	58000.00	2026-04-23 19:26:23.840606	26200.00
27	4	200	105000.00	2026-04-23 19:26:41.888467	52400.00
28	4	300	146000.00	2026-04-23 19:26:58.765352	78600.00
29	4	400	192000.00	2026-04-23 19:27:15.200694	104800.00
30	4	500	238000.00	2026-04-23 19:27:31.633282	131000.00
8	1	100	61000.00	2026-04-23 19:27:54.377191	29100.00
9	1	200	111000.00	2026-04-23 19:28:05.379482	58200.00
10	1	300	165000.00	2026-04-23 19:28:16.108285	87300.00
11	1	400	218000.00	2026-04-23 19:28:25.853857	116400.00
12	1	500	272000.00	2026-04-23 19:28:38.470078	145500.00
44	7	100	64000.00	2026-04-23 19:29:07.939909	33700.00
45	7	200	124000.00	2026-04-23 19:29:17.210912	67400.00
46	7	300	176000.00	2026-04-23 19:29:33.665939	101100.00
47	7	400	233000.00	2026-04-23 19:29:44.601152	134800.00
48	7	500	290000.00	2026-04-23 19:29:53.622564	168500.00
50	8	100	71000.00	2026-04-23 19:30:23.092377	38300.00
51	8	200	137000.00	2026-04-23 19:30:36.149505	76600.00
56	9	100	83000.00	2026-04-23 19:31:39.052882	42000.00
57	9	200	161000.00	2026-04-23 19:31:53.911814	84000.00
58	9	300	239000.00	2026-04-23 19:32:05.065026	126000.00
59	9	400	317000.00	2026-04-23 19:32:19.332765	168000.00
60	9	500	395000.00	2026-04-23 19:32:30.557041	210000.00
62	10	100	86000.00	2026-04-23 19:32:52.733625	43000.00
63	10	200	165000.00	2026-04-23 19:33:05.926576	86000.00
64	10	300	243000.00	2026-04-23 19:33:17.259763	129000.00
65	10	400	321000.00	2026-04-23 19:33:29.164849	172000.00
66	10	500	400000.00	2026-04-23 19:33:39.894495	215000.00
55	9	50	44000.00	2026-04-24 10:44:11.373476	21000.00
61	10	50	46000.00	2026-04-24 10:44:28.844612	21500.00
\.


--
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.productos (id, tamano, tipo_asa, precio_base, activo, created_at, precio_venta_unitario, costo_unitario, costo_estampado_unitario, precio_proveedor_unitario) FROM stdin;
1	30x40	ASAS	500.00	t	2026-02-23 18:47:18.307792	\N	362.00	50	231
2	15x20	RINON	\N	t	2026-02-25 19:40:46.155152	\N	177.00	50	\N
3	20x30	RINON	\N	t	2026-02-25 19:40:46.155152	\N	206.00	50	\N
4	30x30	ASAS	\N	t	2026-02-25 19:40:46.155152	\N	312.00	50	\N
5	30x40	RINON	\N	t	2026-02-25 19:40:46.155152	\N	317.00	50	\N
7	45x40	ASAS	\N	t	2026-02-25 19:40:46.155152	\N	378.00	50	\N
8	50x40	ASAS	\N	t	2026-02-25 19:40:46.155152	\N	460.00	50	\N
9	60x40	ASAS	\N	t	2026-02-25 19:40:46.155152	\N	506.00	50	\N
10	60x50	ASAS	\N	t	2026-02-25 19:40:46.155152	\N	472.00	50	\N
\.


--
-- Data for Name: ventas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ventas (id, fecha, cliente_id, producto_id, cantidad, color_bolsa, color_estampa, doble_estampa, envio_domicilio, precio_final, sena, restante, costo_total, ganancia_total, ganancia_taller, ganancia_personal, fecha_entrega, factura, estado, created_at, arca, color_fila, etapa, mes_id, envio_monto, codigo_seguimiento) FROM stdin;
84	2026-03-05	45	7	100	Crudo	Negro	f	f	56000.00	28000.00	28000.00	33700.00	22300.00	1115.00	21185.00	2026-03-10	t	sena_pagada	2026-03-08 12:04:51.406684	f	\N	entregado	4	0	\N
104	2026-03-08	55	5	50	Negro	Fucsia	f	t	40000.00	20000.00	20000.00	14050.00	17950.00	897.50	17052.50	2026-03-13	f	sena_pagada	2026-03-08 15:51:05.49135	f	\N	entregado	5	0	\N
70	2026-03-03	37	1	50	Negro	Blanco	f	t	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-03-03	t	sena_pagada	2026-03-08 11:40:55.910226	f	\N	entregado	4	0	\N
72	2026-03-03	40	5	100	Celeste	Negro	f	t	58000.00	29000.00	29000.00	28100.00	21900.00	1095.00	20805.00	2026-03-03	t	sena_pagada	2026-03-08 11:42:26.832715	f	\N	entregado	4	0	\N
71	2026-03-03	39	1	50	Blanco	Negro	f	f	30000.00	15000.00	15000.00	14550.00	15450.00	772.50	14677.50	2026-03-03	t	sena_pagada	2026-03-08 11:41:25.93701	f	\N	entregado	4	0	\N
69	2026-03-02	38	9	100	Negro	Blanco	t	t	123500.00	61750.00	61750.00	42000.00	73500.00	3675.00	69825.00	2026-03-09	t	sena_pagada	2026-03-08 11:34:04.630865	f	\N	entregado	4	0	\N
57	2026-03-01	31	7	50	Negro	Blanco	f	t	41000.00	20500.00	20500.00	16850.00	24150.00	1207.50	22942.50	2026-03-02	t	sena_pagada	2026-03-08 01:35:32.631712	f	\N	entregado	4	0	\N
58	2026-03-01	32	1	50	Blanco	Negro	f	f	30000.00	15000.00	15000.00	14550.00	15450.00	772.50	14677.50	2026-03-02	t	sena_pagada	2026-03-08 11:15:46.013602	f	\N	entregado	4	0	\N
107	2026-03-08	57	7	50	Negro	Blanco	f	f	33000.00	16500.00	16500.00	16850.00	16150.00	807.50	15342.50	2026-03-13	f	sena_pagada	2026-03-08 22:13:33.069359	f	\N	entregado	5	0	\N
73	2026-03-03	41	1	100	Blanco	Rojo	f	f	48000.00	24000.00	24000.00	29100.00	18900.00	945.00	17955.00	2026-03-03	t	sena_pagada	2026-03-08 11:43:02.156312	f	\N	entregado	4	0	\N
74	2026-03-03	41	7	100	Blanco	Rojo	f	f	56000.00	28000.00	28000.00	33700.00	22300.00	1115.00	21185.00	2026-03-03	t	sena_pagada	2026-03-08 11:43:36.289121	f	\N	entregado	4	0	\N
59	2026-03-01	29	10	50	Crudo	Negro	f	f	41000.00	20500.00	20500.00	21500.00	19500.00	975.00	18525.00	2026-03-02	t	sena_pagada	2026-03-08 11:16:39.795018	f	\N	entregado	4	0	\N
77	2026-03-04	42	3	100	Negro	Blanco	f	f	42000.00	21000.00	21000.00	18400.00	23600.00	1180.00	22420.00	2026-03-09	t	sena_pagada	2026-03-08 11:45:22.367469	f	\N	entregado	4	0	\N
88	2026-03-06	46	1	50	Crudo	Negro	f	f	30000.00	15000.00	15000.00	14550.00	15450.00	772.50	14677.50	2026-03-10	t	sena_pagada	2026-03-08 12:07:44.35786	f	\N	entregado	4	0	\N
96	2026-03-07	51	1	100	Crudo	Negro	f	t	56000.00	28000.00	28000.00	29100.00	18900.00	945.00	17955.00	2026-03-11	t	sena_pagada	2026-03-08 12:16:31.185265	f	\N	entregado	4	0	\N
81	2026-03-04	44	2	50	Negro	Rosa	f	f	24000.00	12000.00	12000.00	6650.00	17350.00	867.50	16482.50	2026-03-09	t	sena_pagada	2026-03-08 12:00:47.417896	f	\N	entregado	4	0	\N
85	2026-03-05	45	8	100	Crudo	Negro	f	f	65000.00	32500.00	32500.00	38300.00	26700.00	1335.00	25365.00	2026-03-10	t	sena_pagada	2026-03-08 12:05:08.137126	f	\N	entregado	4	0	\N
95	2026-03-07	50	3	50	Blanco	Verde Agua	f	f	27000.00	13500.00	13500.00	9200.00	17800.00	890.00	16910.00	2026-03-11	t	sena_pagada	2026-03-08 12:15:23.097435	f	\N	entregado	4	0	\N
83	2026-03-05	45	4	100	Crudo	Negro	f	t	60000.00	30000.00	30000.00	26200.00	25800.00	1290.00	24510.00	2026-03-10	t	sena_pagada	2026-03-08 12:04:28.77589	f	\N	entregado	4	0	\N
79	2026-03-05	22	1	50	Negro	Blanco	f	t	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-03-09	t	sena_pagada	2026-03-08 11:57:42.778183	f	\N	entregado	4	0	\N
75	2026-03-04	42	10	50	Negro	Blanco	f	f	41000.00	20500.00	20500.00	21500.00	19500.00	975.00	18525.00	2026-03-09	t	sena_pagada	2026-03-08 11:44:35.430345	f	\N	entregado	4	0	\N
90	2026-03-06	47	4	100	Negro	Rosa	f	f	52000.00	26000.00	26000.00	26200.00	25800.00	1290.00	24510.00	2026-03-11	t	sena_pagada	2026-03-08 12:09:58.631037	f	\N	entregado	4	0	\N
87	2026-03-06	46	4	50	Crudo	Negro	f	f	28000.00	14000.00	14000.00	13100.00	14900.00	745.00	14155.00	2026-03-10	t	sena_pagada	2026-03-08 12:07:25.625559	f	\N	entregado	4	0	\N
65	2026-03-02	35	3	50	Blanco	Negro	f	t	35000.00	17500.00	17500.00	9200.00	17800.00	890.00	16910.00	2026-03-03	t	sena_pagada	2026-03-08 11:28:55.857915	f	\N	entregado	4	0	\N
63	2026-03-01	34	8	100	Negro	Blanco	f	f	65000.00	32500.00	32500.00	38300.00	26700.00	1335.00	25365.00	2026-03-02	t	sena_pagada	2026-03-08 11:19:31.647229	f	\N	entregado	4	0	\N
62	2026-03-01	34	1	100	Blanco	Negro	f	f	48000.00	24000.00	24000.00	29100.00	18900.00	945.00	17955.00	2026-03-02	t	sena_pagada	2026-03-08 11:19:08.457578	f	\N	entregado	4	0	\N
61	2026-03-01	34	4	100	Negro	Blanco	f	f	52000.00	26000.00	26000.00	26200.00	25800.00	1290.00	24510.00	2026-03-02	t	sena_pagada	2026-03-08 11:18:28.474991	f	\N	entregado	4	0	\N
60	2026-03-01	33	7	100	Negro	Blanco	f	f	56000.00	28000.00	28000.00	33700.00	22300.00	1115.00	21185.00	2026-03-02	t	sena_pagada	2026-03-08 11:17:27.365442	f	\N	entregado	4	0	\N
86	2026-03-06	46	3	50	Crudo	Negro	f	t	35000.00	17500.00	17500.00	9200.00	17800.00	890.00	16910.00	2026-03-10	t	sena_pagada	2026-03-08 12:07:05.91468	f	\N	entregado	4	0	\N
68	2026-03-02	36	3	50	Crudo	Marrón	f	f	27000.00	13500.00	13500.00	9200.00	17800.00	890.00	16910.00	2026-03-03	t	sena_pagada	2026-03-08 11:33:08.773604	f	\N	entregado	4	0	\N
67	2026-03-02	36	7	100	Crudo	Marrón	f	f	56000.00	28000.00	28000.00	33700.00	22300.00	1115.00	21185.00	2026-03-03	t	sena_pagada	2026-03-08 11:32:44.943298	f	\N	entregado	4	0	\N
66	2026-03-02	36	10	50	Crudo	Marrón	f	t	49000.00	24500.00	24500.00	21500.00	19500.00	975.00	18525.00	2026-03-03	t	sena_pagada	2026-03-08 11:31:45.452137	f	\N	entregado	4	0	\N
89	2026-03-06	47	7	100	Negro	Rosa	f	t	64000.00	32000.00	32000.00	33700.00	22300.00	1115.00	21185.00	2026-03-11	t	sena_pagada	2026-03-08 12:09:40.217007	f	\N	entregado	4	0	\N
92	2026-03-07	48	7	50	Amarillo	Negro	f	f	33000.00	16500.00	16500.00	16850.00	16150.00	807.50	15342.50	2026-03-11	t	sena_pagada	2026-03-08 12:12:04.548569	f	\N	entregado	4	0	\N
98	2026-03-07	52	4	100	Blanco	Dorado	f	f	52000.00	26000.00	26000.00	26200.00	25800.00	1290.00	24510.00	2026-03-12	f	sena_pagada	2026-03-08 12:17:48.014727	f	\N	entregado	4	0	\N
78	2026-03-04	43	1	200	Negro	Blanco	f	f	93000.00	46500.00	46500.00	58200.00	34800.00	1740.00	33060.00	2026-03-09	t	sena_pagada	2026-03-08 11:57:04.502191	f	\N	entregado	4	0	\N
93	2026-03-07	49	5	50	Rosa	Negro	f	t	40000.00	20000.00	20000.00	14050.00	17950.00	897.50	17052.50	2026-03-11	t	sena_pagada	2026-03-08 12:13:42.264452	f	\N	entregado	4	0	\N
91	2026-03-07	48	7	50	Fucsia	Negro	f	f	33000.00	16500.00	16500.00	16850.00	16150.00	807.50	15342.50	2026-03-11	t	sena_pagada	2026-03-08 12:11:52.277328	f	\N	entregado	4	0	\N
99	2026-03-07	52	8	100	Blanco	Dorado	f	f	65000.00	32500.00	32500.00	38300.00	26700.00	1335.00	25365.00	2026-03-12	f	sena_pagada	2026-03-08 12:18:08.695771	f	\N	entregado	4	0	\N
97	2026-03-07	52	2	50	Blanco	Dorado	f	t	32000.00	16000.00	16000.00	6650.00	17350.00	867.50	16482.50	2026-03-12	f	sena_pagada	2026-03-08 12:17:27.430627	f	\N	entregado	4	0	\N
80	2026-03-04	44	7	50	Rosa	Negro	f	t	41000.00	20500.00	20500.00	16850.00	16150.00	807.50	15342.50	2026-03-09	t	sena_pagada	2026-03-08 12:00:26.377704	f	\N	entregado	4	0	\N
101	2026-03-07	54	7	100	Rojo	Negro	t	t	92000.00	46000.00	46000.00	33700.00	50300.00	2515.00	47785.00	2026-03-12	f	sena_pagada	2026-03-08 12:22:26.580563	f	\N	entregado	4	0	\N
102	2026-03-07	54	7	100	Amarillo	Negro	t	f	84000.00	42000.00	42000.00	33700.00	50300.00	2515.00	47785.00	2026-03-12	f	sena_pagada	2026-03-08 12:22:41.93923	f	\N	entregado	4	0	\N
106	2026-03-08	57	4	100	Negro	Blanco	f	t	60000.00	30000.00	30000.00	26200.00	25800.00	1290.00	24510.00	2026-03-13	f	sena_pagada	2026-03-08 22:13:17.665071	f	\N	entregado	5	0	\N
94	2026-03-07	50	4	50	Blanco	Verde Agua	f	f	28000.00	14000.00	14000.00	13100.00	14900.00	745.00	14155.00	2026-03-11	t	sena_pagada	2026-03-08 12:15:01.452481	f	\N	entregado	4	0	\N
133	2026-03-10	68	3	100	Blanco	Negro	f	f	42000.00	21000.00	21000.00	18400.00	23600.00	1180.00	22420.00	2026-03-18	f	sena_pagada	2026-03-10 13:21:07.122248	f	\N	entregado	5	0	\N
156	2026-03-14	83	7	100	Negro	Blanco	f	f	69000.00	34500.00	34500.00	33700.00	22300.00	1115.00	21185.00	2026-03-20	f	sena_pagada	2026-03-14 13:44:25.056158	f	\N	entregado	6	13000	\N
111	2026-03-09	60	7	50	Crudo	Negro	f	t	41000.00	20500.00	20500.00	16850.00	16150.00	807.50	15342.50	2026-03-13	f	sena_pagada	2026-03-09 11:07:44.737781	f	\N	entregado	5	0	\N
110	2026-03-09	59	4	50	Blanco	Violeta	f	t	36000.00	18000.00	18000.00	13100.00	14900.00	745.00	14155.00	2026-03-13	f	sena_pagada	2026-03-09 10:37:24.267592	f	\N	entregado	5	0	\N
157	2026-03-14	84	2	100	Negro	Dorado	f	f	48000.00	24000.00	24000.00	13300.00	26700.00	1335.00	25365.00	2026-03-20	f	sena_pagada	2026-03-14 14:40:28.564598	f	\N	entregado	6	8000	\N
82	2026-03-04	44	3	50	Rosa	Negro	f	f	27000.00	13500.00	13500.00	9200.00	17800.00	890.00	16910.00	2026-03-09	t	sena_pagada	2026-03-08 12:01:31.750773	f	\N	entregado	4	0	\N
76	2026-03-04	42	1	50	Negro	Blanco	f	f	30000.00	15000.00	15000.00	14550.00	15450.00	772.50	14677.50	2026-03-09	t	sena_pagada	2026-03-08 11:45:04.934001	f	\N	entregado	4	0	\N
130	2026-03-09	66	1	100	Celeste	Negro	f	f	48000.00	24000.00	24000.00	29100.00	18900.00	945.00	17955.00	2026-03-17	f	sena_pagada	2026-03-09 21:30:04.780969	f	\N	entregado	5	0	\N
109	2026-03-09	58	1	50	Crudo	Marrón	f	t	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-03-13	f	sena_pagada	2026-03-09 10:22:09.310048	f	\N	entregado	5	0	\N
131	2026-03-10	67	8	50	Crudo	Negro	f	f	44000.00	22000.00	22000.00	19150.00	16850.00	842.50	16007.50	2026-03-16	f	sena_pagada	2026-03-10 13:15:20.830791	f	\N	entregado	5	8000	\N
128	2026-03-09	66	4	100	Fucsia	Negro	f	f	70000.00	35000.00	35000.00	26200.00	25800.00	1290.00	24510.00	2026-03-17	f	sena_pagada	2026-03-09 21:29:30.262786	f	\N	entregado	5	18000	00014508993333029281601
147	2026-03-12	77	8	100	Blanco	Negro	f	f	65000.00	32500.00	32500.00	38300.00	26700.00	1335.00	25365.00	2026-03-19	f	sena_pagada	2026-03-12 18:05:11.434798	f	\N	entregado	6	0	\N
141	2026-03-12	75	2	50	Blanco	Negro	f	f	24000.00	12000.00	12000.00	6650.00	17350.00	867.50	16482.50	2026-03-18	f	sena_pagada	2026-03-12 11:40:01.499747	f	\N	entregado	6	0	\N
113	2026-03-09	61	7	100	Blanco	Negro	f	f	56000.00	28000.00	28000.00	33700.00	22300.00	1115.00	21185.00	2026-03-13	f	sena_pagada	2026-03-09 12:52:06.429812	f	\N	entregado	5	0	\N
155	2026-03-14	81	4	50	Negro	Blanco	f	f	28000.00	14000.00	14000.00	13100.00	14900.00	745.00	14155.00	2026-03-20	f	sena_pagada	2026-03-14 12:53:39.995237	f	\N	entregado	6	0	\N
169	2026-03-16	88	4	50	Negro	Crema	f	f	28000.00	14000.00	14000.00	13100.00	14900.00	745.00	14155.00	2026-03-24	f	sena_pagada	2026-03-16 16:12:57.337596	f	\N	entregado	6	0	\N
116	2026-03-09	63	1	50	Rojo	Blanco	f	t	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-03-13	f	sena_pagada	2026-03-09 14:43:55.881577	f	\N	entregado	5	0	\N
112	2026-03-09	61	7	100	Negro	Blanco	f	t	64000.00	32000.00	32000.00	33700.00	22300.00	1115.00	21185.00	2026-03-13	f	sena_pagada	2026-03-09 12:51:45.423465	f	\N	entregado	5	0	\N
146	2026-03-12	77	4	50	Fucsia	Negro	f	f	36000.00	18000.00	18000.00	13100.00	14900.00	745.00	14155.00	2026-03-19	f	sena_pagada	2026-03-12 18:04:55.956631	f	\N	entregado	6	8000	\N
127	2026-03-09	65	3	100	Crudo	Bordó	f	f	42000.00	21000.00	21000.00	18400.00	23600.00	1180.00	22420.00	2026-03-16	f	sena_pagada	2026-03-09 21:02:47.130383	f	\N	entregado	5	0	\N
132	2026-03-10	68	2	50	Blanco	Negro	f	f	32000.00	16000.00	16000.00	6650.00	17350.00	867.50	16482.50	2026-03-17	f	sena_pagada	2026-03-10 13:20:52.828629	f	\N	entregado	5	8000	\N
118	2026-03-09	64	8	50	Crudo	Negro	f	t	44000.00	22000.00	22000.00	19150.00	16850.00	842.50	16007.50	2026-03-16	f	sena_pagada	2026-03-09 15:48:22.615098	f	\N	entregado	5	0	\N
168	2026-03-16	88	1	50	Negro	Crema	f	f	30000.00	15000.00	15000.00	14550.00	15450.00	772.50	14677.50	2026-03-24	f	sena_pagada	2026-03-16 16:12:43.398778	f	\N	entregado	6	0	\N
159	2026-03-15	85	1	50	Negro	Blanco	f	f	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-03-23	f	sena_pagada	2026-03-15 11:16:48.115202	f	\N	entregado	6	8000	\N
153	2026-03-13	80	2	50	Blanco	Negro	f	f	32000.00	16000.00	16000.00	6650.00	17350.00	867.50	16482.50	2026-03-20	f	sena_pagada	2026-03-13 21:27:12.664113	f	\N	entregado	6	8000	\N
115	2026-03-09	62	5	100	Crudo	Negro	f	t	58000.00	29000.00	29000.00	28100.00	21900.00	1095.00	20805.00	2026-03-16	f	sena_pagada	2026-03-09 13:18:10.391475	f	\N	entregado	5	0	\N
151	2026-03-12	76	5	200	Crudo	Negro	f	f	84000.00	42000.00	42000.00	56200.00	27800.00	1390.00	26410.00	2026-03-19	f	sena_pagada	2026-03-13 10:53:15.573679	f	\N	entregado	6	0	\N
154	2026-03-13	80	7	50	Rosa	Negro	f	f	33000.00	16500.00	16500.00	16850.00	16150.00	807.50	15342.50	2026-03-20	f	sena_pagada	2026-03-13 21:27:29.781857	f	\N	entregado	6	0	\N
100	2026-03-07	53	1	50	Crudo	Dorado	f	t	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-03-12	f	sena_pagada	2026-03-08 12:19:16.485071	f	\N	entregado	4	0	\N
137	2026-03-11	71	8	50	Crudo	Negro	f	f	46000.00	23000.00	23000.00	19150.00	16850.00	842.50	16007.50	2026-03-18	f	sena_pagada	2026-03-11 12:59:30.802609	f	\N	entregado	6	10000	00014508998388X47CAA801
139	2026-03-12	74	1	50	Negro	Blanco	f	f	30000.00	15000.00	15000.00	14550.00	15450.00	772.50	14677.50	2026-03-18	f	sena_pagada	2026-03-12 08:45:30.690887	f	\N	entregado	6	0	\N
152	2026-03-12	76	4	100	Crudo	Negro	f	f	52000.00	26000.00	26000.00	26200.00	25800.00	1290.00	24510.00	2026-03-19	f	sena_pagada	2026-03-13 10:53:30.589917	f	\N	entregado	6	0	\N
165	2026-03-16	86	1	50	Negro	Blanco	f	f	30000.00	15000.00	15000.00	14550.00	15450.00	772.50	14677.50	2026-03-23	f	sena_pagada	2026-03-16 11:50:47.831964	f	\N	entregado	6	0	\N
150	2026-03-12	76	5	200	Negro	Lila	f	f	99000.00	49500.00	49500.00	56200.00	27800.00	1390.00	26410.00	2026-03-19	f	sena_pagada	2026-03-13 10:52:59.115385	f	\N	entregado	6	15000	\N
134	2026-03-11	69	1	50	Crudo	Negro	f	f	40000.00	20000.00	20000.00	14550.00	15450.00	772.50	14677.50	2026-03-18	f	sena_pagada	2026-03-10 23:25:01.031485	f	\N	entregado	5	10000	000145089923G3M25C0A101
140	2026-03-12	75	1	50	Crudo	Negro	f	f	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-03-18	f	sena_pagada	2026-03-12 11:39:48.011732	f	\N	entregado	6	8000	\N
166	2026-03-16	86	2	50	Negro	Blanco	f	f	24000.00	12000.00	12000.00	6650.00	17350.00	867.50	16482.50	2026-03-23	f	sena_pagada	2026-03-16 11:51:02.230342	f	\N	entregado	6	0	\N
158	2026-03-14	79	1	100	Crudo	Negro	f	f	56000.00	28000.00	28000.00	29100.00	18900.00	945.00	17955.00	2026-03-20	f	sena_pagada	2026-03-14 19:27:56.913714	f	\N	entregado	6	8000	\N
149	2026-03-13	78	1	100	Rosa	Fucsia	f	f	56000.00	28000.00	28000.00	29100.00	18900.00	945.00	17955.00	2026-03-20	f	sena_pagada	2026-03-13 10:04:16.329563	f	\N	entregado	6	8000	\N
129	2026-03-09	66	7	100	Fucsia	Negro	f	f	56000.00	28000.00	28000.00	33700.00	22300.00	1115.00	21185.00	2026-03-17	f	sena_pagada	2026-03-09 21:29:46.661045	f	\N	entregado	5	0	\N
167	2026-03-16	86	3	50	Negro	Blanco	f	f	27000.00	13500.00	13500.00	9200.00	17800.00	890.00	16910.00	2026-03-23	f	sena_pagada	2026-03-16 11:51:22.694989	f	\N	entregado	6	0	\N
163	2026-03-16	87	7	50	Crudo	Marrón	f	f	41000.00	20500.00	20500.00	16850.00	16150.00	807.50	15342.50	2026-03-23	f	sena_pagada	2026-03-16 09:48:18.786091	f	\N	entregado	6	8000	\N
117	2026-03-09	63	1	50	Crudo	Negro	f	f	30000.00	15000.00	15000.00	14550.00	15450.00	772.50	14677.50	2026-03-13	f	sena_pagada	2026-03-09 14:44:09.277662	f	\N	entregado	5	0	\N
188	2026-03-17	96	4	50	Blanco	Negro	f	f	36000.00	18000.00	18000.00	13100.00	14900.00	745.00	14155.00	2026-03-26	f	sena_pagada	2026-03-17 17:16:47.283235	f	\N	entregado	6	8000	\N
193	2026-03-18	100	7	50	Blanco	Negro	f	f	33000.00	16500.00	16500.00	16850.00	16150.00	807.50	15342.50	2026-03-26	f	sena_pagada	2026-03-18 11:58:07.17362	f	\N	entregado	6	0	\N
225	2026-04-01	112	7	500	Rojo	Blanco	f	f	230000.00	115000.00	115000.00	150500.00	79500.00	3975.00	75525.00	2026-04-10	f	sena_pagada	2026-03-21 00:22:52.560016	f	\N	sena	8	0	\N
172	2026-03-16	90	3	50	Amarillo	Negro	f	f	27000.00	13500.00	13500.00	9200.00	17800.00	890.00	16910.00	2026-03-24	f	sena_pagada	2026-03-16 17:53:06.858314	f	\N	entregado	6	0	\N
203	2026-03-19	106	1	100	Blanco	Negro	f	f	56000.00	28000.00	28000.00	29100.00	18900.00	945.00	17955.00	2026-03-30	f	sena_pagada	2026-03-19 13:51:41.509028	f	\N	entregado	6	8000	\N
175	2026-03-17	93	4	50	Crudo	Negro	f	f	41000.00	20500.00	20500.00	13100.00	14900.00	745.00	14155.00	2026-03-25	f	sena_pagada	2026-03-17 08:33:56.854016	f	\N	entregado	6	13000	\N
178	2026-03-17	94	3	50	Naranja	Negro	f	f	27000.00	13500.00	13500.00	9200.00	17800.00	890.00	16910.00	2026-03-25	f	sena_pagada	2026-03-17 13:38:24.021948	f	\N	entregado	6	0	\N
195	2026-03-18	97	2	100	Negro	Amarillo Pastel	f	f	53000.00	26500.00	26500.00	13300.00	26700.00	1335.00	25365.00	2026-03-27	f	sena_pagada	2026-03-18 13:22:36.966904	f	\N	entregado	6	13000	\N
207	2026-04-01	109	1	50	Negro	Amarillo Pastel	f	f	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-04-01	f	sena_pagada	2026-03-20 13:52:42.688014	f	\N	entregado	8	8000	\N
126	2026-03-09	56	7	50	Negro	Dorado	f	f	42000.00	21000.00	21000.00	16850.00	16150.00	807.50	15342.50	2026-03-16	f	sena_pagada	2026-03-09 20:58:52.241282	f	\N	entregado	5	9000	000145089960723EM01A001
171	2026-03-16	90	1	100	Amarillo	Negro	f	f	61000.00	30500.00	30500.00	29100.00	18900.00	945.00	17955.00	2026-03-24	f	sena_pagada	2026-03-16 17:52:50.531731	f	\N	entregado	6	13000	\N
200	2026-03-18	104	1	200	Fucsia	Blanco	f	f	101000.00	50500.00	50500.00	58200.00	34800.00	1740.00	33060.00	2026-03-27	f	sena_pagada	2026-03-18 19:09:59.740096	f	\N	entregado	6	8000	\N
201	2026-03-18	104	7	100	Fucsia	Blanco	f	f	56000.00	28000.00	28000.00	33700.00	22300.00	1115.00	21185.00	2026-03-27	f	sena_pagada	2026-03-18 19:10:14.732874	f	\N	entregado	6	0	\N
183	2026-03-17	95	7	50	Crudo	Negro	f	f	41000.00	20500.00	20500.00	16850.00	16150.00	807.50	15342.50	2026-03-25	f	sena_pagada	2026-03-17 14:19:05.666472	f	\N	entregado	6	8000	\N
191	2026-03-18	99	4	100	Blanco	Negro	f	f	60000.00	30000.00	30000.00	26200.00	25800.00	1290.00	24510.00	2026-03-26	f	sena_pagada	2026-03-18 11:36:12.752618	f	\N	entregado	6	8000	\N
202	2026-03-19	105	7	50	Blanco	Negro	f	f	46000.00	23000.00	23000.00	16850.00	16150.00	807.50	15342.50	2026-03-27	f	sena_pagada	2026-03-19 12:36:06.606421	f	\N	entregado	6	13000	\N
208	2026-04-01	110	7	50	Negro	Blanco	f	f	41000.00	20500.00	20500.00	16850.00	16150.00	807.50	15342.50	2026-04-01	f	sena_pagada	2026-03-20 15:36:27.560886	f	\N	entregado	8	8000	\N
177	2026-03-17	94	3	50	Crudo	Negro	f	f	42000.00	21000.00	21000.00	9200.00	17800.00	890.00	16910.00	2026-03-25	f	sena_pagada	2026-03-17 13:38:10.593309	f	\N	entregado	6	15000	\N
189	2026-03-17	96	7	50	Blanco	Negro	f	f	33000.00	16500.00	16500.00	16850.00	16150.00	807.50	15342.50	2026-03-26	f	sena_pagada	2026-03-17 17:17:04.542928	f	\N	entregado	6	0	\N
170	2026-03-16	88	2	100	Negro	Crema	f	f	40000.00	20000.00	20000.00	13300.00	26700.00	1335.00	25365.00	2026-03-24	f	sena_pagada	2026-03-16 16:13:14.074024	f	\N	entregado	6	0	\N
176	2026-03-17	93	7	50	Crudo	Negro	f	f	33000.00	16500.00	16500.00	16850.00	16150.00	807.50	15342.50	2026-03-25	f	sena_pagada	2026-03-17 08:34:10.2807	f	\N	entregado	6	0	\N
187	2026-03-17	98	1	50	Blanco	Verde	f	f	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-03-26	f	sena_pagada	2026-03-17 15:50:21.429704	f	\N	entregado	6	8000	\N
206	2026-04-01	108	7	50	Negro	Fucsia	f	f	33000.00	16500.00	16500.00	16850.00	16150.00	807.50	15342.50	2026-04-01	f	sena_pagada	2026-03-20 13:28:43.164749	f	\N	entregado	8	0	\N
174	2026-03-16	92	7	50	Negro	Blanco	f	f	46000.00	23000.00	23000.00	16850.00	16150.00	807.50	15342.50	2026-03-25	f	sena_pagada	2026-03-16 19:37:01.73789	f	\N	entregado	6	13000	\N
197	2026-03-18	102	8	50	Negro	Blanco	f	f	46000.00	23000.00	23000.00	19150.00	16850.00	842.50	16007.50	2026-03-27	f	sena_pagada	2026-03-18 13:35:06.381741	f	\N	entregado	6	10000	\N
194	2026-03-18	101	1	50	Crudo	Negro	f	f	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-03-26	f	sena_pagada	2026-03-18 12:37:59.390327	f	\N	entregado	6	8000	\N
205	2026-04-01	107	7	50	Crudo	Negro	f	f	43000.00	21500.00	21500.00	16850.00	16150.00	807.50	15342.50	2026-04-01	f	sena_pagada	2026-03-20 08:29:08.464661	f	\N	entregado	8	10000	\N
192	2026-03-18	100	7	50	Blanco	Negro	f	f	46000.00	23000.00	23000.00	16850.00	16150.00	807.50	15342.50	2026-03-26	f	sena_pagada	2026-03-18 11:57:54.734879	f	\N	entregado	6	13000	\N
173	2026-03-16	91	7	100	Negro	Blanco	f	f	64000.00	32000.00	32000.00	33700.00	22300.00	1115.00	21185.00	2026-03-24	f	sena_pagada	2026-03-16 18:07:25.141414	f	\N	entregado	6	8000	\N
182	2026-03-17	94	7	50	Negro	Blanco	f	f	33000.00	16500.00	16500.00	16850.00	16150.00	807.50	15342.50	2026-03-25	f	sena_pagada	2026-03-17 14:18:35.864767	f	\N	entregado	6	0	\N
179	2026-03-17	94	7	50	Crudo	Negro	f	f	33000.00	16500.00	16500.00	16850.00	16150.00	807.50	15342.50	2026-03-25	f	sena_pagada	2026-03-17 13:38:45.715932	f	\N	entregado	6	0	\N
224	2026-04-01	112	7	500	Rojo	Blanco	f	f	230000.00	115000.00	115000.00	150500.00	79500.00	3975.00	75525.00	2026-04-10	f	sena_pagada	2026-03-21 00:22:39.985181	f	\N	sena	8	0	\N
223	2026-04-01	112	7	500	Rojo	Blanco	f	f	230000.00	115000.00	115000.00	150500.00	79500.00	3975.00	75525.00	2026-04-10	f	sena_pagada	2026-03-21 00:22:14.919359	f	\N	sena	8	0	\N
222	2026-04-01	112	7	500	Rojo	Blanco	f	f	230000.00	115000.00	115000.00	150500.00	79500.00	3975.00	75525.00	2026-04-10	f	sena_pagada	2026-03-21 00:22:02.657776	f	\N	sena	8	0	\N
221	2026-04-01	112	7	500	Rojo	Blanco	f	f	230000.00	115000.00	115000.00	150500.00	79500.00	3975.00	75525.00	2026-04-10	f	sena_pagada	2026-03-21 00:21:47.016685	f	\N	sena	8	0	\N
220	2026-04-01	112	7	500	Rojo	Blanco	f	f	230000.00	115000.00	115000.00	150500.00	79500.00	3975.00	75525.00	2026-04-10	f	sena_pagada	2026-03-21 00:21:29.565217	f	\N	sena	8	0	\N
219	2026-04-01	112	7	500	Rojo	Blanco	f	f	230000.00	115000.00	115000.00	150500.00	79500.00	3975.00	75525.00	2026-04-10	f	sena_pagada	2026-03-21 00:21:07.389556	f	\N	sena	8	0	\N
218	2026-04-01	112	7	500	Rojo	Blanco	f	f	230000.00	115000.00	115000.00	150500.00	79500.00	3975.00	75525.00	2026-04-10	f	sena_pagada	2026-03-21 00:20:49.830148	f	\N	sena	8	0	\N
217	2026-04-01	112	7	500	Rojo	Blanco	f	f	230000.00	115000.00	115000.00	150500.00	79500.00	3975.00	75525.00	2026-04-10	f	sena_pagada	2026-03-21 00:20:33.823261	f	\N	sena	8	0	\N
216	2026-04-01	112	7	500	Rojo	Blanco	f	f	230000.00	115000.00	115000.00	150500.00	79500.00	3975.00	75525.00	2026-04-10	f	sena_pagada	2026-03-21 00:20:16.891048	f	\N	sena	8	0	\N
209	2026-04-01	111	7	50	Negro	Blanco	f	f	41000.00	20500.00	20500.00	16850.00	16150.00	807.50	15342.50	2026-04-01	f	sena_pagada	2026-03-20 16:41:39.538944	f	\N	entregado	8	8000	\N
239	2026-04-01	121	8	50	Crudo	Negro	f	f	36000.00	18000.00	18000.00	19150.00	16850.00	842.50	16007.50	2026-04-02	f	sena_pagada	2026-03-24 12:43:28.315226	f	\N	entregado	8	0	\N
261	2026-04-01	134	5	50	Azul Marino	Blanco	f	f	32000.00	16000.00	16000.00	14900.00	17100.00	855.00	16245.00	2026-04-08	f	sena_pagada	2026-03-28 08:35:37.22832	f	\N	entregado	8	0	\N
230	2026-04-01	114	7	100	Fucsia	Negro	f	f	56000.00	28000.00	28000.00	33700.00	22300.00	1115.00	21185.00	2026-04-02	f	sena_pagada	2026-03-22 20:53:44.268246	f	\N	entregado	8	0	\N
234	2026-04-01	117	7	50	Blanco	Negro	f	f	33000.00	16500.00	16500.00	16850.00	16150.00	807.50	15342.50	2026-04-02	f	sena_pagada	2026-03-23 11:45:32.914994	f	\N	entregado	8	0	\N
285	2026-04-01	143	1	100	Crudo	Negro	f	f	61000.00	30500.00	30500.00	30600.00	17400.00	870.00	16530.00	2026-04-10	f	sena_pagada	2026-03-31 10:53:41.30725	f	\N	entregado	8	13000	\N
255	2026-04-01	131	3	50	Blanco	Negro	f	f	40000.00	20000.00	20000.00	9550.00	17450.00	872.50	16577.50	2026-04-07	f	sena_pagada	2026-03-26 21:23:51.425424	f	\N	entregado	8	13000	\N
245	2026-04-01	123	7	50	Blanco	Negro	f	f	33000.00	16500.00	16500.00	16850.00	16150.00	807.50	15342.50	2026-04-03	f	sena_pagada	2026-03-24 21:06:16.365917	f	\N	entregado	8	0	\N
287	2026-04-01	84	4	100	Negro	Dorado	f	f	60000.00	30000.00	30000.00	27800.00	24200.00	1210.00	22990.00	2026-04-10	f	sena_pagada	2026-04-01 07:59:10.201138	f	\N	entregado	8	8000	\N
229	2026-04-01	114	7	100	Negro	Blanco	f	f	64000.00	32000.00	32000.00	33700.00	22300.00	1115.00	21185.00	2026-04-02	f	sena_pagada	2026-03-22 20:53:24.271772	f	\N	entregado	8	8000	\N
247	2026-04-01	60	4	50	Crudo	Negro	f	f	28000.00	14000.00	14000.00	13100.00	14900.00	745.00	14155.00	2026-04-03	f	sena_pagada	2026-03-24 21:12:24.195574	f	\N	entregado	8	0	\N
268	2026-04-01	138	8	50	Negro	Blanco	f	f	44000.00	22000.00	22000.00	19650.00	16350.00	817.50	15532.50	2026-04-09	f	sena_pagada	2026-03-28 14:21:55.58026	f	\N	entregado	8	8000	\N
226	2026-04-01	113	1	50	Crudo	Negro	f	f	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-04-01	f	sena_pagada	2026-03-21 16:03:52.439133	f	\N	entregado	8	8000	\N
272	2026-04-01	133	1	50	Crudo	Celeste / Verde agua	f	f	38000.00	19000.00	19000.00	15300.00	14700.00	735.00	13965.00	2026-04-07	f	sena_pagada	2026-03-28 18:44:47.096611	f	\N	entregado	8	8000	\N
240	2026-04-01	122	4	50	Fucsia	Negro	f	f	36000.00	18000.00	18000.00	13100.00	14900.00	745.00	14155.00	2026-04-03	f	sena_pagada	2026-03-24 16:17:09.840367	f	\N	entregado	8	8000	\N
276	2026-04-01	141	1	100	Negro	Dorado	f	f	56000.00	28000.00	28000.00	30600.00	17400.00	870.00	16530.00	2026-04-07	f	sena_pagada	2026-03-30 10:56:09.425512	f	\N	entregado	8	8000	\N
244	2026-04-01	123	5	50	Blanco	Negro	f	f	40000.00	20000.00	20000.00	14050.00	17950.00	897.50	17052.50	2026-04-03	f	sena_pagada	2026-03-24 21:05:57.112813	f	\N	entregado	8	8000	\N
249	2026-04-01	126	9	50	Negro	Amarillo Pastel	f	f	49000.00	24500.00	24500.00	21000.00	20000.00	1000.00	19000.00	2026-04-03	f	sena_pagada	2026-03-25 12:51:22.777436	f	\N	entregado	8	8000	\N
282	2026-04-01	142	7	100	Crudo	Negro	f	f	64000.00	32000.00	32000.00	34700.00	21300.00	1065.00	20235.00	2026-04-10	f	sena_pagada	2026-03-31 09:12:12.818985	f	\N	entregado	8	8000	\N
262	2026-04-01	134	7	100	Azul Marino	Blanco	f	f	56000.00	28000.00	28000.00	34700.00	21300.00	1065.00	20235.00	2026-04-08	f	sena_pagada	2026-03-28 08:35:54.536708	f	\N	entregado	8	0	\N
241	2026-04-01	122	7	50	Fucsia	Negro	f	f	33000.00	16500.00	16500.00	16850.00	16150.00	807.50	15342.50	2026-04-03	f	sena_pagada	2026-03-24 16:17:21.766151	f	\N	entregado	8	0	\N
235	2026-04-01	64	3	50	Crudo	Negro	f	f	35000.00	17500.00	17500.00	9200.00	17800.00	890.00	16910.00	2026-04-02	f	sena_pagada	2026-03-23 13:49:55.850186	f	\N	entregado	8	8000	\N
254	2026-04-01	130	7	100	Negro	Dorado	f	f	64000.00	32000.00	32000.00	34700.00	21300.00	1065.00	20235.00	2026-04-07	f	sena_pagada	2026-03-26 20:45:35.357997	f	\N	entregado	8	8000	\N
243	2026-04-01	22	1	50	Negro	Blanco	f	f	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-04-03	f	sena_pagada	2026-03-24 18:47:45.774059	f	\N	entregado	8	8000	\N
256	2026-04-01	132	1	100	Fucsia	Blanco	f	f	61000.00	30500.00	30500.00	30600.00	17400.00	870.00	16530.00	2026-04-07	f	sena_pagada	2026-03-27 16:22:15.81313	f	\N	entregado	8	13000	\N
260	2026-04-01	134	3	50	Azul Marino	Blanco	f	f	35000.00	17500.00	17500.00	9550.00	17450.00	872.50	16577.50	2026-04-08	f	sena_pagada	2026-03-28 08:35:23.389823	f	\N	entregado	8	8000	\N
267	2026-04-01	137	1	50	Blanco	Negro	f	f	38000.00	19000.00	19000.00	15300.00	14700.00	735.00	13965.00	2026-04-08	f	sena_pagada	2026-03-28 14:02:37.250156	f	\N	entregado	8	8000	\N
266	2026-04-01	136	3	50	Blanco	Negro	f	f	40000.00	20000.00	20000.00	9550.00	17450.00	872.50	16577.50	2026-04-08	f	sena_pagada	2026-03-28 11:16:03.960459	f	\N	entregado	8	13000	\N
277	2026-04-01	73	1	100	Fucsia	Negro	f	f	63000.00	31500.00	31500.00	30600.00	17400.00	870.00	16530.00	2026-04-07	f	sena_pagada	2026-03-30 10:59:30.528302	f	\N	entregado	8	15000	\N
251	2026-04-01	128	3	500	Azul Marino	Amarillo Anaranjado	f	f	175000.00	87500.00	87500.00	95500.00	71500.00	3575.00	67925.00	2026-04-04	f	sena_pagada	2026-03-25 19:15:38.330035	f	\N	entregado	8	8000	\N
269	2026-04-01	139	4	100	Crudo	Negro	f	f	60000.00	30000.00	30000.00	27800.00	24200.00	1210.00	22990.00	2026-04-09	f	sena_pagada	2026-03-28 14:23:01.837191	f	\N	entregado	8	8000	\N
237	2026-04-01	120	4	50	Negro	Blanco	f	f	41000.00	20500.00	20500.00	13100.00	14900.00	745.00	14155.00	2026-04-02	f	sena_pagada	2026-03-24 10:46:57.801284	f	\N	entregado	8	13000	00014508993G388CXIG1301
250	2026-04-01	127	7	50	Negro	Blanco	f	f	41000.00	20500.00	20500.00	17350.00	15650.00	782.50	14867.50	2026-04-06	f	sena_pagada	2026-03-25 14:15:57.446449	f	\N	entregado	8	8000	\N
253	2026-04-01	129	3	100	Crudo	Negro	f	f	50000.00	25000.00	25000.00	19100.00	22900.00	1145.00	21755.00	2026-04-06	f	sena_pagada	2026-03-26 19:02:21.07634	f	\N	entregado	8	8000	\N
273	2026-04-01	133	10	50	Negro	Blanco	f	f	41000.00	20500.00	20500.00	21500.00	19500.00	975.00	18525.00	2026-04-07	f	sena_pagada	2026-03-28 18:45:01.141545	f	\N	entregado	8	0	\N
236	2026-04-01	119	3	50	Blanco	Negro	f	f	35001.00	17500.50	17500.50	9200.00	17800.00	890.00	16910.00	2026-04-02	f	sena_pagada	2026-03-23 17:36:38.62795	f	\N	entregado	8	8001	\N
275	2026-04-01	140	1	50	Blanco	Negro	f	f	30000.00	15000.00	15000.00	15300.00	14700.00	735.00	13965.00	2026-04-07	f	sena_pagada	2026-03-30 10:47:51.905261	f	\N	entregado	8	0	\N
286	2026-04-01	85	8	50	Negro	Blanco	f	f	44000.00	22000.00	22000.00	19650.00	16350.00	817.50	15532.50	2026-04-10	f	sena_pagada	2026-03-31 12:32:36.498148	f	\N	entregado	8	8000	\N
248	2026-04-01	125	1	100	Crudo	Negro	f	f	56000.00	28000.00	28000.00	30600.00	17400.00	870.00	16530.00	2026-04-03	f	sena_pagada	2026-03-25 12:43:34.87471	f	\N	entregado	8	8000	\N
238	2026-04-01	121	1	50	Crudo	Negro	f	f	38000.00	19000.00	19000.00	14550.00	15450.00	772.50	14677.50	2026-04-02	f	sena_pagada	2026-03-24 12:42:01.610414	f	\N	entregado	8	8000	\N
284	2026-04-01	124	1	50	Negro	Blanco	f	f	43000.00	21500.00	21500.00	15300.00	14700.00	735.00	13965.00	2026-04-10	f	sena_pagada	2026-03-31 10:26:07.812592	f	\N	entregado	8	13000	\N
280	2026-04-01	89	7	100	Negro	Dorado	f	f	64000.00	32000.00	32000.00	34700.00	21300.00	1065.00	20235.00	2026-04-10	f	sena_pagada	2026-03-30 16:16:57.465881	f	\N	entregado	8	8000	\N
274	2026-04-01	140	3	50	Blanco	Negro	f	f	35000.00	17500.00	17500.00	9550.00	17450.00	872.50	16577.50	2026-04-07	f	sena_pagada	2026-03-30 10:47:36.601167	f	\N	entregado	8	8000	\N
252	2026-04-01	52	2	300	Blanco	Dorado	f	f	88000.00	44000.00	44000.00	42000.00	38000.00	1900.00	36100.00	2026-04-06	f	sena_pagada	2026-03-26 18:40:38.546344	f	\N	entregado	8	8000	\N
278	2026-04-01	73	7	100	Negro	Blanco	f	f	56000.00	28000.00	28000.00	34700.00	21300.00	1065.00	20235.00	2026-04-07	f	sena_pagada	2026-03-30 11:00:48.078486	f	\N	entregado	8	0	\N
331	2026-04-13	67	7	100	Crudo	Negro	f	f	66000.00	33000.00	33000.00	34700.00	23300.00	1165.00	22135.00	2026-04-21	f	sena_pagada	2026-04-13 12:37:02.502205	f	\N	entregado	8	8000	\N
295	2026-04-03	147	7	50	Crudo	Negro	f	f	33000.00	16500.00	16500.00	17350.00	15650.00	782.50	14867.50	2026-04-11	f	sena_pagada	2026-04-03 12:01:45.44347	f	\N	terminado	8	0	\N
316	2026-04-06	156	1	50	Crudo	Bordó	f	f	38000.00	19000.00	19000.00	15300.00	14700.00	735.00	13965.00	2026-04-15	f	sena_pagada	2026-04-06 14:02:52.461997	f	\N	entregado	8	8000	\N
290	2026-04-01	144	4	50	Crudo	Negro	f	f	36000.00	18000.00	18000.00	13900.00	14100.00	705.00	13395.00	2026-04-11	f	sena_pagada	2026-04-01 11:16:22.249923	f	\N	entregado	8	8000	\N
318	2026-04-07	157	7	50	Crudo	Negro	f	f	33000.00	16500.00	16500.00	17350.00	15650.00	782.50	14867.50	2026-04-15	f	sena_pagada	2026-04-07 19:52:36.998781	f	\N	entregado	8	0	\N
329	2026-04-10	163	9	100	Blanco	Azul Marino	f	f	92000.00	46000.00	46000.00	42000.00	35000.00	1750.00	33250.00	2026-04-20	f	sena_pagada	2026-04-10 22:06:04.881449	f	\N	sena	8	15000	\N
298	2026-04-03	149	1	100	Crudo	Negro	f	f	56000.00	28000.00	28000.00	30600.00	17400.00	870.00	16530.00	2026-04-13	f	sena_pagada	2026-04-03 14:54:57.731315	f	\N	entregado	8	8000	\N
330	2026-04-10	163	5	50	Blanco	Azul Marino	f	f	32000.00	16000.00	16000.00	14900.00	17100.00	855.00	16245.00	2026-04-20	f	sena_pagada	2026-04-10 22:06:21.765476	f	\N	sena	8	0	\N
322	2026-04-09	158	9	100	Negro	Blanco	f	f	85000.00	42500.00	42500.00	42000.00	35000.00	1750.00	33250.00	2026-04-16	f	sena_pagada	2026-04-09 12:42:46.63045	f	\N	entregado	8	8000	\N
321	2026-04-08	160	1	50	Rojo	Crema	f	f	30000.00	15000.00	15000.00	15300.00	14700.00	735.00	13965.00	2026-04-16	f	sena_pagada	2026-04-08 17:11:28.119096	f	\N	terminado	8	0	\N
326	2026-04-09	41	1	100	Blanco	Rojo	f	f	55000.00	27500.00	27500.00	30600.00	24400.00	1220.00	23180.00	2026-04-17	f	sena_pagada	2026-04-09 20:17:28.440572	f	\N	entregado	8	0	\N
325	2026-04-09	161	3	50	Blanco	Negro	f	f	27000.00	13500.00	13500.00	9550.00	17450.00	872.50	16577.50	2026-04-17	f	sena_pagada	2026-04-09 20:11:00.981406	f	\N	entregado	8	0	\N
302	2026-04-04	24	8	200	Crudo	Negro	f	f	125000.00	62500.00	62500.00	78600.00	46400.00	2320.00	44080.00	2026-04-14	f	sena_pagada	2026-04-04 12:27:15.939809	f	\N	entregado	8	0	\N
338	2026-04-16	165	2	50	Negro	Blanco	f	f	32000.00	16000.00	16000.00	7000.00	17000.00	850.00	16150.00	2026-04-24	f	sena_pagada	2026-04-16 11:16:40.314694	f	\N	entregado	8	8000	\N
257	2026-04-01	132	7	100	Fucsia	Blanco	f	f	56000.00	28000.00	28000.00	34700.00	21300.00	1065.00	20235.00	2026-04-07	f	sena_pagada	2026-03-27 16:22:31.019895	f	\N	entregado	8	0	\N
293	2026-04-03	147	3	50	Crudo	Negro	f	f	27000.00	13500.00	13500.00	9550.00	17450.00	872.50	16577.50	2026-04-11	f	sena_pagada	2026-04-03 12:01:23.755338	f	\N	terminado	8	0	\N
339	2026-04-16	165	5	50	Negro	Blanco	f	f	32000.00	16000.00	16000.00	14900.00	17100.00	855.00	16245.00	2026-04-24	f	sena_pagada	2026-04-16 11:16:54.544011	f	\N	entregado	8	0	\N
303	2026-04-04	24	9	50	Crudo	Negro	f	f	41000.00	20500.00	20500.00	21000.00	20000.00	1000.00	19000.00	2026-04-14	f	sena_pagada	2026-04-04 12:27:30.952972	f	\N	entregado	8	0	\N
304	2026-04-06	151	3	50	Blanco	Marrón Claro	f	f	40000.00	20000.00	20000.00	9550.00	17450.00	872.50	16577.50	2026-04-14	f	sena_pagada	2026-04-06 08:33:17.445373	f	\N	terminado	8	13000	\N
301	2026-04-03	150	1	200	Negro	Dorado	f	f	108000.00	54000.00	54000.00	61200.00	31800.00	1590.00	30210.00	2026-04-13	f	sena_pagada	2026-04-03 20:19:32.575788	f	\N	terminado	8	15000	\N
300	2026-04-01	118	7	50	Blanco	Negro	f	f	33000.00	16500.00	16500.00	17350.00	15650.00	782.50	14867.50	2026-04-06	f	sena_pagada	2026-04-03 16:58:14.225189	f	\N	entregado	8	0	\N
299	2026-04-01	118	1	50	Blanco	Negro	f	f	38000.00	19000.00	19000.00	15300.00	14700.00	735.00	13965.00	2026-04-06	f	sena_pagada	2026-04-03 16:57:50.397992	f	\N	entregado	8	8000	\N
332	2026-04-13	164	3	50	Crudo	Marrón	f	f	40000.00	20000.00	20000.00	9550.00	17450.00	872.50	16577.50	2026-04-23	f	sena_pagada	2026-04-13 19:16:56.812485	f	\N	sena	8	13000	\N
327	2026-04-01	162	7	50	Crudo	Negro	f	f	33000.00	16500.00	16500.00	17350.00	15650.00	782.50	14867.50	2026-04-10	f	sena_pagada	2026-04-10 11:23:09.43658	f	\N	entregado	8	0	\N
305	2026-04-06	152	1	50	Negro	Blanco	f	f	38000.00	19000.00	19000.00	15300.00	14700.00	735.00	13965.00	2026-04-14	f	sena_pagada	2026-04-06 10:07:31.908987	f	\N	entregado	8	8000	\N
333	2026-04-13	164	5	100	Crudo	Marrón	f	f	50000.00	25000.00	25000.00	29800.00	20200.00	1010.00	19190.00	2026-04-23	f	sena_pagada	2026-04-13 19:17:17.752877	f	\N	sena	8	0	\N
334	2026-04-13	164	9	50	Crudo	Marrón	f	f	41000.00	20500.00	20500.00	21000.00	20000.00	1000.00	19000.00	2026-04-23	f	sena_pagada	2026-04-13 19:17:37.184397	f	\N	sena	8	0	\N
320	2026-04-08	160	1	50	Crudo	Verde Oscuro	f	f	45000.00	22500.00	22500.00	15300.00	14700.00	735.00	13965.00	2026-04-16	f	sena_pagada	2026-04-08 17:11:17.395611	f	\N	terminado	8	15000	\N
307	2026-04-06	153	1	50	Amarillo	Negro	f	f	43000.00	21500.00	21500.00	15300.00	14700.00	735.00	13965.00	2026-04-15	f	sena_pagada	2026-04-06 13:32:29.082979	f	\N	terminado	8	13000	\N
328	2026-04-10	99	4	300	Blanco	Negro	f	f	136000.00	68000.00	68000.00	83400.00	44600.00	2230.00	42370.00	2026-04-20	f	sena_pagada	2026-04-10 18:46:42.451303	f	\N	entregado	8	8000	\N
306	2026-04-06	152	7	50	Negro	Blanco	f	f	33000.00	16500.00	16500.00	17350.00	15650.00	782.50	14867.50	2026-04-14	f	sena_pagada	2026-04-06 10:07:43.628283	f	\N	entregado	8	0	\N
312	2026-04-06	155	7	50	Negro	Blanco	f	f	33000.00	16500.00	16500.00	17350.00	15650.00	782.50	14867.50	2026-04-15	f	sena_pagada	2026-04-06 13:59:21.382489	f	\N	terminado	8	0	\N
337	2026-04-15	22	1	100	Negro	Blanco	f	f	63000.00	31500.00	31500.00	30600.00	24400.00	1220.00	23180.00	2026-04-24	f	sena_pagada	2026-04-15 14:55:21.898715	f	\N	terminado	8	8000	\N
292	2026-04-03	147	2	50	Blanco	Negro	f	f	37000.00	18500.00	18500.00	7000.00	17000.00	850.00	16150.00	2026-04-11	f	sena_pagada	2026-04-03 12:01:08.380122	f	\N	terminado	8	13000	\N
289	2026-04-01	145	1	50	Blanco	Crema	f	f	30000.00	15000.00	15000.00	15300.00	14700.00	735.00	13965.00	2026-04-10	f	sena_pagada	2026-04-01 10:34:51.231094	f	\N	entregado	8	0	\N
294	2026-04-03	147	4	50	Crudo	Negro	f	f	28000.00	14000.00	14000.00	13900.00	14100.00	705.00	13395.00	2026-04-11	f	sena_pagada	2026-04-03 12:01:36.210175	f	\N	terminado	8	0	\N
319	2026-04-08	159	7	50	Crudo	Marrón	f	f	41000.00	20500.00	20500.00	17350.00	15650.00	782.50	14867.50	2026-04-16	f	sena_pagada	2026-04-08 16:26:24.32945	f	\N	entregado	8	8000	\N
340	2026-04-20	166	4	100	Rosa	Rojo	f	f	52000.00	26000.00	26000.00	27800.00	24200.00	1210.00	22990.00	2026-04-30	f	sena_pagada	2026-04-20 11:04:08.815536	f	\N	sena	8	0	\N
341	2026-04-20	166	7	100	Rosa	Rojo	f	f	58000.00	29000.00	29000.00	34700.00	23300.00	1165.00	22135.00	2026-04-30	f	sena_pagada	2026-04-20 11:04:21.618086	f	\N	sena	8	0	\N
308	2026-04-06	153	7	50	Amarillo	Negro	f	f	33000.00	16500.00	16500.00	17350.00	15650.00	782.50	14867.50	2026-04-15	f	sena_pagada	2026-04-06 13:32:42.728669	f	\N	terminado	8	0	\N
323	2026-04-09	114	2	100	Negro	Blanco	f	f	48000.00	24000.00	24000.00	14000.00	26000.00	1300.00	24700.00	2026-04-17	f	sena_pagada	2026-04-09 19:40:29.356909	f	\N	entregado	8	8000	\N
311	2026-04-06	155	1	50	Negro	Blanco	f	f	43000.00	21500.00	21500.00	15300.00	14700.00	735.00	13965.00	2026-04-15	f	sena_pagada	2026-04-06 13:59:10.339609	f	\N	terminado	8	13000	\N
351	2026-05-01	169	3	50	Negro	Rosa	f	f	43000.00	21500.00	21500.00	10300.00	19700.00	985.00	18715.00	2026-05-04	f	sena_pagada	2026-04-24 10:47:45.237072	f	\N	comprar	10	13000	\N
352	2026-05-01	169	7	50	Negro	Rosa	f	f	36000.00	18000.00	18000.00	18900.00	17100.00	855.00	16245.00	2026-05-04	f	sena_pagada	2026-04-24 10:48:01.531768	f	\N	comprar	10	0	\N
353	2026-05-01	107	3	50	Negro	Dorado	f	f	43000.00	21500.00	21500.00	10300.00	19700.00	985.00	18715.00	2026-05-04	f	sena_pagada	2026-04-24 10:48:26.934145	f	\N	comprar	10	13000	\N
350	2026-05-01	168	3	100	Negro	Blanco	f	f	42000.00	21000.00	21000.00	20600.00	21400.00	1070.00	20330.00	2026-05-04	f	sena_pagada	2026-04-24 10:47:13.104851	f	\N	comprar	10	0	\N
349	2026-05-01	167	7	50	Crudo	Negro	f	f	33000.00	16500.00	16500.00	18900.00	14100.00	705.00	13395.00	2026-05-04	f	sena_pagada	2026-04-24 10:46:42.165223	f	\N	comprar	10	0	\N
348	2026-05-01	167	5	100	Crudo	Negro	f	f	58000.00	29000.00	29000.00	31700.00	26300.00	1315.00	24985.00	2026-05-04	f	sena_pagada	2026-04-24 10:46:26.67275	f	\N	comprar	10	8000	\N
354	2026-05-01	170	7	100	Negro	Blanco	f	f	64000.00	32000.00	32000.00	37800.00	26200.00	1310.00	24890.00	2026-05-05	f	sena_pagada	2026-04-24 12:30:26.585579	f	\N	comprar	10	0	\N
355	2026-05-01	171	7	50	Negro	Rosa	f	f	44000.00	22000.00	22000.00	18900.00	17100.00	855.00	16245.00	2026-05-05	f	sena_pagada	2026-04-24 13:52:40.036168	f	\N	comprar	10	8000	\N
356	2026-05-01	171	8	50	Negro	Rosa	f	f	39000.00	19500.00	19500.00	23000.00	16000.00	800.00	15200.00	2026-05-05	f	sena_pagada	2026-04-24 13:52:52.128699	f	\N	comprar	10	0	\N
357	2026-05-01	172	7	50	Negro	Dorado	f	f	44000.00	22000.00	22000.00	18900.00	17100.00	855.00	16245.00	2026-05-05	f	sena_pagada	2026-04-25 15:01:40.390383	f	\N	comprar	10	8000	\N
358	2026-05-01	96	1	50	Blanco	Negro	f	f	41000.00	20500.00	20500.00	18100.00	14900.00	745.00	14155.00	2026-05-05	f	sena_pagada	2026-04-26 12:24:17.962594	f	\N	comprar	10	8000	\N
336	2026-04-15	125	3	50	Crudo	Negro	f	f	35000.00	17500.00	17500.00	9550.00	17450.00	872.50	16577.50	2026-04-24	f	sena_pagada	2026-04-15 14:40:11.208895	f	\N	entregado	8	8000	\N
\.


--
-- Name: clientes_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_codigo_seq', 163, true);


--
-- Name: clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_id_seq', 173, true);


--
-- Name: config_theme_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.config_theme_id_seq', 1, true);


--
-- Name: meses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.meses_id_seq', 10, true);


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

SELECT pg_catalog.setval('public.ventas_id_seq', 358, true);


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

\unrestrict eQzyZrSrkFNXcPgdatpmhctfEPXi6Q61lxSbXZIWhWie2VN9KVTQnPzhVZ9ghfb

