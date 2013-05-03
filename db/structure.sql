--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: collection_photographs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE collection_photographs (
    id integer NOT NULL,
    collection_id integer,
    photograph_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: collection_photographs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE collection_photographs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collection_photographs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE collection_photographs_id_seq OWNED BY collection_photographs.id;


--
-- Name: collections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE collections (
    id integer NOT NULL,
    user_id integer,
    name character varying(255),
    public boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: collections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE collections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE collections_id_seq OWNED BY collections.id;


--
-- Name: licenses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE licenses (
    id integer NOT NULL,
    name character varying(255),
    code character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: licenses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE licenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: licenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE licenses_id_seq OWNED BY licenses.id;


--
-- Name: metadata; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE metadata (
    id integer NOT NULL,
    photograph_id integer,
    title character varying(255),
    description text,
    keywords character varying(255)[],
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    camera hstore,
    creator hstore,
    image hstore,
    settings hstore
);


--
-- Name: metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE metadata_id_seq OWNED BY metadata.id;


--
-- Name: photographs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE photographs (
    id integer NOT NULL,
    user_id integer,
    image_uid character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    safe_for_work boolean DEFAULT true,
    license_id integer
);


--
-- Name: photographs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE photographs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: photographs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE photographs_id_seq OWNED BY photographs.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(128) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY collection_photographs ALTER COLUMN id SET DEFAULT nextval('collection_photographs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY collections ALTER COLUMN id SET DEFAULT nextval('collections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY licenses ALTER COLUMN id SET DEFAULT nextval('licenses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY metadata ALTER COLUMN id SET DEFAULT nextval('metadata_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY photographs ALTER COLUMN id SET DEFAULT nextval('photographs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: collection_photographs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY collection_photographs
    ADD CONSTRAINT collection_photographs_pkey PRIMARY KEY (id);


--
-- Name: collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);


--
-- Name: licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY licenses
    ADD CONSTRAINT licenses_pkey PRIMARY KEY (id);


--
-- Name: metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY metadata
    ADD CONSTRAINT metadata_pkey PRIMARY KEY (id);


--
-- Name: photographs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY photographs
    ADD CONSTRAINT photographs_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_collection_photographs_on_collection_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_collection_photographs_on_collection_id ON collection_photographs USING btree (collection_id);


--
-- Name: index_collection_photographs_on_photograph_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_collection_photographs_on_photograph_id ON collection_photographs USING btree (photograph_id);


--
-- Name: index_collections_on_public; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_collections_on_public ON collections USING btree (public);


--
-- Name: index_collections_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_collections_on_user_id ON collections USING btree (user_id);


--
-- Name: index_metadata_on_photograph_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_metadata_on_photograph_id ON metadata USING btree (photograph_id);


--
-- Name: index_photographs_on_license_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_photographs_on_license_id ON photographs USING btree (license_id);


--
-- Name: index_photographs_on_safe_for_work; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_photographs_on_safe_for_work ON photographs USING btree (safe_for_work);


--
-- Name: index_photographs_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_photographs_on_user_id ON photographs USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20130429234245');

INSERT INTO schema_migrations (version) VALUES ('20130430001433');

INSERT INTO schema_migrations (version) VALUES ('20130430084054');

INSERT INTO schema_migrations (version) VALUES ('20130430092117');

INSERT INTO schema_migrations (version) VALUES ('20130430214315');

INSERT INTO schema_migrations (version) VALUES ('20130430214425');

INSERT INTO schema_migrations (version) VALUES ('20130502000100');

INSERT INTO schema_migrations (version) VALUES ('20130502000711');

INSERT INTO schema_migrations (version) VALUES ('20130503110219');

INSERT INTO schema_migrations (version) VALUES ('20130503110857');
