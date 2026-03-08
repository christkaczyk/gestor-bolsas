--
-- PostgreSQL database dump
--

\restrict c0IaxegjfjErMK4JKkvRJEhABrYm7Sxvo0OqlIiRvrVLqkVREJwzafy89GwGq3E

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
    mes_id integer
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
\.


--
-- Data for Name: meses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meses (id, nombre, fecha_inicio, fecha_fin, activo, created_at) FROM stdin;
1	Febrero 2026	2026-02-28	\N	f	2026-02-28 12:57:37.797714
2	Febrero	2026-02-28	\N	f	2026-02-28 13:02:07.717816
3	febrero	2026-02-28	\N	f	2026-02-28 13:07:31.091494
4	Abril	2026-03-06	\N	t	2026-03-06 00:43:24.441861
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
8	1	100	48000.00	2026-02-25 21:53:59.909417	29100.00
7	1	50	30000.00	2026-02-25 22:35:49.724944	14550.00
25	4	50	28000.00	2026-02-27 00:29:17.952417	13100.00
26	4	100	52000.00	2026-02-27 00:29:31.119878	26200.00
27	4	200	99000.00	2026-02-27 00:29:41.293425	52400.00
28	4	300	147000.00	2026-02-27 00:29:53.746466	78600.00
29	4	400	194000.00	2026-02-27 00:30:05.20571	104800.00
30	4	500	242000.00	2026-02-27 00:30:15.31331	131000.00
9	1	200	93000.00	2026-02-27 00:30:42.57198	58200.00
10	1	300	128000.00	2026-02-27 00:30:51.839522	87300.00
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
13	2	50	0.00	2026-02-25 19:44:31.653002	6650.00
14	2	100	0.00	2026-02-25 19:44:31.653002	13300.00
15	2	200	0.00	2026-02-25 19:44:31.653002	26600.00
16	2	300	0.00	2026-02-25 19:44:31.653002	39900.00
17	2	400	0.00	2026-02-25 19:44:31.653002	53200.00
18	2	500	0.00	2026-02-25 19:44:31.653002	66500.00
19	3	50	0.00	2026-02-25 19:44:31.653002	9200.00
20	3	100	0.00	2026-02-25 19:44:31.653002	18400.00
21	3	200	0.00	2026-02-25 19:44:31.653002	36800.00
22	3	300	0.00	2026-02-25 19:44:31.653002	55200.00
23	3	400	0.00	2026-02-25 19:44:31.653002	73600.00
24	3	500	0.00	2026-02-25 19:44:31.653002	92000.00
31	5	50	0.00	2026-02-25 19:44:31.653002	14050.00
32	5	100	0.00	2026-02-25 19:44:31.653002	28100.00
33	5	200	0.00	2026-02-25 19:44:31.653002	56200.00
34	5	300	0.00	2026-02-25 19:44:31.653002	84300.00
35	5	400	0.00	2026-02-25 19:44:31.653002	112400.00
36	5	500	0.00	2026-02-25 19:44:31.653002	140500.00
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
66	10	500	370000.00	2026-02-27 00:35:40.617064	215000.00
\.


--
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.productos (id, tamano, tipo_asa, precio_base, activo, created_at, precio_venta_unitario, costo_unitario, costo_estampado_unitario, precio_proveedor_unitario) FROM stdin;
2	15x20	RINON	\N	t	2026-02-25 19:40:46.155152	\N	133.00	50	\N
3	20x30	RINON	\N	t	2026-02-25 19:40:46.155152	\N	184.00	50	\N
5	30x40	RINON	\N	t	2026-02-25 19:40:46.155152	\N	281.00	50	\N
4	30x30	ASAS	\N	t	2026-02-25 19:40:46.155152	\N	262.00	50	\N
1	30x40	ASAS	500.00	t	2026-02-23 18:47:18.307792	\N	291.00	50	231
7	45x40	ASAS	\N	t	2026-02-25 19:40:46.155152	\N	337.00	50	\N
8	50x40	ASAS	\N	t	2026-02-25 19:40:46.155152	\N	383.00	50	\N
9	60x40	ASAS	\N	t	2026-02-25 19:40:46.155152	\N	420.00	50	\N
10	60x50	ASAS	\N	t	2026-02-25 19:40:46.155152	\N	430.00	50	\N
\.


--
-- Data for Name: ventas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ventas (id, fecha, cliente_id, producto_id, cantidad, color_bolsa, color_estampa, doble_estampa, envio_domicilio, precio_final, sena, restante, costo_total, ganancia_total, ganancia_taller, ganancia_personal, fecha_entrega, factura, estado, created_at, arca, color_fila, etapa, mes_id) FROM stdin;
\.


--
-- Name: clientes_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_codigo_seq', 33, true);


--
-- Name: clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_id_seq', 43, true);


--
-- Name: meses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.meses_id_seq', 4, true);


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

SELECT pg_catalog.setval('public.ventas_id_seq', 54, true);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


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

\unrestrict c0IaxegjfjErMK4JKkvRJEhABrYm7Sxvo0OqlIiRvrVLqkVREJwzafy89GwGq3E

