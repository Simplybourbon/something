--
-- PostgreSQL database dump
--

\restrict LFf7t0eO3aDuvvcLbuDJXbWPYH7BoobULQDzHIulKgTJokUaAqIPsSgkpi4GlXr

-- Dumped from database version 17.10
-- Dumped by pg_dump version 17.10

-- Started on 2026-07-23 15:53:55

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
-- TOC entry 7 (class 2615 OID 16389)
-- Name: ComplaintSchema; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "ComplaintSchema";


ALTER SCHEMA "ComplaintSchema" OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 16390)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 4901 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16427)
-- Name: admins; Type: TABLE; Schema: ComplaintSchema; Owner: postgres
--

CREATE TABLE "ComplaintSchema".admins (
    id integer NOT NULL,
    admin_id character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL
);


ALTER TABLE "ComplaintSchema".admins OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16430)
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
-- TOC entry 4902 (class 0 OID 0)
-- Dependencies: 220
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: ComplaintSchema; Owner: postgres
--

ALTER SEQUENCE "ComplaintSchema".admins_id_seq OWNED BY "ComplaintSchema".admins.id;


--
-- TOC entry 221 (class 1259 OID 16436)
-- Name: employees; Type: TABLE; Schema: ComplaintSchema; Owner: postgres
--

CREATE TABLE "ComplaintSchema".employees (
    id integer NOT NULL,
    employee_id character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE "ComplaintSchema".employees OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16446)
-- Name: feedback_complaint_data; Type: TABLE; Schema: ComplaintSchema; Owner: postgres
--

CREATE TABLE "ComplaintSchema".feedback_complaint_data (
    id integer NOT NULL,
    operation character varying(50),
    given_by character varying(50),
    given_by_name character varying(100),
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
    remarks_updated_at timestamp with time zone,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE "ComplaintSchema".feedback_complaint_data OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16454)
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
-- TOC entry 4903 (class 0 OID 0)
-- Dependencies: 224
-- Name: feedback_complaint_data_id_seq; Type: SEQUENCE OWNED BY; Schema: ComplaintSchema; Owner: postgres
--

ALTER SEQUENCE "ComplaintSchema".feedback_complaint_data_id_seq OWNED BY "ComplaintSchema".feedback_complaint_data.id;


--
-- TOC entry 225 (class 1259 OID 16458)
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
-- TOC entry 226 (class 1259 OID 16462)
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
-- TOC entry 4904 (class 0 OID 0)
-- Dependencies: 226
-- Name: form_field_options_id_seq; Type: SEQUENCE OWNED BY; Schema: ComplaintSchema; Owner: postgres
--

ALTER SEQUENCE "ComplaintSchema".form_field_options_id_seq OWNED BY "ComplaintSchema".form_field_options.id;


--
-- TOC entry 227 (class 1259 OID 16468)
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
-- TOC entry 228 (class 1259 OID 16473)
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
-- TOC entry 4905 (class 0 OID 0)
-- Dependencies: 228
-- Name: login_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: ComplaintSchema; Owner: postgres
--

ALTER SEQUENCE "ComplaintSchema".login_attempts_id_seq OWNED BY "ComplaintSchema".login_attempts.id;


--
-- TOC entry 229 (class 1259 OID 16478)
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
-- TOC entry 230 (class 1259 OID 16484)
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
-- TOC entry 4906 (class 0 OID 0)
-- Dependencies: 230
-- Name: remarks_thread_id_seq; Type: SEQUENCE OWNED BY; Schema: ComplaintSchema; Owner: postgres
--

ALTER SEQUENCE "ComplaintSchema".remarks_thread_id_seq OWNED BY "ComplaintSchema".remarks_thread.id;


--
-- TOC entry 222 (class 1259 OID 16440)
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
-- TOC entry 4907 (class 0 OID 0)
-- Dependencies: 222
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: ComplaintSchema; Owner: postgres
--

ALTER SEQUENCE "ComplaintSchema".users_id_seq OWNED BY "ComplaintSchema".employees.id;


--
-- TOC entry 4704 (class 2604 OID 16431)
-- Name: admins id; Type: DEFAULT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".admins ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".admins_id_seq'::regclass);


--
-- TOC entry 4705 (class 2604 OID 16441)
-- Name: employees id; Type: DEFAULT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".employees ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".users_id_seq'::regclass);


--
-- TOC entry 4707 (class 2604 OID 16455)
-- Name: feedback_complaint_data id; Type: DEFAULT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".feedback_complaint_data ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".feedback_complaint_data_id_seq'::regclass);


--
-- TOC entry 4711 (class 2604 OID 16463)
-- Name: form_field_options id; Type: DEFAULT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".form_field_options ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".form_field_options_id_seq'::regclass);


--
-- TOC entry 4713 (class 2604 OID 16474)
-- Name: login_attempts id; Type: DEFAULT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".login_attempts ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".login_attempts_id_seq'::regclass);


--
-- TOC entry 4716 (class 2604 OID 16485)
-- Name: remarks_thread id; Type: DEFAULT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".remarks_thread ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".remarks_thread_id_seq'::regclass);


--
-- TOC entry 4884 (class 0 OID 16427)
-- Dependencies: 219
-- Data for Name: admins; Type: TABLE DATA; Schema: ComplaintSchema; Owner: postgres
--

COPY "ComplaintSchema".admins (id, admin_id, password_hash) FROM stdin;
1	ADMIN001	$2a$12$mPlljCloprK1sClTo1el.ulcVP4VrS3us9R0EdC76TTdmkuozMy5G
\.


--
-- TOC entry 4886 (class 0 OID 16436)
-- Dependencies: 221
-- Data for Name: employees; Type: TABLE DATA; Schema: ComplaintSchema; Owner: postgres
--

COPY "ComplaintSchema".employees (id, employee_id, password_hash, is_active) FROM stdin;
1	EMP001	$2y$12$Qo.jiqcHYJqojbAwi23b9OIWcyV1Abj8TfFHpoPvMe34tBSMQYPuy	t
\.


--
-- TOC entry 4888 (class 0 OID 16446)
-- Dependencies: 223
-- Data for Name: feedback_complaint_data; Type: TABLE DATA; Schema: ComplaintSchema; Owner: postgres
--

COPY "ComplaintSchema".feedback_complaint_data (id, operation, given_by, given_by_name, date_of_submission, depatment_section, incident_description, main_error_category, sub_error_categor, active_error, latent_error, cognitive_error, non_cognitive_error, root_cause, avg_impact_score, avg_freq_score, immediate_correction, corrective_action, preventive_action, patient_consequences, risk_discription1, impact_score1, freq_score1, risk_discription2, impact_score2, freq_score2, risk_discription3, impact_score3, freq_score3, risk_discription4, impact_score4, freq_score4, risk_discription5, impact_score5, freq_score5, created_at, avg_risk_score, form_no, submitted_by, status, drafted_at, submitted_at, remarks, remarks_updated_by, remarks_updated_at, is_active) FROM stdin;
1	Complaint	Doctor	rabin	2026-07-23	Micro-Biology	sssssssssssss	pre	Wrong label at collection	yes	no	yes	no	jjjjjjjjjjjjjjjjjjj	2.00	4.00	gggggggggggg	ffffffffffff	ffffffffffff	no	hhhhhhhhhhhh	2	4		\N	\N		\N	\N		\N	\N		\N	\N	2026-07-23 13:06:12.411241	8.00	COMP-2026-0002	EMP001	submitted	\N	2026-07-23 13:06:12.411241+05:30	bbbbbbbbbbbb	\N	\N	t
2	Complaint	Staff	REEJA	2026-07-23	test	TESTING	others	IT related error (Hardware / Software)	yes	no	no	no	LEFT	1.00	2.00	DONE	TEST	TEST	yes	TEST	1	2		\N	\N		\N	\N		\N	\N		\N	\N	2026-07-23 13:34:45.127273	2.00	COMP-2026-0002	EMP001	submitted	\N	2026-07-23 13:34:45.127273+05:30	DONE	\N	\N	t
3	Complaint	Doctor	Dr.Balaji	2026-07-23	Hematology	Elixir report is not able to open.Accpac is opening.	pre	Test done late	yes	yes	no	no	test	3.00	4.00	test	test	test	no	test	3	4		\N	\N		\N	\N		\N	\N		\N	\N	2026-07-23 14:38:57.921279	12.00	COMP-2026-0003	EMP001	submitted	2026-07-23 14:40:54.396555+05:30	2026-07-23 14:41:16.780924+05:30	testing	\N	\N	t
4	Complaint	Patient	\N	2026-07-23	Home collection	Patient name: Srinivas Rao.T\r\nHospital ID: AA547895\r\nAn attender of a patient referred by Dr. Surgeon Sir approached the IC Office and stated that they had contacted Mr. Lab Bro for home blood sample collection. They were instructed to send a text message for the request. The attender tried multiple times by calling and texting from Friday to Sunday but did not receive any response until Sunday at 8:00 PM. The sample was finally collected on Monday [by Mr.Santhosh babu] at 8:00am in morning.\r\nThe attender was upset with the late response and there requested that a different staff member be assigned for future home sample collections instead of the same person.	pre	Other in collection	yes	no	no	yes	Home collection coordinator did not send the confirmatory message to the patient on the same day.\r\nPhlebotomist was not professional.\r\nPatient was unhappy with the service.	2.00	2.00	Informed to Home collection in-charge and informed not to send Mr. Santhosh for this patient.		\N	\N		2	2		\N	\N		\N	\N		\N	\N		\N	\N	2026-07-23 15:17:19.132171	4.00	COMP-2026-0004	EMP001	draft	2026-07-23 15:17:45.274014+05:30	\N	\N	\N	\N	t
5	Feedback	Doctor	\N	2026-07-23		Patient name: Santosh devi AA742204- Wrong patient barcode was given by MRD and without verifying SOPD nurse			no	no	no	no		\N	\N			\N	\N		\N	\N		\N	\N		\N	\N		\N	\N		\N	\N	2026-07-23 15:21:05.17561	\N	FB-2026-0005	EMP001	draft	2026-07-23 15:21:05.17561+05:30	\N	\N	\N	\N	t
\.


--
-- TOC entry 4890 (class 0 OID 16458)
-- Dependencies: 225
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
47	department_section	test	7
48	department_section	Collection	8
49	department_section	Others	9
51	department_section	BBK	11
52	department_section	Blood centre	12
53	department_section	Home collection	13
\.


--
-- TOC entry 4892 (class 0 OID 16468)
-- Dependencies: 227
-- Data for Name: login_attempts; Type: TABLE DATA; Schema: ComplaintSchema; Owner: postgres
--

COPY "ComplaintSchema".login_attempts (id, identifier_key, success, attempted_at) FROM stdin;
3	Emp001|172.16.5.167	f	2026-07-23 14:37:12.733212+05:30
4	Emp001|172.16.5.167	f	2026-07-23 14:37:25.75477+05:30
\.


--
-- TOC entry 4894 (class 0 OID 16478)
-- Dependencies: 229
-- Data for Name: remarks_thread; Type: TABLE DATA; Schema: ComplaintSchema; Owner: postgres
--

COPY "ComplaintSchema".remarks_thread (id, submission_id, author, remark_text, created_at) FROM stdin;
1	1	EMP001	kkkk	2026-07-23 13:21:02.105016+05:30
\.


--
-- TOC entry 4908 (class 0 OID 0)
-- Dependencies: 220
-- Name: admins_id_seq; Type: SEQUENCE SET; Schema: ComplaintSchema; Owner: postgres
--

SELECT pg_catalog.setval('"ComplaintSchema".admins_id_seq', 2, true);


--
-- TOC entry 4909 (class 0 OID 0)
-- Dependencies: 224
-- Name: feedback_complaint_data_id_seq; Type: SEQUENCE SET; Schema: ComplaintSchema; Owner: postgres
--

SELECT pg_catalog.setval('"ComplaintSchema".feedback_complaint_data_id_seq', 5, true);


--
-- TOC entry 4910 (class 0 OID 0)
-- Dependencies: 226
-- Name: form_field_options_id_seq; Type: SEQUENCE SET; Schema: ComplaintSchema; Owner: postgres
--

SELECT pg_catalog.setval('"ComplaintSchema".form_field_options_id_seq', 53, true);


--
-- TOC entry 4911 (class 0 OID 0)
-- Dependencies: 228
-- Name: login_attempts_id_seq; Type: SEQUENCE SET; Schema: ComplaintSchema; Owner: postgres
--

SELECT pg_catalog.setval('"ComplaintSchema".login_attempts_id_seq', 6, true);


--
-- TOC entry 4912 (class 0 OID 0)
-- Dependencies: 230
-- Name: remarks_thread_id_seq; Type: SEQUENCE SET; Schema: ComplaintSchema; Owner: postgres
--

SELECT pg_catalog.setval('"ComplaintSchema".remarks_thread_id_seq', 1, true);


--
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 222
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: ComplaintSchema; Owner: postgres
--

SELECT pg_catalog.setval('"ComplaintSchema".users_id_seq', 1, true);


--
-- TOC entry 4719 (class 2606 OID 16435)
-- Name: admins admins_admin_id_key; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".admins
    ADD CONSTRAINT admins_admin_id_key UNIQUE (admin_id);


--
-- TOC entry 4721 (class 2606 OID 16433)
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- TOC entry 4727 (class 2606 OID 16457)
-- Name: feedback_complaint_data feedback_complaint_data_pkey; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".feedback_complaint_data
    ADD CONSTRAINT feedback_complaint_data_pkey PRIMARY KEY (id);


--
-- TOC entry 4729 (class 2606 OID 16467)
-- Name: form_field_options form_field_options_field_name_option_value_key; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".form_field_options
    ADD CONSTRAINT form_field_options_field_name_option_value_key UNIQUE (field_name, option_value);


--
-- TOC entry 4731 (class 2606 OID 16465)
-- Name: form_field_options form_field_options_pkey; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".form_field_options
    ADD CONSTRAINT form_field_options_pkey PRIMARY KEY (id);


--
-- TOC entry 4734 (class 2606 OID 16476)
-- Name: login_attempts login_attempts_pkey; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".login_attempts
    ADD CONSTRAINT login_attempts_pkey PRIMARY KEY (id);


--
-- TOC entry 4737 (class 2606 OID 16487)
-- Name: remarks_thread remarks_thread_pkey; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".remarks_thread
    ADD CONSTRAINT remarks_thread_pkey PRIMARY KEY (id);


--
-- TOC entry 4723 (class 2606 OID 16445)
-- Name: employees users_employee_id_key; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".employees
    ADD CONSTRAINT users_employee_id_key UNIQUE (employee_id);


--
-- TOC entry 4725 (class 2606 OID 16443)
-- Name: employees users_pkey; Type: CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".employees
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4732 (class 1259 OID 16477)
-- Name: idx_login_attempts_key_time; Type: INDEX; Schema: ComplaintSchema; Owner: postgres
--

CREATE INDEX idx_login_attempts_key_time ON "ComplaintSchema".login_attempts USING btree (identifier_key, attempted_at);


--
-- TOC entry 4735 (class 1259 OID 16488)
-- Name: idx_remarks_thread_submission_id; Type: INDEX; Schema: ComplaintSchema; Owner: postgres
--

CREATE INDEX idx_remarks_thread_submission_id ON "ComplaintSchema".remarks_thread USING btree (submission_id);


--
-- TOC entry 4738 (class 2606 OID 16489)
-- Name: remarks_thread remarks_thread_submission_id_fkey; Type: FK CONSTRAINT; Schema: ComplaintSchema; Owner: postgres
--

ALTER TABLE ONLY "ComplaintSchema".remarks_thread
    ADD CONSTRAINT remarks_thread_submission_id_fkey FOREIGN KEY (submission_id) REFERENCES "ComplaintSchema".feedback_complaint_data(id) ON DELETE CASCADE;


-- Completed on 2026-07-23 15:53:55

--
-- PostgreSQL database dump complete
--

\unrestrict LFf7t0eO3aDuvvcLbuDJXbWPYH7BoobULQDzHIulKgTJokUaAqIPsSgkpi4GlXr

