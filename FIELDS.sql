--
-- PostgreSQL database dump
--

\restrict oA7xrppFnQW4gu4P3c8gsVD03pqZRINBD4EEkfpUSz2aAkkfa9AhbDf0QS3CI8D

-- Dumped from database version 17.10
-- Dumped by pg_dump version 18.0

-- Started on 2026-07-23 12:15:10

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
-- TOC entry 224 (class 1259 OID 16405)
-- Name: form_field_options; Type: TABLE; Schema: ComplaintSchema; Owner: postgres
--

CREATE TABLE "ComplaintSchema".form_field_options (
    id integer NOT NULL,
    field_name character varying(50) NOT NULL,
    option_value character varying(200) NOT NULL,
    display_order integer DEFAULT 0
);


ALTER TABLE "ComplaintSchema".form_field_options OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16409)
-- Name: form_field_options_id_seq; Type: SEQUENCE; Schema: ComplaintSchema; Owner: postgres
--

CREATE SEQUENCE "ComplaintSchema".form_field_options_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "ComplaintSchema".form_field_options_id_seq OWNER TO postgres;

--
-- TOC entry 4957 (class 0 OID 0)
-- Dependencies: 225
-- Name: form_field_options_id_seq; Type: SEQUENCE OWNED BY; Schema: ComplaintSchema; Owner: postgres
--

ALTER SEQUENCE "ComplaintSchema".form_field_options_id_seq OWNED BY "ComplaintSchema".form_field_options.id;


--
-- TOC entry 4799 (class 2604 OID 16427)
-- Name: form_field_options id; Type: DEFAULT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".form_field_options ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".form_field_options_id_seq'::regclass);


--
-- TOC entry 4950 (class 0 OID 16405)
-- Dependencies: 224
-- Data for Name: form_field_options; Type: TABLE DATA; Schema: ComplaintSchema; Owner: postgres
--

COPY "ComplaintSchema".form_field_options (id, field_name, option_value, display_order) FROM stdin;
1	given_by	Doctor	1
2	given_by	Patient	2
3	given_by	Attender	3
4	given_by	Staff	4
5	given_by	Others	5
6	department_section	Bio-Chemistry	1
7	department_section	Hematology	2
8	department_section	Micro-Biology	3
9	department_section	Clinical-Pathology	4
10	department_section	Histo-Pathology	5
11	department_section	Molecular-Biology	6
12	pre_analytic_error	Wrong id of patient / wrong sample	1
13	pre_analytic_error	Wrong label at collection	2
14	pre_analytic_error	Wrong label at reception	3
15	pre_analytic_error	Wrong order / wrong test	4
16	pre_analytic_error	Wrong container / container related	5
17	pre_analytic_error	Staffing / waiting	6
18	pre_analytic_error	MIS related / demographics wrong	7
19	pre_analytic_error	Sample missing	8
20	pre_analytic_error	Test not done / sample not collected	9
21	pre_analytic_error	OP sample haemolysed	10
22	pre_analytic_error	Other in collection	11
23	pre_analytic_error	No label / wrong labels	12
24	pre_analytic_error	Test done late	13
25	pre_analytic_error	Improper sample	14
26	pre_analytic_error	Wrong sample	15
27	pre_analytic_error	Waiting time	16
28	analytic_error	Analysis	1
29	analytic_error	Recording	2
30	analytic_error	QC	3
31	analytic_error	Maintenance	4
32	analytic_error	Critical reporting	5
33	post_analytic_error	Transcription error	1
34	post_analytic_error	Reference range / units / report format	2
35	post_analytic_error	Turn around time delay	3
36	post_analytic_error	Other	4
37	post_analytic_error	Wrong report	5
38	no_lab_error	Clinically not correlating	1
39	no_lab_error	No lab error	2
40	no_lab_error	Professionalism / Courtesy	3
41	no_lab_error	Machine / Instrument related	4
42	no_lab_error	Availability of reagents / stock	5
43	no_lab_error	Records	6
44	no_lab_error	Improvement	7
45	no_lab_error	IT related error (Hardware / Software)	8
46	given_by	Teachers	6
47	department_section	test	7
\.


--
-- TOC entry 4958 (class 0 OID 0)
-- Dependencies: 225
-- Name: form_field_options_id_seq; Type: SEQUENCE SET; Schema: ComplaintSchema; Owner: postgres
--

SELECT pg_catalog.setval('"ComplaintSchema".form_field_options_id_seq', 47, true);


--
-- TOC entry 4802 (class 2606 OID 16437)
-- Name: form_field_options form_field_options_field_name_option_value_key; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".form_field_options
    ADD CONSTRAINT form_field_options_field_name_option_value_key UNIQUE (field_name, option_value);


--
-- TOC entry 4804 (class 2606 OID 16439)
-- Name: form_field_options form_field_options_pkey; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".form_field_options
    ADD CONSTRAINT form_field_options_pkey PRIMARY KEY (id);


-- Completed on 2026-07-23 12:15:10

--
-- PostgreSQL database dump complete
--

\unrestrict oA7xrppFnQW4gu4P3c8gsVD03pqZRINBD4EEkfpUSz2aAkkfa9AhbDf0QS3CI8D

