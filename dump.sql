--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: dobavitelj; Type: TABLE; Schema: public; Owner: kso; Tablespace: 
--

CREATE TABLE dobavitelj (
    id integer NOT NULL,
    ime character varying NOT NULL
);


ALTER TABLE public.dobavitelj OWNER TO kso;

--
-- Name: dobavitelj_id_seq; Type: SEQUENCE; Schema: public; Owner: kso
--

CREATE SEQUENCE dobavitelj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dobavitelj_id_seq OWNER TO kso;

--
-- Name: dobavitelj_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kso
--

ALTER SEQUENCE dobavitelj_id_seq OWNED BY dobavitelj.id;


--
-- Name: enoloncnica; Type: TABLE; Schema: public; Owner: kso; Tablespace: 
--

CREATE TABLE enoloncnica (
    id integer NOT NULL,
    ime character varying NOT NULL,
    cena integer NOT NULL
);


ALTER TABLE public.enoloncnica OWNER TO kso;

--
-- Name: enoloncnica_id_seq; Type: SEQUENCE; Schema: public; Owner: kso
--

CREATE SEQUENCE enoloncnica_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.enoloncnica_id_seq OWNER TO kso;

--
-- Name: enoloncnica_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kso
--

ALTER SEQUENCE enoloncnica_id_seq OWNED BY enoloncnica.id;


--
-- Name: enoloncnica_poslovalnica; Type: TABLE; Schema: public; Owner: kso; Tablespace: 
--

CREATE TABLE enoloncnica_poslovalnica (
    poslovalnica integer NOT NULL,
    enoloncnica integer NOT NULL
);


ALTER TABLE public.enoloncnica_poslovalnica OWNER TO kso;

--
-- Name: narocilo; Type: TABLE; Schema: public; Owner: kso; Tablespace: 
--

CREATE TABLE narocilo (
    id integer NOT NULL,
    stranka integer NOT NULL,
    poslovalnica integer NOT NULL,
    datum timestamp without time zone NOT NULL
);


ALTER TABLE public.narocilo OWNER TO kso;

--
-- Name: narocilo_enoloncnica; Type: TABLE; Schema: public; Owner: kso; Tablespace: 
--

CREATE TABLE narocilo_enoloncnica (
    narocilo integer NOT NULL,
    enoloncnica integer NOT NULL
);


ALTER TABLE public.narocilo_enoloncnica OWNER TO kso;

--
-- Name: narocilo_id_seq; Type: SEQUENCE; Schema: public; Owner: kso
--

CREATE SEQUENCE narocilo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.narocilo_id_seq OWNER TO kso;

--
-- Name: narocilo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kso
--

ALTER SEQUENCE narocilo_id_seq OWNED BY narocilo.id;


--
-- Name: poslovalnica; Type: TABLE; Schema: public; Owner: kso; Tablespace: 
--

CREATE TABLE poslovalnica (
    id integer NOT NULL,
    ime character varying NOT NULL,
    ulica character varying NOT NULL,
    hisna_stevilka character varying NOT NULL,
    postna_stevilka character varying NOT NULL
);


ALTER TABLE public.poslovalnica OWNER TO kso;

--
-- Name: poslovalnica_id_seq; Type: SEQUENCE; Schema: public; Owner: kso
--

CREATE SEQUENCE poslovalnica_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.poslovalnica_id_seq OWNER TO kso;

--
-- Name: poslovalnica_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kso
--

ALTER SEQUENCE poslovalnica_id_seq OWNED BY poslovalnica.id;


--
-- Name: sestavina; Type: TABLE; Schema: public; Owner: kso; Tablespace: 
--

CREATE TABLE sestavina (
    id integer NOT NULL,
    ime character varying NOT NULL,
    dobavitelj integer NOT NULL
);


ALTER TABLE public.sestavina OWNER TO kso;

--
-- Name: sestavina_enoloncnica; Type: TABLE; Schema: public; Owner: kso; Tablespace: 
--

CREATE TABLE sestavina_enoloncnica (
    sestavina integer NOT NULL,
    enoloncnica integer NOT NULL
);


ALTER TABLE public.sestavina_enoloncnica OWNER TO kso;

--
-- Name: sestavina_id_seq; Type: SEQUENCE; Schema: public; Owner: kso
--

CREATE SEQUENCE sestavina_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sestavina_id_seq OWNER TO kso;

--
-- Name: sestavina_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kso
--

ALTER SEQUENCE sestavina_id_seq OWNED BY sestavina.id;


--
-- Name: stranka; Type: TABLE; Schema: public; Owner: kso; Tablespace: 
--

CREATE TABLE stranka (
    id integer NOT NULL,
    ime character varying NOT NULL,
    priimek character varying NOT NULL
);


ALTER TABLE public.stranka OWNER TO kso;

--
-- Name: stranka_id_seq; Type: SEQUENCE; Schema: public; Owner: kso
--

CREATE SEQUENCE stranka_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stranka_id_seq OWNER TO kso;

--
-- Name: stranka_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kso
--

ALTER SEQUENCE stranka_id_seq OWNED BY stranka.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kso
--

ALTER TABLE ONLY dobavitelj ALTER COLUMN id SET DEFAULT nextval('dobavitelj_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kso
--

ALTER TABLE ONLY enoloncnica ALTER COLUMN id SET DEFAULT nextval('enoloncnica_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kso
--

ALTER TABLE ONLY narocilo ALTER COLUMN id SET DEFAULT nextval('narocilo_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kso
--

ALTER TABLE ONLY poslovalnica ALTER COLUMN id SET DEFAULT nextval('poslovalnica_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kso
--

ALTER TABLE ONLY sestavina ALTER COLUMN id SET DEFAULT nextval('sestavina_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kso
--

ALTER TABLE ONLY stranka ALTER COLUMN id SET DEFAULT nextval('stranka_id_seq'::regclass);


--
-- Data for Name: dobavitelj; Type: TABLE DATA; Schema: public; Owner: kso
--

COPY dobavitelj (id, ime) FROM stdin;
1	Kolinska
2	Mercator
3	Tus
\.


--
-- Name: dobavitelj_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kso
--

SELECT pg_catalog.setval('dobavitelj_id_seq', 3, true);


--
-- Data for Name: enoloncnica; Type: TABLE DATA; Schema: public; Owner: kso
--

COPY enoloncnica (id, ime, cena) FROM stdin;
1	jota	10
2	pasulj	6
3	ricet	6
4	piscancja obara	11
\.


--
-- Name: enoloncnica_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kso
--

SELECT pg_catalog.setval('enoloncnica_id_seq', 4, true);


--
-- Data for Name: enoloncnica_poslovalnica; Type: TABLE DATA; Schema: public; Owner: kso
--

COPY enoloncnica_poslovalnica (poslovalnica, enoloncnica) FROM stdin;
1	2
1	1
2	1
\.


--
-- Data for Name: narocilo; Type: TABLE DATA; Schema: public; Owner: kso
--

COPY narocilo (id, stranka, poslovalnica, datum) FROM stdin;
1	1	1	2013-02-01 00:00:00
2	2	2	2013-01-01 00:00:00
3	3	2	2013-02-05 00:00:00
\.


--
-- Data for Name: narocilo_enoloncnica; Type: TABLE DATA; Schema: public; Owner: kso
--

COPY narocilo_enoloncnica (narocilo, enoloncnica) FROM stdin;
2	2
3	1
3	2
3	1
1	1
1	2
\.


--
-- Name: narocilo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kso
--

SELECT pg_catalog.setval('narocilo_id_seq', 3, true);


--
-- Data for Name: poslovalnica; Type: TABLE DATA; Schema: public; Owner: kso
--

COPY poslovalnica (id, ime, ulica, hisna_stevilka, postna_stevilka) FROM stdin;
1	Ziga Zaga d.o.o.	Kersnikova	6	1000
2	Volta Morta s.p.	Dunajska	86	1000
3	Butl tesla s.p.	Slovenska	200	1000
\.


--
-- Name: poslovalnica_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kso
--

SELECT pg_catalog.setval('poslovalnica_id_seq', 3, true);


--
-- Data for Name: sestavina; Type: TABLE DATA; Schema: public; Owner: kso
--

COPY sestavina (id, ime, dobavitelj) FROM stdin;
1	krompir	1
2	fizol	2
3	zelje	3
4	jespren	2
5	korenje	3
6	piscanec	1
\.


--
-- Data for Name: sestavina_enoloncnica; Type: TABLE DATA; Schema: public; Owner: kso
--

COPY sestavina_enoloncnica (sestavina, enoloncnica) FROM stdin;
1	3
6	4
2	1
2	2
3	3
4	1
5	2
5	3
\.


--
-- Name: sestavina_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kso
--

SELECT pg_catalog.setval('sestavina_id_seq', 6, true);


--
-- Data for Name: stranka; Type: TABLE DATA; Schema: public; Owner: kso
--

COPY stranka (id, ime, priimek) FROM stdin;
1	Joze	Zbogar
2	Mirko	Semu
3	Tina	Zore
4	Gorazd	Boromir
\.


--
-- Name: stranka_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kso
--

SELECT pg_catalog.setval('stranka_id_seq', 4, true);


--
-- Name: dobavitelj_pkey; Type: CONSTRAINT; Schema: public; Owner: kso; Tablespace: 
--

ALTER TABLE ONLY dobavitelj
    ADD CONSTRAINT dobavitelj_pkey PRIMARY KEY (id);


--
-- Name: enoloncnica_pkey; Type: CONSTRAINT; Schema: public; Owner: kso; Tablespace: 
--

ALTER TABLE ONLY enoloncnica
    ADD CONSTRAINT enoloncnica_pkey PRIMARY KEY (id);


--
-- Name: narocilo_pkey; Type: CONSTRAINT; Schema: public; Owner: kso; Tablespace: 
--

ALTER TABLE ONLY narocilo
    ADD CONSTRAINT narocilo_pkey PRIMARY KEY (id);


--
-- Name: poslovalnica_pkey; Type: CONSTRAINT; Schema: public; Owner: kso; Tablespace: 
--

ALTER TABLE ONLY poslovalnica
    ADD CONSTRAINT poslovalnica_pkey PRIMARY KEY (id);


--
-- Name: sestavina_pkey; Type: CONSTRAINT; Schema: public; Owner: kso; Tablespace: 
--

ALTER TABLE ONLY sestavina
    ADD CONSTRAINT sestavina_pkey PRIMARY KEY (id);


--
-- Name: stranka_pkey; Type: CONSTRAINT; Schema: public; Owner: kso; Tablespace: 
--

ALTER TABLE ONLY stranka
    ADD CONSTRAINT stranka_pkey PRIMARY KEY (id);


--
-- Name: enoloncnica_poslovalnica_enoloncnica_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kso
--

ALTER TABLE ONLY enoloncnica_poslovalnica
    ADD CONSTRAINT enoloncnica_poslovalnica_enoloncnica_fkey FOREIGN KEY (enoloncnica) REFERENCES enoloncnica(id);


--
-- Name: enoloncnica_poslovalnica_poslovalnica_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kso
--

ALTER TABLE ONLY enoloncnica_poslovalnica
    ADD CONSTRAINT enoloncnica_poslovalnica_poslovalnica_fkey FOREIGN KEY (poslovalnica) REFERENCES poslovalnica(id);


--
-- Name: narocilo_enoloncnica_enoloncnica_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kso
--

ALTER TABLE ONLY narocilo_enoloncnica
    ADD CONSTRAINT narocilo_enoloncnica_enoloncnica_fkey FOREIGN KEY (enoloncnica) REFERENCES enoloncnica(id);


--
-- Name: narocilo_enoloncnica_narocilo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kso
--

ALTER TABLE ONLY narocilo_enoloncnica
    ADD CONSTRAINT narocilo_enoloncnica_narocilo_fkey FOREIGN KEY (narocilo) REFERENCES narocilo(id);


--
-- Name: narocilo_poslovalnica_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kso
--

ALTER TABLE ONLY narocilo
    ADD CONSTRAINT narocilo_poslovalnica_fkey FOREIGN KEY (poslovalnica) REFERENCES poslovalnica(id);


--
-- Name: narocilo_stranka_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kso
--

ALTER TABLE ONLY narocilo
    ADD CONSTRAINT narocilo_stranka_fkey FOREIGN KEY (stranka) REFERENCES stranka(id);


--
-- Name: sestavina_dobavitelj_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kso
--

ALTER TABLE ONLY sestavina
    ADD CONSTRAINT sestavina_dobavitelj_fkey FOREIGN KEY (dobavitelj) REFERENCES dobavitelj(id);


--
-- Name: sestavina_enoloncnica_enoloncnica_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kso
--

ALTER TABLE ONLY sestavina_enoloncnica
    ADD CONSTRAINT sestavina_enoloncnica_enoloncnica_fkey FOREIGN KEY (enoloncnica) REFERENCES enoloncnica(id);


--
-- Name: sestavina_enoloncnica_sestavina_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kso
--

ALTER TABLE ONLY sestavina_enoloncnica
    ADD CONSTRAINT sestavina_enoloncnica_sestavina_fkey FOREIGN KEY (sestavina) REFERENCES sestavina(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

