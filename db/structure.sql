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


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin_users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
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
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_users_id_seq OWNED BY admin_users.id;


--
-- Name: authorisations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE authorisations (
    id integer NOT NULL,
    user_id integer,
    provider character varying(255),
    uid character varying(255),
    info hstore,
    credentials hstore,
    extra hstore,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    auto_post boolean DEFAULT false
);


--
-- Name: authorisations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE authorisations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authorisations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE authorisations_id_seq OWNED BY authorisations.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255),
    slug character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


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
    visible boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    shared boolean DEFAULT false,
    encrypted_password character varying(255),
    ghost boolean DEFAULT false,
    description text,
    last_photo_added_at timestamp without time zone
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
-- Name: comment_hierarchies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comment_hierarchies (
    ancestor_id integer NOT NULL,
    descendant_id integer NOT NULL,
    generations integer NOT NULL
);


--
-- Name: comment_threads; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comment_threads (
    id integer NOT NULL,
    user_id integer,
    threadable_id integer,
    threadable_type character varying(255),
    subject text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: comment_threads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comment_threads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comment_threads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comment_threads_id_seq OWNED BY comment_threads.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    comment_thread_id integer,
    user_id integer,
    body text,
    published boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    parent_id integer
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: favourites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE favourites (
    id integer NOT NULL,
    user_id integer,
    photograph_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: favourites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE favourites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favourites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE favourites_id_seq OWNED BY favourites.id;


--
-- Name: followings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE followings (
    id integer NOT NULL,
    followee_id integer,
    follower_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: followings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE followings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: followings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE followings_id_seq OWNED BY followings.id;


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
    settings hstore,
    search_vector tsvector,
    processing boolean DEFAULT false
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
-- Name: notifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notifications (
    id integer NOT NULL,
    user_id integer,
    notifiable_id integer,
    notifiable_type character varying(255),
    subject character varying(255),
    body text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    read boolean DEFAULT false,
    send_email boolean DEFAULT false
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


--
-- Name: old_usernames; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE old_usernames (
    id integer NOT NULL,
    user_id integer,
    username character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: old_usernames_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE old_usernames_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: old_usernames_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE old_usernames_id_seq OWNED BY old_usernames.id;


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
    license_id integer,
    show_location_data boolean DEFAULT false,
    category_id integer,
    show_copyright_info boolean DEFAULT false,
    standard_image_uid character varying(255),
    recommendations_count integer,
    favourites_count integer,
    image_name character varying(255),
    image_ext character varying(255),
    image_size integer,
    homepage_image_uid character varying(255),
    large_image_uid character varying(255),
    thumbnail_image_uid character varying(255),
    processing boolean DEFAULT false,
    image_mime_type character varying(255),
    enable_comments boolean DEFAULT false,
    auto_mentioned boolean DEFAULT false,
    ghost boolean DEFAULT false,
    small_thumbnail_image_uid character varying(255)
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
-- Name: recommendations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE recommendations (
    id integer NOT NULL,
    photograph_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: recommendations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recommendations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recommendations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recommendations_id_seq OWNED BY recommendations.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reports (
    id integer NOT NULL,
    reportable_id integer,
    reportable_type character varying(255),
    user_id integer,
    reason text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reports_id_seq OWNED BY reports.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sidekiq_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sidekiq_jobs (
    id integer NOT NULL,
    jid character varying(255),
    queue character varying(255),
    class_name character varying(255),
    args text,
    retry boolean,
    enqueued_at timestamp without time zone,
    started_at timestamp without time zone,
    finished_at timestamp without time zone,
    status character varying(255),
    name character varying(255),
    result text
);


--
-- Name: sidekiq_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sidekiq_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sidekiq_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sidekiq_jobs_id_seq OWNED BY sidekiq_jobs.id;


--
-- Name: stories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stories (
    id integer NOT NULL,
    user_id integer,
    subject_id integer,
    subject_type character varying(255),
    key character varying(255),
    "values" hstore,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: stories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stories_id_seq OWNED BY stories.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying(255),
    location character varying(255),
    default_license_id integer,
    avatar_uid character varying(255),
    show_location_data boolean DEFAULT false,
    invitation_token character varying(60),
    invitation_sent_at timestamp without time zone,
    invitation_accepted_at timestamp without time zone,
    invitation_limit integer,
    invited_by_id integer,
    invited_by_type character varying(255),
    show_nsfw_content boolean DEFAULT false,
    recommendation_quota integer,
    photographs_count integer,
    show_copyright_info boolean DEFAULT true,
    biography text,
    website_url character varying(255),
    recommendations_count integer,
    channel_key uuid DEFAULT uuid_generate_v4(),
    upload_quota integer,
    enable_comments boolean DEFAULT false,
    receive_notification_emails boolean DEFAULT true,
    notify_favourites boolean DEFAULT true,
    show_social_buttons boolean DEFAULT true,
    username character varying(255),
    locale character varying(255) DEFAULT 'en'::character varying,
    enable_comments_by_default boolean DEFAULT false,
    moderator boolean DEFAULT false,
    show_profile_background boolean DEFAULT true,
    profile_background_photo_id integer
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

ALTER TABLE ONLY admin_users ALTER COLUMN id SET DEFAULT nextval('admin_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY authorisations ALTER COLUMN id SET DEFAULT nextval('authorisations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


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

ALTER TABLE ONLY comment_threads ALTER COLUMN id SET DEFAULT nextval('comment_threads_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY favourites ALTER COLUMN id SET DEFAULT nextval('favourites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY followings ALTER COLUMN id SET DEFAULT nextval('followings_id_seq'::regclass);


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

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY old_usernames ALTER COLUMN id SET DEFAULT nextval('old_usernames_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY photographs ALTER COLUMN id SET DEFAULT nextval('photographs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY recommendations ALTER COLUMN id SET DEFAULT nextval('recommendations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reports ALTER COLUMN id SET DEFAULT nextval('reports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sidekiq_jobs ALTER COLUMN id SET DEFAULT nextval('sidekiq_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stories ALTER COLUMN id SET DEFAULT nextval('stories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: authorisations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY authorisations
    ADD CONSTRAINT authorisations_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


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
-- Name: comment_threads_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comment_threads
    ADD CONSTRAINT comment_threads_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: favourites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY favourites
    ADD CONSTRAINT favourites_pkey PRIMARY KEY (id);


--
-- Name: followings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY followings
    ADD CONSTRAINT followings_pkey PRIMARY KEY (id);


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
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: old_usernames_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY old_usernames
    ADD CONSTRAINT old_usernames_pkey PRIMARY KEY (id);


--
-- Name: photographs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY photographs
    ADD CONSTRAINT photographs_pkey PRIMARY KEY (id);


--
-- Name: recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY recommendations
    ADD CONSTRAINT recommendations_pkey PRIMARY KEY (id);


--
-- Name: reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: sidekiq_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sidekiq_jobs
    ADD CONSTRAINT sidekiq_jobs_pkey PRIMARY KEY (id);


--
-- Name: stories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stories
    ADD CONSTRAINT stories_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_email ON admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON admin_users USING btree (reset_password_token);


--
-- Name: index_authorisations_on_provider_and_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authorisations_on_provider_and_uid ON authorisations USING btree (provider, uid);


--
-- Name: index_authorisations_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authorisations_on_user_id ON authorisations USING btree (user_id);


--
-- Name: index_authorisations_on_user_id_and_auto_post; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authorisations_on_user_id_and_auto_post ON authorisations USING btree (user_id, auto_post);


--
-- Name: index_authorisations_on_user_id_and_provider; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authorisations_on_user_id_and_provider ON authorisations USING btree (user_id, provider);


--
-- Name: index_categories_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_on_slug ON categories USING btree (slug);


--
-- Name: index_collection_photographs_on_collection_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_collection_photographs_on_collection_id ON collection_photographs USING btree (collection_id);


--
-- Name: index_collection_photographs_on_photograph_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_collection_photographs_on_photograph_id ON collection_photographs USING btree (photograph_id);


--
-- Name: index_collections_on_ghost; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_collections_on_ghost ON collections USING btree (ghost);


--
-- Name: index_collections_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_collections_on_user_id ON collections USING btree (user_id);


--
-- Name: index_collections_on_visible; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_collections_on_visible ON collections USING btree (visible);


--
-- Name: index_comment_hierarchies_on_ancestor_id_and_descendant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_comment_hierarchies_on_ancestor_id_and_descendant_id ON comment_hierarchies USING btree (ancestor_id, descendant_id);


--
-- Name: index_comment_hierarchies_on_descendant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comment_hierarchies_on_descendant_id ON comment_hierarchies USING btree (descendant_id);


--
-- Name: index_comment_threads_on_threadable_id_and_threadable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comment_threads_on_threadable_id_and_threadable_type ON comment_threads USING btree (threadable_id, threadable_type);


--
-- Name: index_comment_threads_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comment_threads_on_user_id ON comment_threads USING btree (user_id);


--
-- Name: index_comments_on_comment_thread_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_comment_thread_id ON comments USING btree (comment_thread_id);


--
-- Name: index_comments_on_comment_thread_id_and_published; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_comment_thread_id_and_published ON comments USING btree (comment_thread_id, published);


--
-- Name: index_comments_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_parent_id ON comments USING btree (parent_id);


--
-- Name: index_comments_on_published; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_published ON comments USING btree (published);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_user_id ON comments USING btree (user_id);


--
-- Name: index_favourites_on_photograph_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_favourites_on_photograph_id ON favourites USING btree (photograph_id);


--
-- Name: index_favourites_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_favourites_on_user_id ON favourites USING btree (user_id);


--
-- Name: index_followings_on_followee_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_followings_on_followee_id ON followings USING btree (followee_id);


--
-- Name: index_followings_on_follower_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_followings_on_follower_id ON followings USING btree (follower_id);


--
-- Name: index_metadata_on_photograph_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_metadata_on_photograph_id ON metadata USING btree (photograph_id);


--
-- Name: index_metadata_on_search_vector; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_metadata_on_search_vector ON metadata USING gin (search_vector);


--
-- Name: index_notifications_on_notifiable_id_and_notifiable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_notifiable_id_and_notifiable_type ON notifications USING btree (notifiable_id, notifiable_type);


--
-- Name: index_notifications_on_read; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_read ON notifications USING btree (read);


--
-- Name: index_notifications_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_user_id ON notifications USING btree (user_id);


--
-- Name: index_old_usernames_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_old_usernames_on_user_id ON old_usernames USING btree (user_id);


--
-- Name: index_old_usernames_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_old_usernames_on_username ON old_usernames USING btree (username);


--
-- Name: index_photographs_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_photographs_on_category_id ON photographs USING btree (category_id);


--
-- Name: index_photographs_on_ghost; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_photographs_on_ghost ON photographs USING btree (ghost);


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
-- Name: index_recommendations_on_photograph_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_recommendations_on_photograph_id ON recommendations USING btree (photograph_id);


--
-- Name: index_recommendations_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_recommendations_on_user_id ON recommendations USING btree (user_id);


--
-- Name: index_reports_on_reportable_id_and_reportable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reports_on_reportable_id_and_reportable_type ON reports USING btree (reportable_id, reportable_type);


--
-- Name: index_reports_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reports_on_user_id ON reports USING btree (user_id);


--
-- Name: index_sidekiq_jobs_on_class_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sidekiq_jobs_on_class_name ON sidekiq_jobs USING btree (class_name);


--
-- Name: index_sidekiq_jobs_on_enqueued_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sidekiq_jobs_on_enqueued_at ON sidekiq_jobs USING btree (enqueued_at);


--
-- Name: index_sidekiq_jobs_on_finished_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sidekiq_jobs_on_finished_at ON sidekiq_jobs USING btree (finished_at);


--
-- Name: index_sidekiq_jobs_on_jid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sidekiq_jobs_on_jid ON sidekiq_jobs USING btree (jid);


--
-- Name: index_sidekiq_jobs_on_queue; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sidekiq_jobs_on_queue ON sidekiq_jobs USING btree (queue);


--
-- Name: index_sidekiq_jobs_on_retry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sidekiq_jobs_on_retry ON sidekiq_jobs USING btree (retry);


--
-- Name: index_sidekiq_jobs_on_started_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sidekiq_jobs_on_started_at ON sidekiq_jobs USING btree (started_at);


--
-- Name: index_sidekiq_jobs_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sidekiq_jobs_on_status ON sidekiq_jobs USING btree (status);


--
-- Name: index_stories_on_subject_id_and_subject_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stories_on_subject_id_and_subject_type ON stories USING btree (subject_id, subject_type);


--
-- Name: index_stories_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stories_on_user_id ON stories USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_invitation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_invitation_token ON users USING btree (invitation_token);


--
-- Name: index_users_on_invited_by_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_invited_by_id ON users USING btree (invited_by_id);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: metadata_gin_keywords; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX metadata_gin_keywords ON metadata USING gin (keywords);


--
-- Name: metadata_image_gin; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX metadata_image_gin ON metadata USING gin (image);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: metadata_vector_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER metadata_vector_update BEFORE INSERT OR UPDATE ON metadata FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('search_vector', 'pg_catalog.english', 'title', 'description');


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

INSERT INTO schema_migrations (version) VALUES ('20130503174811');

INSERT INTO schema_migrations (version) VALUES ('20130503222325');

INSERT INTO schema_migrations (version) VALUES ('20130503225818');

INSERT INTO schema_migrations (version) VALUES ('20130504071626');

INSERT INTO schema_migrations (version) VALUES ('20130504202315');

INSERT INTO schema_migrations (version) VALUES ('20130504210246');

INSERT INTO schema_migrations (version) VALUES ('20130504213832');

INSERT INTO schema_migrations (version) VALUES ('20130505180844');

INSERT INTO schema_migrations (version) VALUES ('20130505185219');

INSERT INTO schema_migrations (version) VALUES ('20130506003536');

INSERT INTO schema_migrations (version) VALUES ('20130506222702');

INSERT INTO schema_migrations (version) VALUES ('20130507101348');

INSERT INTO schema_migrations (version) VALUES ('20130507130212');

INSERT INTO schema_migrations (version) VALUES ('20130507230144');

INSERT INTO schema_migrations (version) VALUES ('20130508183202');

INSERT INTO schema_migrations (version) VALUES ('20130508222338');

INSERT INTO schema_migrations (version) VALUES ('20130509123705');

INSERT INTO schema_migrations (version) VALUES ('20130510225834');

INSERT INTO schema_migrations (version) VALUES ('20130510231125');

INSERT INTO schema_migrations (version) VALUES ('20130512093545');

INSERT INTO schema_migrations (version) VALUES ('20130512100329');

INSERT INTO schema_migrations (version) VALUES ('20130512105305');

INSERT INTO schema_migrations (version) VALUES ('20130512105909');

INSERT INTO schema_migrations (version) VALUES ('20130512114945');

INSERT INTO schema_migrations (version) VALUES ('20130516212700');

INSERT INTO schema_migrations (version) VALUES ('20130518102856');

INSERT INTO schema_migrations (version) VALUES ('20130521173713');

INSERT INTO schema_migrations (version) VALUES ('20130521174315');

INSERT INTO schema_migrations (version) VALUES ('20130522122447');

INSERT INTO schema_migrations (version) VALUES ('20130523163304');

INSERT INTO schema_migrations (version) VALUES ('20130523225313');

INSERT INTO schema_migrations (version) VALUES ('20130530180641');

INSERT INTO schema_migrations (version) VALUES ('20130530221819');

INSERT INTO schema_migrations (version) VALUES ('20130602092220');

INSERT INTO schema_migrations (version) VALUES ('20130602171743');

INSERT INTO schema_migrations (version) VALUES ('20130603083149');

INSERT INTO schema_migrations (version) VALUES ('20130604173711');

INSERT INTO schema_migrations (version) VALUES ('20130604201040');

INSERT INTO schema_migrations (version) VALUES ('20130608105451');

INSERT INTO schema_migrations (version) VALUES ('20130608154646');

INSERT INTO schema_migrations (version) VALUES ('20130708120849');

INSERT INTO schema_migrations (version) VALUES ('20130711162130');

INSERT INTO schema_migrations (version) VALUES ('20130713123834');

INSERT INTO schema_migrations (version) VALUES ('20130715225941');

INSERT INTO schema_migrations (version) VALUES ('20130718114116');

INSERT INTO schema_migrations (version) VALUES ('20130718220746');

INSERT INTO schema_migrations (version) VALUES ('20130719122054');

INSERT INTO schema_migrations (version) VALUES ('20130728122457');

INSERT INTO schema_migrations (version) VALUES ('20130731183731');

INSERT INTO schema_migrations (version) VALUES ('20130817222930');

INSERT INTO schema_migrations (version) VALUES ('20130819154534');

INSERT INTO schema_migrations (version) VALUES ('20130826132056');

INSERT INTO schema_migrations (version) VALUES ('20130826172509');

INSERT INTO schema_migrations (version) VALUES ('20130830080641');
