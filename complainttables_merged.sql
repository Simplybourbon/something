--
-- Complaint & Feedback System — full schema
-- This is the content of complainttables.sql (reconstructed as plain SQL),
-- with the one addition found in livetables.sql that was missing here:
-- the pgcrypto extension declaration.
--

CREATE SCHEMA IF NOT EXISTS "ComplaintSchema";

-- ============================================================
-- Present in livetables.sql but NOT in complainttables.sql —
-- added here to bring this file in line with the live server.
-- ============================================================
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


-- ============================================================
-- TABLE: admins
-- ============================================================
CREATE TABLE "ComplaintSchema".admins (
    id integer NOT NULL,
    admin_id character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL
);

CREATE SEQUENCE "ComplaintSchema".admins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE "ComplaintSchema".admins_id_seq OWNED BY "ComplaintSchema".admins.id;
ALTER TABLE ONLY "ComplaintSchema".admins ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".admins_id_seq'::regclass);

ALTER TABLE ONLY "ComplaintSchema".admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);

ALTER TABLE ONLY "ComplaintSchema".admins
    ADD CONSTRAINT admins_admin_id_key UNIQUE (admin_id);


-- ============================================================
-- TABLE: employees
-- ============================================================
CREATE TABLE "ComplaintSchema".employees (
    id integer NOT NULL,
    employee_id character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);

CREATE SEQUENCE "ComplaintSchema".users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE "ComplaintSchema".users_id_seq OWNED BY "ComplaintSchema".employees.id;
ALTER TABLE ONLY "ComplaintSchema".employees ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".users_id_seq'::regclass);

ALTER TABLE ONLY "ComplaintSchema".employees
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);

ALTER TABLE ONLY "ComplaintSchema".employees
    ADD CONSTRAINT users_employee_id_key UNIQUE (employee_id);


-- ============================================================
-- TABLE: feedback_complaint_data
-- (given_by_name column included below, right after given_by)
-- ============================================================
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

CREATE SEQUENCE "ComplaintSchema".feedback_complaint_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE "ComplaintSchema".feedback_complaint_data_id_seq OWNED BY "ComplaintSchema".feedback_complaint_data.id;
ALTER TABLE ONLY "ComplaintSchema".feedback_complaint_data ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".feedback_complaint_data_id_seq'::regclass);

ALTER TABLE ONLY "ComplaintSchema".feedback_complaint_data
    ADD CONSTRAINT feedback_complaint_data_pkey PRIMARY KEY (id);


-- ============================================================
-- TABLE: form_field_options
-- ============================================================
CREATE TABLE "ComplaintSchema".form_field_options (
    id integer NOT NULL,
    field_name character varying(50) NOT NULL,
    option_value character varying(200) NOT NULL,
    display_order integer DEFAULT 0
);

CREATE SEQUENCE "ComplaintSchema".form_field_options_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE "ComplaintSchema".form_field_options_id_seq OWNED BY "ComplaintSchema".form_field_options.id;
ALTER TABLE ONLY "ComplaintSchema".form_field_options ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".form_field_options_id_seq'::regclass);

ALTER TABLE ONLY "ComplaintSchema".form_field_options
    ADD CONSTRAINT form_field_options_pkey PRIMARY KEY (id);

ALTER TABLE ONLY "ComplaintSchema".form_field_options
    ADD CONSTRAINT form_field_options_field_name_option_value_key UNIQUE (field_name, option_value);


-- ============================================================
-- TABLE: login_attempts
-- ============================================================
CREATE TABLE "ComplaintSchema".login_attempts (
    id integer NOT NULL,
    identifier_key character varying(255) NOT NULL,
    success boolean DEFAULT false NOT NULL,
    attempted_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE SEQUENCE "ComplaintSchema".login_attempts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE "ComplaintSchema".login_attempts_id_seq OWNED BY "ComplaintSchema".login_attempts.id;
ALTER TABLE ONLY "ComplaintSchema".login_attempts ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".login_attempts_id_seq'::regclass);

ALTER TABLE ONLY "ComplaintSchema".login_attempts
    ADD CONSTRAINT login_attempts_pkey PRIMARY KEY (id);

CREATE INDEX idx_login_attempts_key_time ON "ComplaintSchema".login_attempts USING btree (identifier_key, attempted_at);


-- ============================================================
-- TABLE: remarks_thread
-- ============================================================
CREATE TABLE "ComplaintSchema".remarks_thread (
    id integer NOT NULL,
    submission_id integer NOT NULL,
    author character varying(50) NOT NULL,
    remark_text text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE SEQUENCE "ComplaintSchema".remarks_thread_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE "ComplaintSchema".remarks_thread_id_seq OWNED BY "ComplaintSchema".remarks_thread.id;
ALTER TABLE ONLY "ComplaintSchema".remarks_thread ALTER COLUMN id SET DEFAULT nextval('"ComplaintSchema".remarks_thread_id_seq'::regclass);

ALTER TABLE ONLY "ComplaintSchema".remarks_thread
    ADD CONSTRAINT remarks_thread_pkey PRIMARY KEY (id);

CREATE INDEX idx_remarks_thread_submission_id ON "ComplaintSchema".remarks_thread USING btree (submission_id);

ALTER TABLE ONLY "ComplaintSchema".remarks_thread
    ADD CONSTRAINT remarks_thread_submission_id_fkey FOREIGN KEY (submission_id) REFERENCES "ComplaintSchema".feedback_complaint_data(id) ON DELETE CASCADE;
