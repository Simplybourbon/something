--
-- PostgreSQL database dump
--

\restrict bKeiZSBbDhvbSWe3Fjx8TYbdcCx3yW5KFdVtPlBqzLqSJgG2m92GCyKRR2kCzxS

-- Dumped from database version 17.10
-- Dumped by pg_dump version 18.0

-- Started on 2026-07-23 15:50:55

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

--
-- TOC entry 7 (class 2615 OID 16455)
-- Name: ComplaintSchema; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "ComplaintSchema";


ALTER SCHEMA "ComplaintSchema" OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 16462)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 5000 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16390)
-- Name: admins; Type: TABLE; Schema: ComplaintSchema; Owner: postgres
--

CREATE TABLE "ComplaintSchema".admins (
    id integer NOT NULL,
    admin_id character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL
);


ALTER TABLE "ComplaintSchema".admins OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16393)
-- Name: admins_id_seq; Type: SEQUENCE; Schema: ComplaintSchema; Owner: postgres
--

CREATE SEQUENCE "ComplaintSchema".admins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "ComplaintSchema".admins_id_seq OWNER TO postgres;

--
-- TOC entry 5001 (class 0 OID 0)
-- Dependencies: 220
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: ComplaintSchema; Owner: postgres
--

ALTER SEQUENCE "ComplaintSchema".admins_id_seq OWNED BY "ComplaintSchema".admins.id;


--
-- TOC entry 221 (class 1259 OID 16394)
-- Name: employees; Type: TABLE; Schema: ComplaintSchema; Owner: postgres
--

CREATE TABLE "ComplaintSchema".employees (
    id integer NOT NULL,
    employee_id character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL
);


ALTER TABLE "ComplaintSchema".employees OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16397)
-- Name: feedback_complaint_data; Type: TABLE; Schema: ComplaintSchema; Owner: postgres
--

CREATE TABLE "ComplaintSchema".feedback_complaint_data (
    id integer NOT NULL,
    operation character varying(50),
    given_by character varying(50),
    date_of_submission date,
    depatment_section character varying(100),
    incident_description text,
    main_error_category character varying(50),
    sub_error_categor character varying(100),
    active_error character varying(5),
    latent_error character varying(5),
    cognitive_error character varying(5),
    non_cognitive_error character varying(5),
    root_cause text,
    avg_impact_score numeric(5,2),
    avg_freq_score numeric(5,2),
    immediate_correction text,
    corrective_action text,
    preventive_action text,
    patient_consequences character varying(5),
    risk_discription1 text,
    impact_score1 integer,
    freq_score1 integer,
    risk_discription2 text,
    impact_score2 integer,
    freq_score2 integer,
    risk_discription3 text,
    impact_score3 integer,
    freq_score3 integer,
    risk_discription4 text,
    impact_score4 integer,
    freq_score4 integer,
    risk_discription5 text,
    impact_score5 integer,
    freq_score5 integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    avg_risk_score numeric,
    form_no character varying(30),
    submitted_by character varying(50),
    status character varying(20) DEFAULT 'submitted'::character varying NOT NULL,
    drafted_at timestamp with time zone,
    submitted_at timestamp with time zone,
    remarks text,
    remarks_updated_by character varying(50),
    remarks_updated_at timestamp with time zone
);


ALTER TABLE "ComplaintSchema".feedback_complaint_data OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16404)
-- Name: feedback_complaint_data_id_seq; Type: SEQUENCE; Schema: ComplaintSchema; Owner: postgres
--

CREATE SEQUENCE "ComplaintSchema".feedback_complaint_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "ComplaintSchema".feedback_complaint_data_id_seq OWNER TO postgres;

--
-- TOC entry 5002 (class 0 OID 0)
-- Dependencies: 223
-- Name: feedback_complaint_data_id_seq; Type: SEQUENCE OWNED BY; Schema: ComplaintSchema; Owner: postgres
--

ALTER SEQUENCE "ComplaintSchema".feedback_complaint_data_id_seq OWNED BY "ComplaintSchema".feedback_complaint_data.id;


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
-- TOC entry 5003 (class 0 OID 0)
-- Dependencies: 225
-- Name: form_field_options_id_seq; Type: SEQUENCE OWNED BY; Schema: ComplaintSchema; Owner: postgres
--

ALTER SEQUENCE "ComplaintSchema".form_field_options_id_seq OWNED BY "ComplaintSchema".form_field_options.id;


--
-- TOC entry 226 (class 1259 OID 16410)
-- Name: login_attempts; Type: TABLE; Schema: ComplaintSchema; Owner: postgres
--

CREATE TABLE "ComplaintSchema".login_attempts (
    id integer NOT NULL,
    identifier_key character varying(255) NOT NULL,
    success boolean DEFAULT false NOT NULL,
    attempted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE "ComplaintSchema".login_attempts OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16415)
-- Name: login_attempts_id_seq; Type: SEQUENCE; Schema: ComplaintSchema; Owner: postgres
--

CREATE SEQUENCE "ComplaintSchema".login_attempts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "ComplaintSchema".login_attempts_id_seq OWNER TO postgres;

--
-- TOC entry 5004 (class 0 OID 0)
-- Dependencies: 227
-- Name: login_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: ComplaintSchema; Owner: postgres
--

ALTER SEQUENCE "ComplaintSchema".login_attempts_id_seq OWNED BY "ComplaintSchema".login_attempts.id;


--
-- TOC entry 228 (class 1259 OID 16416)
-- Name: remarks_thread; Type: TABLE; Schema: ComplaintSchema; Owner: postgres
--

CREATE TABLE "ComplaintSchema".remarks_thread (
    id integer NOT NULL,
    submission_id integer NOT NULL,
    author character varying(50) NOT NULL,
    remark_text text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE "ComplaintSchema".remarks_thread OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16422)
-- Name: remarks_thread_id_seq; Type: SEQUENCE; Schema: ComplaintSchema; Owner: postgres
--

CREATE SEQUENCE "ComplaintSchema".remarks_thread_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "ComplaintSchema".remarks_thread_id_seq OWNER TO postgres;

--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 229
-- Name: remarks_thread_id_seq; Type: SEQUENCE OWNED BY; Schema: ComplaintSchema; Owner: postgres
--

ALTER SEQUENCE "ComplaintSchema".remarks_thread_id_seq OWNED BY "ComplaintSchema".remarks_thread.id;


--
-- TOC entry 230 (class 1259 OID 16423)
-- Name: users_id_seq; Type: SEQUENCE; Schema: ComplaintSchema; Owner: postgres
--

CREATE SEQUENCE "ComplaintSchema".users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "ComplaintSchema".users_id_seq OWNER TO postgres;

--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 230
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: ComplaintSchema; Owner: postgres
--

ALTER SEQUENCE "ComplaintSchema".users_id_seq OWNED BY "ComplaintSchema".employees.id;


--
-- TOC entry 4805 (class 2604 OID 16424)
-- Name: admins id; Type: DEFAULT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".admins ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".admins_id_seq'::regclass);


--
-- TOC entry 4806 (class 2604 OID 16425)
-- Name: employees id; Type: DEFAULT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".employees ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".users_id_seq'::regclass);


--
-- TOC entry 4807 (class 2604 OID 16426)
-- Name: feedback_complaint_data id; Type: DEFAULT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".feedback_complaint_data ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".feedback_complaint_data_id_seq'::regclass);


--
-- TOC entry 4810 (class 2604 OID 16427)
-- Name: form_field_options id; Type: DEFAULT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".form_field_options ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".form_field_options_id_seq'::regclass);


--
-- TOC entry 4812 (class 2604 OID 16428)
-- Name: login_attempts id; Type: DEFAULT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".login_attempts ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".login_attempts_id_seq'::regclass);


--
-- TOC entry 4815 (class 2604 OID 16429)
-- Name: remarks_thread id; Type: DEFAULT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".remarks_thread ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".remarks_thread_id_seq'::regclass);


--
-- TOC entry 4983 (class 0 OID 16390)
-- Dependencies: 219
-- Data for Name: admins; Type: TABLE DATA; Schema: ComplaintSchema; Owner: postgres
--

COPY "ComplaintSchema".admins (id, admin_id, password_hash) FROM stdin;
1	ADMIN001	$2a$12$7CmyE7zJDALNtVBZnXGxbO6dTMbCCckhXoQ329MNggQa.mna.C/hW
\.


--
-- TOC entry 4985 (class 0 OID 16394)
-- Dependencies: 221
-- Data for Name: employees; Type: TABLE DATA; Schema: ComplaintSchema; Owner: postgres
--

COPY "ComplaintSchema".employees (id, employee_id, password_hash) FROM stdin;
1	EMP001	$2y$12$y6.YD6NyD6In6YO52rKNSeVJII21Dht1w99f2KPgf4PqoViQpzvWq
7	EMP003	$2y$12$EhxTwl4MqASjShHfslCGJOURHuKjYCfYmlx2LOnvuQq/KNIFVzPeG
9	EMP002	$2y$12$Vx3l9PDx0DTV8hAhqpah9.pD17JCd/d0vkfh0MfDTWTXpXsgWPCzu
\.


--
-- TOC entry 4986 (class 0 OID 16397)
-- Dependencies: 222
-- Data for Name: feedback_complaint_data; Type: TABLE DATA; Schema: ComplaintSchema; Owner: postgres
--

COPY "ComplaintSchema".feedback_complaint_data (id, operation, given_by, date_of_submission, depatment_section, incident_description, main_error_category, sub_error_categor, active_error, latent_error, cognitive_error, non_cognitive_error, root_cause, avg_impact_score, avg_freq_score, immediate_correction, corrective_action, preventive_action, patient_consequences, risk_discription1, impact_score1, freq_score1, risk_discription2, impact_score2, freq_score2, risk_discription3, impact_score3, freq_score3, risk_discription4, impact_score4, freq_score4, risk_discription5, impact_score5, freq_score5, created_at, avg_risk_score, form_no, submitted_by, status, drafted_at, submitted_at, remarks, remarks_updated_by, remarks_updated_at) FROM stdin;
1	Complaint		2026-07-15					no	no	no	no		\N	\N			\N	\N		\N	\N		\N	\N		\N	\N		\N	\N		\N	\N	2026-07-15 14:55:39.406716	\N	COMP-2026-0002	EMP001	draft	2026-07-15 14:55:39.406716+05:30	\N	\N	\N	\N
12	Complaint	Staff	2026-07-20	Hematology	OOPPP	pre	Wrong id of patient / wrong sample	yes	no	no	no	sfsdfsd	1.00	1.00	dasdasdas	dASDASD	KKKOOOK	no	xcdasdsa	1	1		\N	\N		\N	\N		\N	\N		\N	\N	2026-07-20 10:17:33.456286	1.00	COMP-2026-0012	EMP001	submitted	\N	2026-07-20 10:17:33.456286+05:30	DASDAS	\N	\N
13	Complaint	Staff	2026-07-20	Bio-Chemistry	GFGHG	pre	Waiting time	yes	no	no	no	JHHJFGJ	1.00	1.00	DFHG	HDFGDH	DHFD	no	FGJ	1	1		\N	\N		\N	\N		\N	\N		\N	\N	2026-07-20 14:31:28.647469	1.00		EMP001	submitted	\N	2026-07-20 14:31:28.647469+05:30	HDHFG	\N	\N
14	Complaint	Doctor	2026-07-20	Bio-Chemistry	HGGHF	pre	Waiting time	no	no	yes	no	DGGDFG	1.00	1.00	DFFDGF	GDFGDFG	FDGHFDGFD	no	ETR	1	1		\N	\N		\N	\N		\N	\N		\N	\N	2026-07-20 14:38:44.97091	1.00	COMP-2026-0014	EMP001	submitted	\N	2026-07-20 14:38:44.97091+05:30	DFGDF	\N	\N
15	Complaint	Doctor	2026-07-20	Clinical-Pathology	FFFFFFFF	analytic	Analysis	yes	no	no	no	DDDDDDDDDDDDD	2.00	3.00	DDDDDDDDDDD	DDDDDDDDDDDDD	DDDDDDDDDDDDD	no	DDDDDDDD	2	3		\N	\N		\N	\N		\N	\N		\N	\N	2026-07-20 14:59:39.357566	6.00	COMP-2026-0015	EMP001	submitted	\N	2026-07-20 14:59:39.357566+05:30	DDDDDDDDDDDDDDDD	\N	\N
16	Complaint	Doctor	2026-07-20	Micro-Biology	FFFFFFFFF	analytic	Analysis	yes	no	no	no	FFFFFFFFFFFFFF	3.00	2.00	DDDDDDDDDDDDD	DDDDDDDDDDDD	DDDDDDDDDDDDD	yes	FFFFFFFFF	3	2		\N	\N		\N	\N		\N	\N		\N	\N	2026-07-20 15:06:50.348451	6.00	COMP-2026-0016	EMP001	submitted	\N	2026-07-20 15:06:50.348451+05:30	WWWWWWWWWW	\N	\N
17	Complaint	Patient	2026-07-20	Hematology	llllllllllolol	others	Clinically not correlating	yes	no	no	no	bvjvfnnnvnvn	4.50	4.00	kkkkkkkkkkkkkkkk	oooooooooo	pppppppp	no	uuuuuuu	5	4	oooo	4	4		\N	\N		\N	\N		\N	\N	2026-07-20 16:18:20.351127	18.00	COMP-2026-0017	EMP001	submitted	\N	2026-07-20 16:18:20.351127+05:30	yyyyyyyyyyyyyy	\N	\N
18	Complaint		2026-07-20					no	no	no	no		\N	\N			\N	\N		\N	\N		\N	\N		\N	\N		\N	\N		\N	\N	2026-07-20 16:18:26.850011	18.00	COMP-2026-0018	EMP001	draft	2026-07-20 16:18:26.850011+05:30	\N	\N	\N	\N
\.


--
-- TOC entry 4988 (class 0 OID 16405)
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
-- TOC entry 4990 (class 0 OID 16410)
-- Dependencies: 226
-- Data for Name: login_attempts; Type: TABLE DATA; Schema: ComplaintSchema; Owner: postgres
--

COPY "ComplaintSchema".login_attempts (id, identifier_key, success, attempted_at) FROM stdin;
2	EMP001|::1	f	2026-07-19 23:37:02.241702+05:30
3	EMP001|::1	f	2026-07-19 23:37:06.503478+05:30
4	EMP001|::1	f	2026-07-19 23:37:11.300888+05:30
5	EMP001|::1	f	2026-07-19 23:37:13.410884+05:30
6	EMP001|::1	f	2026-07-19 23:37:15.594954+05:30
9	ADMIN|172.16.5.114	f	2026-07-20 10:18:15.706904+05:30
10	administrator|172.16.5.114	f	2026-07-20 10:19:53.123285+05:30
11	admin001|172.16.5.114	f	2026-07-20 10:21:52.447747+05:30
16	EMP0001|172.16.5.114	f	2026-07-23 09:44:57.250975+05:30
17	EMP0001|172.16.5.114	f	2026-07-23 09:45:06.396511+05:30
19	ADMIN001|172.16.14.29	f	2026-07-23 09:58:59.578587+05:30
\.


--
-- TOC entry 4992 (class 0 OID 16416)
-- Dependencies: 228
-- Data for Name: remarks_thread; Type: TABLE DATA; Schema: ComplaintSchema; Owner: postgres
--

COPY "ComplaintSchema".remarks_thread (id, submission_id, author, remark_text, created_at) FROM stdin;
5	13	EMP001	HGJHGJHJG	2026-07-20 14:37:38.272649+05:30
\.


--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 220
-- Name: admins_id_seq; Type: SEQUENCE SET; Schema: ComplaintSchema; Owner: postgres
--

SELECT pg_catalog.setval('"ComplaintSchema".admins_id_seq', 1, true);


--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 223
-- Name: feedback_complaint_data_id_seq; Type: SEQUENCE SET; Schema: ComplaintSchema; Owner: postgres
--

SELECT pg_catalog.setval('"ComplaintSchema".feedback_complaint_data_id_seq', 18, true);


--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 225
-- Name: form_field_options_id_seq; Type: SEQUENCE SET; Schema: ComplaintSchema; Owner: postgres
--

SELECT pg_catalog.setval('"ComplaintSchema".form_field_options_id_seq', 47, true);


--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 227
-- Name: login_attempts_id_seq; Type: SEQUENCE SET; Schema: ComplaintSchema; Owner: postgres
--

SELECT pg_catalog.setval('"ComplaintSchema".login_attempts_id_seq', 19, true);


--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 229
-- Name: remarks_thread_id_seq; Type: SEQUENCE SET; Schema: ComplaintSchema; Owner: postgres
--

SELECT pg_catalog.setval('"ComplaintSchema".remarks_thread_id_seq', 5, true);


--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 230
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: ComplaintSchema; Owner: postgres
--

SELECT pg_catalog.setval('"ComplaintSchema".users_id_seq', 9, true);


--
-- TOC entry 4818 (class 2606 OID 16431)
-- Name: admins admins_admin_id_key; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".admins
    ADD CONSTRAINT admins_admin_id_key UNIQUE (admin_id);


--
-- TOC entry 4820 (class 2606 OID 16433)
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- TOC entry 4826 (class 2606 OID 16435)
-- Name: feedback_complaint_data feedback_complaint_data_pkey; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".feedback_complaint_data
    ADD CONSTRAINT feedback_complaint_data_pkey PRIMARY KEY (id);


--
-- TOC entry 4828 (class 2606 OID 16437)
-- Name: form_field_options form_field_options_field_name_option_value_key; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".form_field_options
    ADD CONSTRAINT form_field_options_field_name_option_value_key UNIQUE (field_name, option_value);


--
-- TOC entry 4830 (class 2606 OID 16439)
-- Name: form_field_options form_field_options_pkey; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".form_field_options
    ADD CONSTRAINT form_field_options_pkey PRIMARY KEY (id);


--
-- TOC entry 4833 (class 2606 OID 16441)
-- Name: login_attempts login_attempts_pkey; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".login_attempts
    ADD CONSTRAINT login_attempts_pkey PRIMARY KEY (id);


--
-- TOC entry 4836 (class 2606 OID 16443)
-- Name: remarks_thread remarks_thread_pkey; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".remarks_thread
    ADD CONSTRAINT remarks_thread_pkey PRIMARY KEY (id);


--
-- TOC entry 4822 (class 2606 OID 16445)
-- Name: employees users_employee_id_key; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".employees
    ADD CONSTRAINT users_employee_id_key UNIQUE (employee_id);


--
-- TOC entry 4824 (class 2606 OID 16447)
-- Name: employees users_pkey; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".employees
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4831 (class 1259 OID 16448)
-- Name: idx_login_attempts_key_time; Type: INDEX; Schema: ComplaintSchema; Owner: postgres
--

CREATE INDEX idx_login_attempts_key_time ON "ComplaintSchema".login_attempts USING btree (identifier_key, attempted_at);


--
-- TOC entry 4834 (class 1259 OID 16449)
-- Name: idx_remarks_thread_submission_id; Type: INDEX; Schema: ComplaintSchema; Owner: postgres
--

CREATE INDEX idx_remarks_thread_submission_id ON "ComplaintSchema".remarks_thread USING btree (submission_id);


--
-- TOC entry 4837 (class 2606 OID 16450)
-- Name: remarks_thread remarks_thread_submission_id_fkey; Type: FK CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".remarks_thread
    ADD CONSTRAINT remarks_thread_submission_id_fkey FOREIGN KEY (submission_id) REFERENCES "ComplaintSchema".feedback_complaint_data(id) ON DELETE CASCADE;


-- Completed on 2026-07-23 15:50:55

--
-- PostgreSQL database dump complete
--

\unrestrict bKeiZSBbDhvbSWe3Fjx8TYbdcCx3yW5KFdVtPlBqzLqSJgG2m92GCyKRR2kCzxS

