--
-- PostgreSQL database dump
--

-- Dumped from database version 10.0
-- Dumped by pg_dump version 10.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

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
-- Name: channel_member; Type: TABLE; Schema: public; Owner: chrisdascoli
--

CREATE TABLE channel_member (
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    channel_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE channel_member OWNER TO chrisdascoli;

--
-- Name: channels; Type: TABLE; Schema: public; Owner: chrisdascoli
--

CREATE TABLE channels (
    id integer NOT NULL,
    name character varying(255),
    public boolean DEFAULT true,
    dm boolean DEFAULT false,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    team_id integer
);


ALTER TABLE channels OWNER TO chrisdascoli;

--
-- Name: channels_id_seq; Type: SEQUENCE; Schema: public; Owner: chrisdascoli
--

CREATE SEQUENCE channels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE channels_id_seq OWNER TO chrisdascoli;

--
-- Name: channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrisdascoli
--

ALTER SEQUENCE channels_id_seq OWNED BY channels.id;


--
-- Name: direct_messages; Type: TABLE; Schema: public; Owner: chrisdascoli
--

CREATE TABLE direct_messages (
    id integer NOT NULL,
    text character varying(255),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    team_id integer,
    sender_id integer,
    receiver_id integer
);


ALTER TABLE direct_messages OWNER TO chrisdascoli;

--
-- Name: direct_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: chrisdascoli
--

CREATE SEQUENCE direct_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE direct_messages_id_seq OWNER TO chrisdascoli;

--
-- Name: direct_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrisdascoli
--

ALTER SEQUENCE direct_messages_id_seq OWNED BY direct_messages.id;


--
-- Name: member; Type: TABLE; Schema: public; Owner: chrisdascoli
--

CREATE TABLE member (
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    team_id integer NOT NULL
);


ALTER TABLE member OWNER TO chrisdascoli;

--
-- Name: members; Type: TABLE; Schema: public; Owner: chrisdascoli
--

CREATE TABLE members (
    admin boolean DEFAULT false,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    team_id integer NOT NULL
);


ALTER TABLE members OWNER TO chrisdascoli;

--
-- Name: messages; Type: TABLE; Schema: public; Owner: chrisdascoli
--

CREATE TABLE messages (
    id integer NOT NULL,
    text character varying(255),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    channel_id integer,
    user_id integer
);


ALTER TABLE messages OWNER TO chrisdascoli;

--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: chrisdascoli
--

CREATE SEQUENCE messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE messages_id_seq OWNER TO chrisdascoli;

--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrisdascoli
--

ALTER SEQUENCE messages_id_seq OWNED BY messages.id;


--
-- Name: pcmembers; Type: TABLE; Schema: public; Owner: chrisdascoli
--

CREATE TABLE pcmembers (
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    channel_id integer NOT NULL
);


ALTER TABLE pcmembers OWNER TO chrisdascoli;

--
-- Name: teams; Type: TABLE; Schema: public; Owner: chrisdascoli
--

CREATE TABLE teams (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE teams OWNER TO chrisdascoli;

--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: chrisdascoli
--

CREATE SEQUENCE teams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE teams_id_seq OWNER TO chrisdascoli;

--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrisdascoli
--

ALTER SEQUENCE teams_id_seq OWNED BY teams.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: chrisdascoli
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(255),
    email character varying(255),
    password character varying(255),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE users OWNER TO chrisdascoli;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: chrisdascoli
--

CREATE SEQUENCE users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO chrisdascoli;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chrisdascoli
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: channels id; Type: DEFAULT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY channels ALTER COLUMN id SET DEFAULT nextval('channels_id_seq'::regclass);


--
-- Name: direct_messages id; Type: DEFAULT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY direct_messages ALTER COLUMN id SET DEFAULT nextval('direct_messages_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY teams ALTER COLUMN id SET DEFAULT nextval('teams_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: channel_member; Type: TABLE DATA; Schema: public; Owner: chrisdascoli
--

COPY channel_member (created_at, updated_at, channel_id, user_id) FROM stdin;
\.


--
-- Data for Name: channels; Type: TABLE DATA; Schema: public; Owner: chrisdascoli
--

COPY channels (id, name, public, dm, created_at, updated_at, team_id) FROM stdin;
1	general	t	f	2018-03-12 11:35:36.468-04	2018-03-12 11:35:36.468-04	1
2	hello	f	t	2018-03-12 12:19:12.176-04	2018-03-12 12:19:12.176-04	1
3	yeeezy	t	f	2018-03-12 13:11:05.993-04	2018-03-12 13:11:05.993-04	1
4	hello	f	t	2018-03-12 13:11:24.875-04	2018-03-12 13:11:24.875-04	1
5	general	t	f	2018-03-12 13:12:37.862-04	2018-03-12 13:12:37.862-04	2
6	private	f	f	2018-03-12 15:20:08.304-04	2018-03-12 15:20:08.304-04	1
7	general	t	f	2018-03-12 17:50:14.88-04	2018-03-12 17:50:14.88-04	3
8	uline	f	t	2018-03-14 10:23:24.287-04	2018-03-14 10:23:24.287-04	1
9	mac, eggie, uline	f	t	2018-03-14 10:23:44.576-04	2018-03-14 10:23:44.576-04	1
10	mac, uline	f	t	2018-03-14 11:13:53.581-04	2018-03-14 11:13:53.581-04	1
11	eggie, uline	f	t	2018-03-14 11:36:36.06-04	2018-03-14 11:36:36.06-04	1
12	coffee	f	t	2018-03-14 11:40:58.879-04	2018-03-14 11:40:58.879-04	1
13	uline, coffee	f	t	2018-03-14 11:42:11.306-04	2018-03-14 11:42:11.306-04	1
14	eggie, coffee	f	t	2018-03-14 11:43:57.881-04	2018-03-14 11:43:57.881-04	1
15	arkell	f	t	2018-03-14 11:59:43.652-04	2018-03-14 11:59:43.652-04	1
16	coffee, arkell	f	t	2018-03-14 12:03:09.524-04	2018-03-14 12:03:09.524-04	1
17	mac, arkell	f	t	2018-03-14 12:09:49.395-04	2018-03-14 12:09:49.395-04	1
18	eggie, arkell	f	t	2018-03-14 12:11:30.633-04	2018-03-14 12:11:30.633-04	1
19	uline, arkell	f	t	2018-03-14 12:15:14.671-04	2018-03-14 12:15:14.671-04	1
20	yeaa	f	f	2018-03-14 12:16:53.701-04	2018-03-14 12:16:53.701-04	1
21	chec	f	f	2018-03-14 12:18:50.615-04	2018-03-14 12:18:50.615-04	1
22	cxvfvdfg	t	f	2018-03-14 12:26:30.45-04	2018-03-14 12:26:30.45-04	1
23	mac	f	t	2018-03-14 12:57:54.7-04	2018-03-14 12:57:54.7-04	1
24	mac, eggie, uline, coffee, arkell	f	t	2018-03-14 13:00:23.785-04	2018-03-14 13:00:23.785-04	1
25	ghjghjfghj	t	f	2018-03-14 13:00:33.831-04	2018-03-14 13:00:33.831-04	1
26	rtrtyfghfgh	t	f	2018-03-14 13:19:27.274-04	2018-03-14 13:19:27.274-04	1
27	jkhjklkj;	t	f	2018-03-14 13:30:07.431-04	2018-03-14 13:30:07.431-04	1
28	cdaz5, uline, coffee	f	t	2018-03-14 13:32:37.016-04	2018-03-14 13:32:37.016-04	1
29	general	t	f	2018-03-14 13:33:29.908-04	2018-03-14 13:33:29.908-04	4
30	fghfgh	t	f	2018-03-14 13:33:34.162-04	2018-03-14 13:33:34.162-04	4
31	gdh	t	f	2018-03-14 13:38:52.979-04	2018-03-14 13:38:52.979-04	4
32	fghfgh	t	f	2018-03-14 13:42:04.161-04	2018-03-14 13:42:04.161-04	4
33	cdaz5	f	t	2018-03-14 13:43:44.861-04	2018-03-14 13:43:44.861-04	4
34	coffee	f	t	2018-03-14 13:46:35.304-04	2018-03-14 13:46:35.304-04	4
35	fghfgh	t	f	2018-03-14 13:55:22.221-04	2018-03-14 13:55:22.221-04	4
36	jghj	t	f	2018-03-14 13:57:41.747-04	2018-03-14 13:57:41.747-04	4
37	fghjghfj	t	f	2018-03-14 14:00:06.52-04	2018-03-14 14:00:06.52-04	4
38	fghfgh	t	f	2018-03-14 14:00:31.37-04	2018-03-14 14:00:31.37-04	4
39	ghj	t	f	2018-03-14 14:12:12.171-04	2018-03-14 14:12:12.171-04	1
40	gfhfg	t	f	2018-03-14 14:13:37.39-04	2018-03-14 14:13:37.39-04	1
41	fghknjhgm	f	f	2018-03-14 15:38:02.83-04	2018-03-14 15:38:02.83-04	4
42	jk,jkifgb	t	f	2018-03-14 15:42:39.862-04	2018-03-14 15:42:39.862-04	4
43	sfgfgtttttt	t	f	2018-03-14 15:47:04.071-04	2018-03-14 15:47:04.071-04	4
44	rghgfn	t	f	2018-03-14 15:53:32.883-04	2018-03-14 15:53:32.883-04	4
45	ikiiololo	t	f	2018-03-14 16:05:26.433-04	2018-03-14 16:05:26.433-04	4
46	sdfsdf	t	f	2018-03-14 18:41:51.172-04	2018-03-14 18:41:51.172-04	4
47	hello	f	t	2018-03-14 18:42:34.077-04	2018-03-14 18:42:34.077-04	1
48	sdfsdf	f	f	2018-03-14 18:42:46.806-04	2018-03-14 18:42:46.806-04	1
49	jhjk	t	f	2018-03-14 18:47:03.735-04	2018-03-14 18:47:03.735-04	1
50	general	t	f	2018-03-14 18:52:23.777-04	2018-03-14 18:52:23.777-04	5
51	sdf	t	f	2018-03-14 18:52:28.258-04	2018-03-14 18:52:28.258-04	5
52	sdfsdf	t	f	2018-03-14 18:54:29.186-04	2018-03-14 18:54:29.186-04	5
53	kljn	t	f	2018-03-14 18:58:17.709-04	2018-03-14 18:58:17.709-04	5
54	rbrgbfgb	t	f	2018-03-14 19:03:34.234-04	2018-03-14 19:03:34.234-04	5
55	working?	t	f	2018-03-14 19:07:22.658-04	2018-03-14 19:07:22.658-04	5
56	Again	t	f	2018-03-14 19:12:45.593-04	2018-03-14 19:12:45.593-04	5
57	Work pLease	t	f	2018-03-14 19:16:02.684-04	2018-03-14 19:16:02.684-04	1
58	just the two of us	f	f	2018-03-14 19:17:21.834-04	2018-03-14 19:17:21.834-04	1
59	hello	f	t	2018-03-14 19:18:56.634-04	2018-03-14 19:18:56.634-04	1
60	arkell, nobody	f	t	2018-03-15 09:39:27.835-04	2018-03-15 09:39:27.835-04	1
\.


--
-- Data for Name: direct_messages; Type: TABLE DATA; Schema: public; Owner: chrisdascoli
--

COPY direct_messages (id, text, created_at, updated_at, team_id, sender_id, receiver_id) FROM stdin;
\.


--
-- Data for Name: member; Type: TABLE DATA; Schema: public; Owner: chrisdascoli
--

COPY member (created_at, updated_at, user_id, team_id) FROM stdin;
\.


--
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: chrisdascoli
--

COPY members (admin, created_at, updated_at, user_id, team_id) FROM stdin;
t	2018-03-12 11:35:36.473-04	2018-03-12 11:35:36.473-04	1	1
f	2018-03-12 11:37:23.457-04	2018-03-12 11:37:23.457-04	3	1
f	2018-03-12 11:37:27.577-04	2018-03-12 11:37:27.577-04	2	1
t	2018-03-12 13:12:37.865-04	2018-03-12 13:12:37.865-04	1	2
t	2018-03-12 17:50:14.889-04	2018-03-12 17:50:14.889-04	1	3
f	2018-03-14 10:22:38.611-04	2018-03-14 10:22:38.611-04	4	1
f	2018-03-14 11:40:00.343-04	2018-03-14 11:40:00.343-04	5	1
f	2018-03-14 11:58:51.229-04	2018-03-14 11:58:51.229-04	6	1
t	2018-03-14 13:33:29.911-04	2018-03-14 13:33:29.911-04	3	4
f	2018-03-14 13:43:29.382-04	2018-03-14 13:43:29.382-04	1	4
f	2018-03-14 13:43:34.669-04	2018-03-14 13:43:34.669-04	5	4
f	2018-03-14 15:37:28.773-04	2018-03-14 15:37:28.773-04	2	4
f	2018-03-14 15:37:42.881-04	2018-03-14 15:37:42.881-04	4	4
t	2018-03-14 18:52:23.782-04	2018-03-14 18:52:23.782-04	7	5
f	2018-03-14 19:17:02.802-04	2018-03-14 19:17:02.802-04	7	1
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: chrisdascoli
--

COPY messages (id, text, created_at, updated_at, channel_id, user_id) FROM stdin;
1	check it out now	2018-03-12 15:00:26.825-04	2018-03-12 15:00:26.825-04	1	1
2	the funk sole brother	2018-03-12 15:00:38.255-04	2018-03-12 15:00:38.255-04	1	1
3	https://media.giphy.com/media/3ov9jPWJMrfnd6IoBa/giphy.gif	2018-03-13 17:52:52.289-04	2018-03-13 17:52:52.289-04	4	1
4	https://gph.is/2yqYh03	2018-03-13 17:52:59.251-04	2018-03-13 17:52:59.251-04	4	1
5	https://media.giphy.com/media/3ov9jPWJMrfnd6IoBa/giphy.gif	2018-03-13 17:54:01.133-04	2018-03-13 17:54:01.133-04	3	1
6	https://gph.is/2yqYh03	2018-03-13 17:55:14.569-04	2018-03-13 17:55:14.569-04	3	1
7	http://gph.is/2yqYh03.gif	2018-03-13 18:06:30.677-04	2018-03-13 18:06:30.677-04	3	1
8	https://media.giphy.com/media/3ov9jPWJMrfnd6IoBa/giphy.gif	2018-03-13 18:14:28.913-04	2018-03-13 18:14:28.913-04	3	1
9	https://media.giphy.com/media/l4FGARRiQgxpgDpba/giphy.gif	2018-03-13 18:21:48.7-04	2018-03-13 18:21:48.7-04	3	1
10	https://gph.is/2tiRYoq	2018-03-13 18:21:59.21-04	2018-03-13 18:21:59.21-04	3	1
11	https://media.giphy.com/media/l4FGARRiQgxpgDpba/giphy.gif	2018-03-13 18:23:54.374-04	2018-03-13 18:23:54.374-04	3	1
12	hi	2018-03-14 12:56:37.074-04	2018-03-14 12:56:37.074-04	1	1
13	heyo	2018-03-14 12:56:45.62-04	2018-03-14 12:56:45.62-04	1	3
14	yo	2018-03-14 12:57:18.097-04	2018-03-14 12:57:18.097-04	11	1
15	jkl	2018-03-14 12:57:20.768-04	2018-03-14 12:57:20.768-04	11	3
16	j;l	2018-03-14 12:57:37.776-04	2018-03-14 12:57:37.776-04	6	1
17	hjkl	2018-03-14 12:57:40.138-04	2018-03-14 12:57:40.138-04	6	3
18	dfghdgfh	2018-03-20 12:00:33.799-04	2018-03-20 12:00:33.799-04	3	1
19	dfghdfgh	2018-03-20 12:00:34.448-04	2018-03-20 12:00:34.448-04	3	1
20	dfghfdgh	2018-03-20 12:00:35.033-04	2018-03-20 12:00:35.033-04	3	1
21	fdghdg	2018-03-20 12:00:35.397-04	2018-03-20 12:00:35.397-04	3	1
22	hd	2018-03-20 12:00:35.595-04	2018-03-20 12:00:35.595-04	3	1
23	h	2018-03-20 12:00:35.775-04	2018-03-20 12:00:35.775-04	3	1
24	gfh	2018-03-20 12:00:35.933-04	2018-03-20 12:00:35.933-04	3	1
25	fdg	2018-03-20 12:00:36.145-04	2018-03-20 12:00:36.145-04	3	1
26	h	2018-03-20 12:00:36.317-04	2018-03-20 12:00:36.317-04	3	1
27	dfghdf	2018-03-20 12:00:36.602-04	2018-03-20 12:00:36.602-04	3	1
28	gh	2018-03-20 12:00:36.793-04	2018-03-20 12:00:36.793-04	3	1
29	dfghdfgh	2018-03-20 12:00:37.259-04	2018-03-20 12:00:37.259-04	3	1
30	fdgh	2018-03-20 12:00:37.464-04	2018-03-20 12:00:37.464-04	3	1
31	df	2018-03-20 12:00:37.643-04	2018-03-20 12:00:37.643-04	3	1
32	h	2018-03-20 12:00:37.821-04	2018-03-20 12:00:37.821-04	3	1
33	fdgh	2018-03-20 12:00:38.048-04	2018-03-20 12:00:38.048-04	3	1
34	fdgh	2018-03-20 12:00:38.363-04	2018-03-20 12:00:38.363-04	3	1
35	fgdh	2018-03-20 12:00:38.594-04	2018-03-20 12:00:38.594-04	3	1
36	ghhg	2018-03-20 12:00:38.815-04	2018-03-20 12:00:38.815-04	3	1
37	jgj	2018-03-20 12:00:39.059-04	2018-03-20 12:00:39.059-04	3	1
38	u	2018-03-20 12:00:39.306-04	2018-03-20 12:00:39.306-04	3	1
39	m	2018-03-20 12:00:39.474-04	2018-03-20 12:00:39.474-04	3	1
40	hgj	2018-03-20 12:00:39.655-04	2018-03-20 12:00:39.655-04	3	1
41	m	2018-03-20 12:00:39.849-04	2018-03-20 12:00:39.849-04	3	1
42	gf	2018-03-20 12:00:39.984-04	2018-03-20 12:00:39.984-04	3	1
43	mgfhm	2018-03-20 12:00:40.347-04	2018-03-20 12:00:40.347-04	3	1
44	hgf	2018-03-20 12:00:40.553-04	2018-03-20 12:00:40.553-04	3	1
45	m	2018-03-20 12:00:40.701-04	2018-03-20 12:00:40.701-04	3	1
46	hgm	2018-03-20 12:00:40.885-04	2018-03-20 12:00:40.885-04	3	1
47	f	2018-03-20 12:00:41.064-04	2018-03-20 12:00:41.064-04	3	1
48	hm	2018-03-20 12:00:41.22-04	2018-03-20 12:00:41.22-04	3	1
49	gfh	2018-03-20 12:00:41.38-04	2018-03-20 12:00:41.38-04	3	1
50	m	2018-03-20 12:00:41.558-04	2018-03-20 12:00:41.558-04	3	1
51	gfhm	2018-03-20 12:00:41.759-04	2018-03-20 12:00:41.759-04	3	1
52	g	2018-03-20 12:00:41.899-04	2018-03-20 12:00:41.899-04	3	1
53	m	2018-03-20 12:00:42.076-04	2018-03-20 12:00:42.076-04	3	1
54	hgf	2018-03-20 12:00:42.254-04	2018-03-20 12:00:42.254-04	3	1
55	m	2018-03-20 12:00:42.388-04	2018-03-20 12:00:42.388-04	3	1
56	hgfm	2018-03-20 12:00:42.596-04	2018-03-20 12:00:42.596-04	3	1
57	ghf	2018-03-20 12:00:42.779-04	2018-03-20 12:00:42.779-04	3	1
58	m	2018-03-20 12:00:42.929-04	2018-03-20 12:00:42.929-04	3	1
59	gf	2018-03-20 12:00:43.11-04	2018-03-20 12:00:43.11-04	3	1
60	m	2018-03-20 12:00:43.262-04	2018-03-20 12:00:43.262-04	3	1
61	gfhm	2018-03-20 12:00:43.455-04	2018-03-20 12:00:43.455-04	3	1
62	ghf	2018-03-20 12:00:43.656-04	2018-03-20 12:00:43.656-04	3	1
63	hgfm	2018-03-20 12:00:44.053-04	2018-03-20 12:00:44.053-04	3	1
64	fgm	2018-03-20 12:00:44.233-04	2018-03-20 12:00:44.233-04	3	1
65	hgf	2018-03-20 12:00:44.404-04	2018-03-20 12:00:44.404-04	3	1
66	m	2018-03-20 12:00:44.594-04	2018-03-20 12:00:44.594-04	3	1
67	hfgm	2018-03-20 12:00:44.819-04	2018-03-20 12:00:44.819-04	3	1
68	fg	2018-03-20 12:00:44.999-04	2018-03-20 12:00:44.999-04	3	1
69	fghm	2018-03-20 12:00:45.384-04	2018-03-20 12:00:45.384-04	3	1
70	hg	2018-03-20 12:00:45.534-04	2018-03-20 12:00:45.534-04	3	1
71	fm	2018-03-20 12:00:45.718-04	2018-03-20 12:00:45.718-04	3	1
72	gfh	2018-03-20 12:00:45.909-04	2018-03-20 12:00:45.909-04	3	1
73	m	2018-03-20 12:00:46.101-04	2018-03-20 12:00:46.101-04	3	1
74	gfhm	2018-03-20 12:00:46.31-04	2018-03-20 12:00:46.31-04	3	1
75	gh	2018-03-20 12:00:46.486-04	2018-03-20 12:00:46.486-04	3	1
76	m	2018-03-20 12:00:46.664-04	2018-03-20 12:00:46.664-04	3	1
77	ghf	2018-03-20 12:00:46.83-04	2018-03-20 12:00:46.83-04	3	1
78	ghf	2018-03-20 12:00:47.038-04	2018-03-20 12:00:47.038-04	3	1
79	m	2018-03-20 12:00:47.209-04	2018-03-20 12:00:47.209-04	3	1
80	gfhm	2018-03-20 12:00:47.366-04	2018-03-20 12:00:47.366-04	3	1
81	gh	2018-03-20 12:00:47.594-04	2018-03-20 12:00:47.594-04	3	1
82	m	2018-03-20 12:00:47.744-04	2018-03-20 12:00:47.744-04	3	1
83	ghfm	2018-03-20 12:00:48.064-04	2018-03-20 12:00:48.064-04	3	1
84	sdgdg	2018-03-20 12:00:48.657-04	2018-03-20 12:00:48.657-04	3	1
85	rsdg	2018-03-20 12:00:49.037-04	2018-03-20 12:00:49.037-04	3	1
86	dth	2018-03-20 12:00:49.382-04	2018-03-20 12:00:49.382-04	3	1
87	f	2018-03-20 12:00:49.55-04	2018-03-20 12:00:49.55-04	3	1
88	dj	2018-03-20 12:00:49.769-04	2018-03-20 12:00:49.769-04	3	1
89	hgf	2018-03-20 12:00:49.993-04	2018-03-20 12:00:49.993-04	3	1
90	m	2018-03-20 12:00:50.173-04	2018-03-20 12:00:50.173-04	3	1
91	jfg	2018-03-20 12:00:50.384-04	2018-03-20 12:00:50.384-04	3	1
92	jm	2018-03-20 12:00:50.601-04	2018-03-20 12:00:50.601-04	3	1
93	hgj	2018-03-20 12:00:50.772-04	2018-03-20 12:00:50.772-04	3	1
94	m	2018-03-20 12:00:50.968-04	2018-03-20 12:00:50.968-04	3	1
95	srdgtrh	2018-03-20 12:00:51.661-04	2018-03-20 12:00:51.661-04	3	1
96	ty	2018-03-20 12:00:51.844-04	2018-03-20 12:00:51.844-04	3	1
97	fj	2018-03-20 12:00:52.019-04	2018-03-20 12:00:52.019-04	3	1
98	mg	2018-03-20 12:00:52.401-04	2018-03-20 12:00:52.401-04	3	1
99	ghj	2018-03-20 12:00:52.605-04	2018-03-20 12:00:52.605-04	3	1
100	m	2018-03-20 12:00:52.763-04	2018-03-20 12:00:52.763-04	3	1
101	yg	2018-03-20 12:00:52.918-04	2018-03-20 12:00:52.918-04	3	1
102	n	2018-03-20 12:00:53.15-04	2018-03-20 12:00:53.15-04	3	1
103	y	2018-03-20 12:00:53.324-04	2018-03-20 12:00:53.324-04	3	1
104	hn	2018-03-20 12:00:53.531-04	2018-03-20 12:00:53.531-04	3	1
105	gh	2018-03-20 12:00:53.705-04	2018-03-20 12:00:53.705-04	3	1
106	n	2018-03-20 12:00:53.909-04	2018-03-20 12:00:53.909-04	3	1
107	f	2018-03-20 12:00:54.067-04	2018-03-20 12:00:54.067-04	3	1
108	y	2018-03-20 12:00:54.273-04	2018-03-20 12:00:54.273-04	3	1
109	d	2018-03-20 12:00:54.673-04	2018-03-20 12:00:54.673-04	3	1
110	ty	2018-03-20 12:00:54.876-04	2018-03-20 12:00:54.876-04	3	1
111	a	2018-03-20 12:00:55.062-04	2018-03-20 12:00:55.062-04	3	1
112	rst	2018-03-20 12:00:55.259-04	2018-03-20 12:00:55.259-04	3	1
113	yhj	2018-03-20 12:00:55.686-04	2018-03-20 12:00:55.686-04	3	1
114	yjfdyj	2018-03-20 12:00:56.303-04	2018-03-20 12:00:56.303-04	3	1
115	tfb	2018-03-20 12:00:56.563-04	2018-03-20 12:00:56.563-04	3	1
116	fy	2018-03-20 12:00:56.926-04	2018-03-20 12:00:56.926-04	3	1
117	n	2018-03-20 12:00:57.177-04	2018-03-20 12:00:57.177-04	3	1
118	ft	2018-03-20 12:00:57.425-04	2018-03-20 12:00:57.425-04	3	1
119	tg	2018-03-20 12:00:57.611-04	2018-03-20 12:00:57.611-04	3	1
120	ndf	2018-03-20 12:00:57.826-04	2018-03-20 12:00:57.826-04	3	1
121	f	2018-03-20 12:00:57.988-04	2018-03-20 12:00:57.988-04	3	1
122	b	2018-03-20 12:00:58.387-04	2018-03-20 12:00:58.387-04	3	1
123	sdfsdf	2018-03-20 12:10:17.03-04	2018-03-20 12:10:17.03-04	3	1
124	ghj	2018-03-20 17:02:48.597-04	2018-03-20 17:02:48.597-04	1	1
125	sdfsdf	2018-03-20 17:09:05.949-04	2018-03-20 17:09:05.949-04	1	1
126	ghj	2018-03-20 17:10:00.848-04	2018-03-20 17:10:00.848-04	1	4
\.


--
-- Data for Name: pcmembers; Type: TABLE DATA; Schema: public; Owner: chrisdascoli
--

COPY pcmembers (created_at, updated_at, user_id, channel_id) FROM stdin;
2018-03-12 12:19:12.187-04	2018-03-12 12:19:12.187-04	3	2
2018-03-12 12:19:12.187-04	2018-03-12 12:19:12.187-04	1	2
2018-03-12 13:11:24.879-04	2018-03-12 13:11:24.879-04	2	4
2018-03-12 13:11:24.879-04	2018-03-12 13:11:24.879-04	1	4
2018-03-12 15:20:08.334-04	2018-03-12 15:20:08.334-04	3	6
2018-03-12 15:20:08.334-04	2018-03-12 15:20:08.334-04	1	6
2018-03-14 10:23:24.294-04	2018-03-14 10:23:24.294-04	4	8
2018-03-14 10:23:24.294-04	2018-03-14 10:23:24.294-04	1	8
2018-03-14 10:23:44.579-04	2018-03-14 10:23:44.579-04	3	9
2018-03-14 10:23:44.579-04	2018-03-14 10:23:44.579-04	2	9
2018-03-14 10:23:44.579-04	2018-03-14 10:23:44.579-04	4	9
2018-03-14 10:23:44.579-04	2018-03-14 10:23:44.579-04	1	9
2018-03-14 11:13:53.584-04	2018-03-14 11:13:53.584-04	4	10
2018-03-14 11:13:53.584-04	2018-03-14 11:13:53.584-04	2	10
2018-03-14 11:13:53.584-04	2018-03-14 11:13:53.584-04	1	10
2018-03-14 11:36:36.079-04	2018-03-14 11:36:36.079-04	3	11
2018-03-14 11:36:36.079-04	2018-03-14 11:36:36.079-04	4	11
2018-03-14 11:36:36.079-04	2018-03-14 11:36:36.079-04	1	11
2018-03-14 11:40:58.882-04	2018-03-14 11:40:58.882-04	5	12
2018-03-14 11:40:58.882-04	2018-03-14 11:40:58.882-04	1	12
2018-03-14 11:42:11.309-04	2018-03-14 11:42:11.309-04	5	13
2018-03-14 11:42:11.309-04	2018-03-14 11:42:11.309-04	4	13
2018-03-14 11:42:11.309-04	2018-03-14 11:42:11.309-04	1	13
2018-03-14 11:43:57.884-04	2018-03-14 11:43:57.884-04	5	14
2018-03-14 11:43:57.884-04	2018-03-14 11:43:57.884-04	3	14
2018-03-14 11:43:57.884-04	2018-03-14 11:43:57.884-04	1	14
2018-03-14 11:59:43.657-04	2018-03-14 11:59:43.657-04	6	15
2018-03-14 11:59:43.657-04	2018-03-14 11:59:43.657-04	1	15
2018-03-14 12:03:09.526-04	2018-03-14 12:03:09.526-04	6	16
2018-03-14 12:03:09.526-04	2018-03-14 12:03:09.526-04	5	16
2018-03-14 12:03:09.526-04	2018-03-14 12:03:09.526-04	1	16
2018-03-14 12:09:49.398-04	2018-03-14 12:09:49.398-04	6	17
2018-03-14 12:09:49.398-04	2018-03-14 12:09:49.398-04	2	17
2018-03-14 12:09:49.398-04	2018-03-14 12:09:49.398-04	1	17
2018-03-14 12:11:30.637-04	2018-03-14 12:11:30.637-04	6	18
2018-03-14 12:11:30.637-04	2018-03-14 12:11:30.637-04	3	18
2018-03-14 12:11:30.637-04	2018-03-14 12:11:30.637-04	1	18
2018-03-14 12:15:14.674-04	2018-03-14 12:15:14.674-04	6	19
2018-03-14 12:15:14.674-04	2018-03-14 12:15:14.674-04	4	19
2018-03-14 12:15:14.674-04	2018-03-14 12:15:14.674-04	1	19
2018-03-14 12:16:53.716-04	2018-03-14 12:16:53.716-04	2	20
2018-03-14 12:16:53.716-04	2018-03-14 12:16:53.716-04	5	20
2018-03-14 12:16:53.716-04	2018-03-14 12:16:53.716-04	1	20
2018-03-14 12:18:50.642-04	2018-03-14 12:18:50.642-04	2	21
2018-03-14 12:18:50.642-04	2018-03-14 12:18:50.642-04	5	21
2018-03-14 12:18:50.642-04	2018-03-14 12:18:50.642-04	4	21
2018-03-14 12:18:50.642-04	2018-03-14 12:18:50.642-04	1	21
2018-03-14 12:57:54.703-04	2018-03-14 12:57:54.703-04	2	23
2018-03-14 12:57:54.703-04	2018-03-14 12:57:54.703-04	3	23
2018-03-14 13:00:23.789-04	2018-03-14 13:00:23.789-04	6	24
2018-03-14 13:00:23.789-04	2018-03-14 13:00:23.789-04	5	24
2018-03-14 13:00:23.789-04	2018-03-14 13:00:23.789-04	4	24
2018-03-14 13:00:23.789-04	2018-03-14 13:00:23.789-04	2	24
2018-03-14 13:00:23.789-04	2018-03-14 13:00:23.789-04	3	24
2018-03-14 13:00:23.789-04	2018-03-14 13:00:23.789-04	1	24
2018-03-14 13:32:37.02-04	2018-03-14 13:32:37.02-04	1	28
2018-03-14 13:32:37.02-04	2018-03-14 13:32:37.02-04	4	28
2018-03-14 13:32:37.02-04	2018-03-14 13:32:37.02-04	5	28
2018-03-14 13:32:37.02-04	2018-03-14 13:32:37.02-04	3	28
2018-03-14 13:43:44.864-04	2018-03-14 13:43:44.864-04	1	33
2018-03-14 13:43:44.864-04	2018-03-14 13:43:44.864-04	3	33
2018-03-14 13:46:35.307-04	2018-03-14 13:46:35.307-04	5	34
2018-03-14 13:46:35.307-04	2018-03-14 13:46:35.307-04	3	34
2018-03-14 15:38:02.842-04	2018-03-14 15:38:02.842-04	1	41
2018-03-14 15:38:02.842-04	2018-03-14 15:38:02.842-04	3	41
2018-03-14 18:42:34.081-04	2018-03-14 18:42:34.081-04	2	47
2018-03-14 18:42:34.081-04	2018-03-14 18:42:34.081-04	5	47
2018-03-14 18:42:34.081-04	2018-03-14 18:42:34.081-04	4	47
2018-03-14 18:42:34.081-04	2018-03-14 18:42:34.081-04	1	47
2018-03-14 18:42:46.811-04	2018-03-14 18:42:46.811-04	4	48
2018-03-14 18:42:46.811-04	2018-03-14 18:42:46.811-04	6	48
2018-03-14 18:42:46.811-04	2018-03-14 18:42:46.811-04	1	48
2018-03-14 19:17:21.839-04	2018-03-14 19:17:21.839-04	5	58
2018-03-14 19:17:21.839-04	2018-03-14 19:17:21.839-04	6	58
2018-03-14 19:17:21.839-04	2018-03-14 19:17:21.839-04	1	58
2018-03-14 19:18:56.638-04	2018-03-14 19:18:56.638-04	7	59
2018-03-14 19:18:56.638-04	2018-03-14 19:18:56.638-04	1	59
2018-03-15 09:39:27.852-04	2018-03-15 09:39:27.852-04	7	60
2018-03-15 09:39:27.852-04	2018-03-15 09:39:27.852-04	6	60
2018-03-15 09:39:27.852-04	2018-03-15 09:39:27.852-04	3	60
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: chrisdascoli
--

COPY teams (id, name, created_at, updated_at) FROM stdin;
1	crazytown	2018-03-12 11:35:36.463-04	2018-03-12 11:35:36.463-04
2	tape	2018-03-12 13:12:37.858-04	2018-03-12 13:12:37.858-04
3	mac is the shit	2018-03-12 17:50:14.864-04	2018-03-12 17:50:14.864-04
4	fghjfghj	2018-03-14 13:33:29.904-04	2018-03-14 13:33:29.904-04
5	Wayo	2018-03-14 18:52:23.77-04	2018-03-14 18:52:23.77-04
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: chrisdascoli
--

COPY users (id, username, email, password, created_at, updated_at) FROM stdin;
1	cdaz5	cdaz5@gmail.com	$2a$15$ipglZGcV0SNbBXa.z9jBQODd5wm6hHKlrcbIZAuyMmI0w2VqLhBEu	2018-03-12 11:34:47.984-04	2018-03-12 11:34:47.984-04
2	mac	mac@gmail.com	$2a$15$yhvYKOtzogU0RPSsCyAPreA3.lGLKIydcuhNOq9.OaTUbo2WWOhmO	2018-03-12 11:35:05.689-04	2018-03-12 11:35:05.689-04
3	eggie	eggie@gmail.com	$2a$15$laaDtJqKLlO./nhTeu43Lekt.BPz1glS82upM8aO9jUPL6kr58Xv.	2018-03-12 11:36:26.209-04	2018-03-12 11:36:26.209-04
4	uline	uline@gmail.com	$2a$15$mIndP72TD64oYzjR8iJtF.Ym8sM2GW/1aky/LI0YfIcqFhoLPIRRi	2018-03-14 10:22:25.548-04	2018-03-14 10:22:25.548-04
5	coffee	coffee@gmail.com	$2a$15$HP6jUMmtLUumSn3/pNr0iewRdZPpgi1CbCm8EQSooSmo7cAf6XSDe	2018-03-14 11:39:36.498-04	2018-03-14 11:39:36.498-04
6	arkell	arkell@gmail.com	$2a$15$fDZ5lxkBxnmNIjIBnemtmu2/sqdarxleJ.laQKUdtwRR6vaBYgcBi	2018-03-14 11:58:19.808-04	2018-03-14 11:58:19.808-04
7	nobody	nobody@gmail.com	$2a$15$hFJDBj.HXEJriRPwC3YkYeE22AWvX3eYGyLPGNkfFaKv4S5GexxBG	2018-03-14 18:52:02.166-04	2018-03-14 18:52:02.166-04
\.


--
-- Name: channels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chrisdascoli
--

SELECT pg_catalog.setval('channels_id_seq', 60, true);


--
-- Name: direct_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chrisdascoli
--

SELECT pg_catalog.setval('direct_messages_id_seq', 1, false);


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chrisdascoli
--

SELECT pg_catalog.setval('messages_id_seq', 126, true);


--
-- Name: teams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chrisdascoli
--

SELECT pg_catalog.setval('teams_id_seq', 5, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chrisdascoli
--

SELECT pg_catalog.setval('users_id_seq', 7, true);


--
-- Name: channel_member channel_member_pkey; Type: CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY channel_member
    ADD CONSTRAINT channel_member_pkey PRIMARY KEY (channel_id, user_id);


--
-- Name: channels channels_pkey; Type: CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY channels
    ADD CONSTRAINT channels_pkey PRIMARY KEY (id);


--
-- Name: direct_messages direct_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY direct_messages
    ADD CONSTRAINT direct_messages_pkey PRIMARY KEY (id);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY member
    ADD CONSTRAINT member_pkey PRIMARY KEY (user_id, team_id);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY members
    ADD CONSTRAINT members_pkey PRIMARY KEY (user_id, team_id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: pcmembers pcmembers_pkey; Type: CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY pcmembers
    ADD CONSTRAINT pcmembers_pkey PRIMARY KEY (user_id, channel_id);


--
-- Name: teams teams_name_key; Type: CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_name_key UNIQUE (name);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: messages_created_at; Type: INDEX; Schema: public; Owner: chrisdascoli
--

CREATE INDEX messages_created_at ON messages USING btree (created_at);


--
-- Name: channel_member channel_member_channel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY channel_member
    ADD CONSTRAINT channel_member_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES channels(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: channel_member channel_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY channel_member
    ADD CONSTRAINT channel_member_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: channels channels_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY channels
    ADD CONSTRAINT channels_team_id_fkey FOREIGN KEY (team_id) REFERENCES teams(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: direct_messages direct_messages_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY direct_messages
    ADD CONSTRAINT direct_messages_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: direct_messages direct_messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY direct_messages
    ADD CONSTRAINT direct_messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: direct_messages direct_messages_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY direct_messages
    ADD CONSTRAINT direct_messages_team_id_fkey FOREIGN KEY (team_id) REFERENCES teams(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: members members_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY members
    ADD CONSTRAINT members_team_id_fkey FOREIGN KEY (team_id) REFERENCES teams(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: members members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY members
    ADD CONSTRAINT members_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: messages messages_channel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES channels(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: messages messages_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pcmembers pcmembers_channel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY pcmembers
    ADD CONSTRAINT pcmembers_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES channels(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pcmembers pcmembers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chrisdascoli
--

ALTER TABLE ONLY pcmembers
    ADD CONSTRAINT pcmembers_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

