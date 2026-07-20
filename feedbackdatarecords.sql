--
-- PostgreSQL database dump
--

\restrict 2NLVnEshK6BEVgnrXWwARw37HluklwJpC6t8YfJ6G6eDImFyMBdKhiwejZfhUcU

-- Dumped from database version 17.10
-- Dumped by pg_dump version 17.10

-- Started on 2026-07-20 09:20:55

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
-- TOC entry 222 (class 1259 OID 24627)
-- Name: admins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admins (
    id integer NOT NULL,
    admin_id character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL
);


ALTER TABLE public.admins OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24626)
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admins_id_seq OWNER TO postgres;

--
-- TOC entry 4861 (class 0 OID 0)
-- Dependencies: 221
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- TOC entry 220 (class 1259 OID 24618)
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    id integer NOT NULL,
    employee_id character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24581)
-- Name: feedback_complaint_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feedback_complaint_data (
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


ALTER TABLE public.feedback_complaint_data OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24580)
-- Name: feedback_complaint_data_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feedback_complaint_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.feedback_complaint_data_id_seq OWNER TO postgres;

--
-- TOC entry 4862 (class 0 OID 0)
-- Dependencies: 217
-- Name: feedback_complaint_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feedback_complaint_data_id_seq OWNED BY public.feedback_complaint_data.id;


--
-- TOC entry 224 (class 1259 OID 24649)
-- Name: form_field_options; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.form_field_options (
    id integer NOT NULL,
    field_name character varying(50) NOT NULL,
    option_value character varying(200) NOT NULL,
    display_order integer DEFAULT 0
);


ALTER TABLE public.form_field_options OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24648)
-- Name: form_field_options_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.form_field_options_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.form_field_options_id_seq OWNER TO postgres;

--
-- TOC entry 4863 (class 0 OID 0)
-- Dependencies: 223
-- Name: form_field_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.form_field_options_id_seq OWNED BY public.form_field_options.id;


--
-- TOC entry 228 (class 1259 OID 24680)
-- Name: login_attempts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login_attempts (
    id integer NOT NULL,
    identifier_key character varying(255) NOT NULL,
    success boolean DEFAULT false NOT NULL,
    attempted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.login_attempts OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 24679)
-- Name: login_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.login_attempts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.login_attempts_id_seq OWNER TO postgres;

--
-- TOC entry 4864 (class 0 OID 0)
-- Dependencies: 227
-- Name: login_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.login_attempts_id_seq OWNED BY public.login_attempts.id;


--
-- TOC entry 226 (class 1259 OID 24664)
-- Name: remarks_thread; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.remarks_thread (
    id integer NOT NULL,
    submission_id integer NOT NULL,
    author character varying(50) NOT NULL,
    remark_text text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.remarks_thread OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24663)
-- Name: remarks_thread_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.remarks_thread_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.remarks_thread_id_seq OWNER TO postgres;

--
-- TOC entry 4865 (class 0 OID 0)
-- Dependencies: 225
-- Name: remarks_thread_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.remarks_thread_id_seq OWNED BY public.remarks_thread.id;


--
-- TOC entry 219 (class 1259 OID 24617)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 4866 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.employees.id;


--
-- TOC entry 4670 (class 2604 OID 24630)
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- TOC entry 4669 (class 2604 OID 24621)
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4666 (class 2604 OID 24584)
-- Name: feedback_complaint_data id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback_complaint_data ALTER COLUMN id SET DEFAULT nextval('public.feedback_complaint_data_id_seq'::regclass);


--
-- TOC entry 4671 (class 2604 OID 24652)
-- Name: form_field_options id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.form_field_options ALTER COLUMN id SET DEFAULT nextval('public.form_field_options_id_seq'::regclass);


--
-- TOC entry 4675 (class 2604 OID 24683)
-- Name: login_attempts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_attempts ALTER COLUMN id SET DEFAULT nextval('public.login_attempts_id_seq'::regclass);


--
-- TOC entry 4673 (class 2604 OID 24667)
-- Name: remarks_thread id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.remarks_thread ALTER COLUMN id SET DEFAULT nextval('public.remarks_thread_id_seq'::regclass);


--
-- TOC entry 4849 (class 0 OID 24627)
-- Dependencies: 222
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admins (id, admin_id, password_hash) FROM stdin;
1	ADMIN001	$2y$12$y6.YD6NyD6In6YO52rKNSeVJII21Dht1w99f2KPgf4PqoViQpzvWq
\.


--
-- TOC entry 4847 (class 0 OID 24618)
-- Dependencies: 220
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (id, employee_id, password_hash) FROM stdin;
1	EMP001	$2y$12$y6.YD6NyD6In6YO52rKNSeVJII21Dht1w99f2KPgf4PqoViQpzvWq
4	ADMIN001	$2y$12$uaV8V5VTCQer0cILvt2/MOr75DocpbX1YwgRpMYoruvshw3O.jLe2
6	ADMIN002	$2y$12$MzNonWkG/N/.c.24OgMnu.QWsUW7oVT6iLpL5Knf8J0zr.69UmAzy
7	EMP003	$2y$12$EhxTwl4MqASjShHfslCGJOURHuKjYCfYmlx2LOnvuQq/KNIFVzPeG
\.


--
-- TOC entry 4845 (class 0 OID 24581)
-- Dependencies: 218
-- Data for Name: feedback_complaint_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feedback_complaint_data (id, operation, given_by, date_of_submission, depatment_section, incident_description, main_error_category, sub_error_categor, active_error, latent_error, cognitive_error, non_cognitive_error, root_cause, avg_impact_score, avg_freq_score, immediate_correction, corrective_action, preventive_action, patient_consequences, risk_discription1, impact_score1, freq_score1, risk_discription2, impact_score2, freq_score2, risk_discription3, impact_score3, freq_score3, risk_discription4, impact_score4, freq_score4, risk_discription5, impact_score5, freq_score5, created_at, avg_risk_score, form_no, submitted_by, status, drafted_at, submitted_at, remarks, remarks_updated_by, remarks_updated_at) FROM stdin;
1	Complaint		2026-07-15					no	no	no	no		\N	\N			\N	\N		\N	\N		\N	\N		\N	\N		\N	\N		\N	\N	2026-07-15 14:55:39.406716	\N	COMP-2026-0002	EMP001	draft	2026-07-15 14:55:39.406716+05:30	\N	\N	\N	\N
4	Complaint	Patient	2026-07-16	Clinical-Pathology	m,mmmmmmmmmmmmm	analytic	Analysis	yes	no	no	no	mmmmmmmmmm	5.00	2.00	nnnnnnnnnn	mmmmmmmmmm	mmmmmmmmm	yes	mmmmmmmm	5	1	hhhhhhhhh	5	3		\N	\N		\N	\N		\N	\N	2026-07-16 12:46:10.541179	10.00	COMP-2026-0004	ADMIN001	submitted	\N	2026-07-16 12:46:10.541179+05:30	nnnnnnnnnn	\N	\N
2	Complaint	Doctor	2026-07-15	test	In Elixir some of the reports are not viewed. Available in sage accpac	post	Other	no	yes	no	no	Data reading issue	1.00	2.00	Informed to MIS	Issue rectified	\N	\N	Delay in treatment	1	2		\N	\N		\N	\N		\N	\N		\N	\N	2026-07-15 16:29:48.536878	2.00	COMP-2026-0002	EMP001	submitted	2026-07-15 16:29:48.536878+05:30	2026-07-15 16:35:12.720957+05:30	jjdkdkkkiii	EMP001	2026-07-16 12:55:55.947543+05:30
6	Complaint	Doctor	2026-07-17	Bio-Chemistry	MIcral result showing yes, no result entered , test not done	pre	Test not done / sample not collected	yes	no	no	yes	On 22nd patient had given blood test and urine for lab investigation.\r\nurine routine and urine micral and sample given to biochemistry. While validating other report by mistakenly entry as yes. As it was entered as Yes. the test was marked as done hence the the test was not done.	2.50	2.00	Removed yes from the report an informed the mis to access only the numerical result	Mis has removed the qualitative entery option only numericals result should be entered for micral test before validating the report please varify the result and ensure it is accurate	Checked all the numerical reports and disaabled aphabetical entry	yes	Test not done	3	2	Wrong report entered	2	2		\N	\N		\N	\N		\N	\N	2026-07-17 10:07:04.752424	5.00	COMP-2026-0006	EMP001	submitted	\N	2026-07-17 10:07:04.752424+05:30	Delay in report as test is done late	\N	\N
7	Complaint	Doctor	2026-07-17	Histo-Pathology	Patient Mrd no. AA712483, but on the sample front view OT staff has stuck the wrong patient barcode AB156707. Found in the lab while generating the order. Informed sis Helen on 02/06/2026 at 5:20 pm	others	No lab error	yes	no	no	yes	Both the patients were admitted in the same room the ward staff had kept both the barcodes together in one patient file. Wrong barcode was attached with the patient who was posted for surgery, the staff posted in preop failed to verify 2 identifiers while receiving patient and floor nurse also failed to check the identifiers before placing the barcode on the specimen container	4.00	1.50	Informed OT and raised incident.	The specimen was brought from lab and the correct barcode was placed on the specimen container and sent to Lab.	Staff training conducted and sensitized to adhere to two identifier at all level before receiving patient in preop area, before labelling and before taking the specimen to LabNo Lab error	no	wrong label	4	1	wrong sample	4	2		\N	\N		\N	\N		\N	\N	2026-07-17 10:08:38.312512	6.00	COMP-2026-0007	EMP001	submitted	2026-07-17 10:08:38.312512+05:30	2026-07-17 10:14:56.176747+05:30	informed to OT for corrective action	\N	\N
8	Complaint	Doctor	2026-07-17	Bio-Chemistry	Wrongly billed for  TPSA  instead of Total Protein and Albumin by the cash counter. Lab staff (Salomi) also did not check the test properly & collected the blood sample.	pre	Wrong order / wrong test	yes	no	no	yes	RC: Wrong billing done by cash counter. Lab staff also without checking the order, sample collected for TPSA, instead of total protein and albumin. Sis Sonu checked in the OPD, informed to the Lab staff that time.	3.50	1.50	Refunded the money for TPSA	total protein and albumin order created and test been done	Check the test Order and code. Training provided	yes	Wrong test billed	3	2	wrong test done	4	1		\N	\N		\N	\N		\N	\N	2026-07-17 10:19:42.000521	5.00	COMP-2026-0008	EMP001	submitted	\N	2026-07-17 10:19:42.000521+05:30	wrong test done	\N	\N
9	Non-Conforming Activity	Staff	2026-07-19	Micro-Biology	nnnnnn	pre	Wrong sample	no	yes	no	no	nnnnnnnnnnn	2.00	2.50	nnnnnnnnnn	nnnnnnnnnnnn	nnnnnnnnnn	yes	b	1	3	hhh	3	2		\N	\N		\N	\N		\N	\N	2026-07-19 22:14:52.807835	4.50	NCA-2026-0009	EMP001	submitted	\N	2026-07-19 22:14:52.807835+05:30	nnnnnnnnnnnnnn	\N	\N
\.


--
-- TOC entry 4851 (class 0 OID 24649)
-- Dependencies: 224
-- Data for Name: form_field_options; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.form_field_options (id, field_name, option_value, display_order) FROM stdin;
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
-- TOC entry 4855 (class 0 OID 24680)
-- Dependencies: 228
-- Data for Name: login_attempts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login_attempts (id, identifier_key, success, attempted_at) FROM stdin;
2	EMP001|::1	f	2026-07-19 23:37:02.241702+05:30
3	EMP001|::1	f	2026-07-19 23:37:06.503478+05:30
4	EMP001|::1	f	2026-07-19 23:37:11.300888+05:30
5	EMP001|::1	f	2026-07-19 23:37:13.410884+05:30
6	EMP001|::1	f	2026-07-19 23:37:15.594954+05:30
\.


--
-- TOC entry 4853 (class 0 OID 24664)
-- Dependencies: 226
-- Data for Name: remarks_thread; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.remarks_thread (id, submission_id, author, remark_text, created_at) FROM stdin;
4	6	EMP001	Approve	2026-07-17 10:07:34.265264+05:30
\.


--
-- TOC entry 4867 (class 0 OID 0)
-- Dependencies: 221
-- Name: admins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admins_id_seq', 1, true);


--
-- TOC entry 4868 (class 0 OID 0)
-- Dependencies: 217
-- Name: feedback_complaint_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feedback_complaint_data_id_seq', 9, true);


--
-- TOC entry 4869 (class 0 OID 0)
-- Dependencies: 223
-- Name: form_field_options_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.form_field_options_id_seq', 47, true);


--
-- TOC entry 4870 (class 0 OID 0)
-- Dependencies: 227
-- Name: login_attempts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.login_attempts_id_seq', 6, true);


--
-- TOC entry 4871 (class 0 OID 0)
-- Dependencies: 225
-- Name: remarks_thread_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.remarks_thread_id_seq', 4, true);


--
-- TOC entry 4872 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 8, true);


--
-- TOC entry 4685 (class 2606 OID 24634)
-- Name: admins admins_admin_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_admin_id_key UNIQUE (admin_id);


--
-- TOC entry 4687 (class 2606 OID 24632)
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- TOC entry 4679 (class 2606 OID 24589)
-- Name: feedback_complaint_data feedback_complaint_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback_complaint_data
    ADD CONSTRAINT feedback_complaint_data_pkey PRIMARY KEY (id);


--
-- TOC entry 4689 (class 2606 OID 24657)
-- Name: form_field_options form_field_options_field_name_option_value_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.form_field_options
    ADD CONSTRAINT form_field_options_field_name_option_value_key UNIQUE (field_name, option_value);


--
-- TOC entry 4691 (class 2606 OID 24655)
-- Name: form_field_options form_field_options_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.form_field_options
    ADD CONSTRAINT form_field_options_pkey PRIMARY KEY (id);


--
-- TOC entry 4697 (class 2606 OID 24687)
-- Name: login_attempts login_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_attempts
    ADD CONSTRAINT login_attempts_pkey PRIMARY KEY (id);


--
-- TOC entry 4694 (class 2606 OID 24672)
-- Name: remarks_thread remarks_thread_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.remarks_thread
    ADD CONSTRAINT remarks_thread_pkey PRIMARY KEY (id);


--
-- TOC entry 4681 (class 2606 OID 24625)
-- Name: employees users_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT users_employee_id_key UNIQUE (employee_id);


--
-- TOC entry 4683 (class 2606 OID 24623)
-- Name: employees users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4695 (class 1259 OID 24688)
-- Name: idx_login_attempts_key_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_login_attempts_key_time ON public.login_attempts USING btree (identifier_key, attempted_at);


--
-- TOC entry 4692 (class 1259 OID 24678)
-- Name: idx_remarks_thread_submission_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_remarks_thread_submission_id ON public.remarks_thread USING btree (submission_id);


--
-- TOC entry 4698 (class 2606 OID 24673)
-- Name: remarks_thread remarks_thread_submission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.remarks_thread
    ADD CONSTRAINT remarks_thread_submission_id_fkey FOREIGN KEY (submission_id) REFERENCES public.feedback_complaint_data(id) ON DELETE CASCADE;


-- Completed on 2026-07-20 09:20:56

--
-- PostgreSQL database dump complete
--

\unrestrict 2NLVnEshK6BEVgnrXWwARw37HluklwJpC6t8YfJ6G6eDImFyMBdKhiwejZfhUcU

