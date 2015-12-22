--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
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


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: changeset_comments; Type: TABLE; Schema: public; Owner: sanjaybhangar; Tablespace: 
--

CREATE TABLE IF NOT EXISTS changeset_comments (
    id uuid NOT NULL,
    changeset_id integer,
    user_id integer,
    "timestamp" timestamp with time zone,
    comment text
);


ALTER TABLE changeset_comments OWNER TO sanjaybhangar;

--
-- Name: changeset_tags; Type: TABLE; Schema: public; Owner: sanjaybhangar; Tablespace: 
--

CREATE TABLE IF NOT EXISTS changeset_tags (
    id uuid NOT NULL,
    changeset_id integer,
    key text,
    value text
);


ALTER TABLE changeset_tags OWNER TO sanjaybhangar;

--
-- Name: changesets; Type: TABLE; Schema: public; Owner: sanjaybhangar; Tablespace: 
--

CREATE TABLE IF NOT EXISTS changesets (
    id integer NOT NULL,
    created_at timestamp with time zone,
    closed_at timestamp with time zone,
    is_open boolean,
    user_id integer,
    min_lon double precision,
    min_lat double precision,
    max_lon double precision,
    max_lat double precision,
    bbox geometry(Polygon,4326),
    num_changes integer,
    discussion_count integer
);


ALTER TABLE changesets OWNER TO sanjaybhangar;

--
-- Name: note_comments; Type: TABLE; Schema: public; Owner: sanjaybhangar; Tablespace: 
--

CREATE TABLE IF NOT EXISTS note_comments (
    id uuid NOT NULL,
    note_id integer,
    action text,
    comment text,
    "timestamp" timestamp with time zone,
    user_id integer
);


ALTER TABLE note_comments OWNER TO sanjaybhangar;

--
-- Name: notes; Type: TABLE; Schema: public; Owner: sanjaybhangar; Tablespace: 
--

CREATE TABLE IF NOT EXISTS notes (
    id integer NOT NULL,
    created_at timestamp with time zone,
    closed_at timestamp with time zone,
    opened_by integer,
    point geometry(Point,4326)
);


ALTER TABLE notes OWNER TO sanjaybhangar;

--
-- Name: users; Type: TABLE; Schema: public; Owner: sanjaybhangar; Tablespace: 
--

CREATE TABLE IF NOT EXISTS users (
    id integer NOT NULL,
    name text
);


ALTER TABLE users OWNER TO sanjaybhangar;

--
-- Data for Name: changeset_comments; Type: TABLE DATA; Schema: public; Owner: sanjaybhangar
--

COPY changeset_comments (id, changeset_id, user_id, "timestamp", comment) FROM stdin;
4d3664db-486d-4271-229e-9dd7e6cde1c5	34721793	207581	2015-10-18 22:48:00+00	Danish addressnodes are maintained by scripts and are actually by law not associated with any specific building. Please do not touch them.
4ec37e85-5e39-f046-86f8-cdce9a0f6fc8	34721793	207581	2015-10-18 22:55:00+00	test
8ff2092c-193d-7f7a-4e1f-36c58f685716	34721794	3099780	2015-11-18 22:49:00+00	Foo
cd7a41cc-f86e-dcd2-e4d4-4c43ba405af4	34721796	3099780	2015-11-18 22:49:05+00	Fun
920e00bb-5cd6-f262-e31b-3692b5619d01	34721797	44660	2015-11-18 22:49:10+00	Test discussion item.
e2ecc6c8-3c32-53b4-cab8-25452492ae3f	34721798	1799626	2015-11-18 22:49:15+00	Test discussion item.
9bffe297-5028-08cf-d499-7a9b72c59546	34721798	44660	2015-11-18 23:49:20+00	Test discussion item.
cf6ff2d1-5fe1-391a-e09e-6170fe1f086a	34721798	44660	2015-11-18 22:55:10+00	Test discussion item.
8bfd8469-4603-b3c4-066f-2894ee410662	34721798	44660	2015-12-18 22:55:20+00	Test discussion item.
\.


--
-- Data for Name: changeset_tags; Type: TABLE DATA; Schema: public; Owner: sanjaybhangar
--

COPY changeset_tags (id, changeset_id, key, value) FROM stdin;
6ff17c98-9aa3-5897-98d9-c65ee723a43d	34721793	source	Bing
9afbad20-498a-905a-bb69-ff9e906d0073	34721793	comment	Fernwärme ergänzt
fdae0294-e970-2bb7-49e2-df529a21029c	34721793	created_by	JOSM/1.5 (8800 de)
9c4578ad-6854-f46a-d648-3ff80fff9ed2	34721794	host	https://www.openstreetmap.org/id
84b89b11-ec20-18ca-0c3b-477ecbb01deb	34721794	locale	es
7547d932-2d50-87a3-14f9-b1100f0794a0	34721794	comment	Biescas
1584fe00-cbfe-8652-d57c-f823d7860b6b	34721794	created_by	iD 1.7.4
b10701b7-c2a0-0b49-b6fd-92bc3341c71e	34721794	imagery_used	Bing
0ec35e6e-9462-096b-6871-3fbc9443f440	34721796	source	survey (10/2015); Hamburg20cm-Karte
532e6289-abb0-8b44-54e0-27fa36cc6b97	34721796	comment	Eisenbahn Hamburg
58d5627e-43f8-2bce-d8f9-0887ee796f84	34721796	created_by	JOSM/1.5 (8800 de)
02a4cda1-66d5-c4f1-d345-1a1f66a019b2	34721797	host	https://www.openstreetmap.org/id
4de53d8a-2278-9a56-e36f-3e95accfc045	34721797	locale	pt-BR
6c738340-92b4-43f5-ec17-a8378339a7ca	34721797	created_by	iD 1.7.4
d913138b-c26f-571e-921c-55763e5a64a0	34721797	imagery_used	Bing
70642287-ea7a-e240-c520-107b583e4e38	34721798	host	https://www.openstreetmap.org/id
e9c2d2ea-55e4-7142-475f-8bba605cf4b7	34721798	locale	en-GB
1e4723e8-59ee-a902-3045-6c716acb1964	34721798	created_by	iD 1.7.4
6519861e-f91e-ff94-c3ea-6eccb7d0a2b4	34721798	imagery_used	Bing
89275a81-9e27-17bc-ee35-d01fead69ea8	34721799	host	https://www.openstreetmap.org/id
f41e3cae-770a-0398-db7b-40052ab0e14b	34721799	locale	ar
1f894d61-2772-c818-e6fa-e00f4dcf0834	34721799	created_by	iD 1.7.4
560903d7-67d7-ec9e-fd67-4be3717ebaaf	34721799	imagery_used	Bing
\.


--
-- Data for Name: changesets; Type: TABLE DATA; Schema: public; Owner: sanjaybhangar
--

COPY changesets (id, created_at, closed_at, is_open, user_id, min_lon, min_lat, max_lon, max_lat, bbox, num_changes, discussion_count) FROM stdin;
34721793	2015-10-18 22:23:15+00	2015-10-18 22:23:16+00	f	344561	\N	\N	\N	\N	0103000020E6100000010000000500000072666089AC7E2440226C787AA5944C4072666089AC7E24408A0BF6155A954C404E113BAEA18324408A0BF6155A954C404E113BAEA1832440226C787AA5944C4072666089AC7E2440226C787AA5944C40	37	2
34721794	2015-10-18 22:23:19+00	2015-10-18 22:23:20+00	f	3188422	\N	\N	\N	\N	0103000020E6100000010000000500000085DE2C6F5864D4BFF669CB6F8750454085DE2C6F5864D4BFE30C0FAB89504540FA02C46EE962D4BFE30C0FAB89504540FA02C46EE962D4BFF669CB6F8750454085DE2C6F5864D4BFF669CB6F87504540	5	1
34721796	2015-10-18 22:23:22+00	2015-10-18 22:23:53+00	f	44660	\N	\N	\N	\N	0103000020E61000000100000005000000D40330AF6D5F24404A0E338F57BE4A40D40330AF6D5F24407496598462C44A4052770A5E99A824407496598462C44A4052770A5E99A824404A0E338F57BE4A40D40330AF6D5F24404A0E338F57BE4A40	5	1
34721797	2015-10-18 22:23:33+00	2015-10-18 22:23:34+00	f	1799626	\N	\N	\N	\N	0103000020E61000000100000005000000930843D3C87447C06517B1F4462037C0930843D3C87447C0AB88E4750E1D37C084B70721207447C0AB88E4750E1D37C084B70721207447C06517B1F4462037C0930843D3C87447C06517B1F4462037C0	6	1
34721798	2015-10-18 22:23:37+00	2015-10-18 22:23:38+00	f	651782	\N	\N	\N	\N	0103000020E61000000100000005000000BCCFF1D1E2FC00C02F1686C8E9934C40BCCFF1D1E2FC00C0B071FDBB3E944C40941FA79EBBF300C0B071FDBB3E944C40941FA79EBBF300C02F1686C8E9934C40BCCFF1D1E2FC00C02F1686C8E9934C40	16	4
34721799	2015-10-18 22:23:41+00	2015-10-18 22:23:42+00	f	3318999	\N	\N	\N	\N	0103000020E610000001000000050000002A1F82AAD11A46406FC44950B2832A402A1F82AAD11A46406FC44950B2832A402A1F82AAD11A46406FC44950B2832A402A1F82AAD11A46406FC44950B2832A402A1F82AAD11A46406FC44950B2832A40	1	1
\.


--
-- Data for Name: note_comments; Type: TABLE DATA; Schema: public; Owner: sanjaybhangar
--

COPY note_comments (id, note_id, action, comment, "timestamp", user_id) FROM stdin;
81369dd8-5fbe-9831-fc97-da833f7302f4	4	opened	test	2013-04-24 08:07:02+00	1626
5b995e4f-b62c-1f6b-6969-da54a07f5fc9	4	closed		2013-04-24 08:08:51+00	1626
6e5108d2-98e3-3e4d-d445-c1ae7f559bce	5	opened	This building has been demolished and is currently a construction site.	2013-04-24 08:10:38+00	3980
f7c83a7a-1359-03d4-80e5-137410f3013c	5	closed		2013-04-24 21:31:47+00	3980
e8ac3fa1-d83e-221f-fc9c-3e760e41e6da	6	opened	Ministopは閉店済み	2013-04-24 08:12:38+00	378532
3fe6e458-9e2c-a2de-2a18-ee02f1d588f7	6	closed	name corrected	2013-05-10 12:28:11+00	10353
7016873c-046d-ca60-2d8e-0b2ddaf0aa4e	7	opened	Adresse complète :\nB&B CALAIS Centre St Pierre \t \nZAC Curie\nRue de Lille\n62100 CALAIS\nTel. 08 92 70 75 18 (0.34€ TTC/mn depuis un poste fixe)\nFax. 03 21 00 92 71\nParking, accès handicapé, wifi, ascenseur, caméra	2013-04-24 08:14:28+00	\N
28f959ae-ef10-eb84-6d35-dd7eab4d8eac	7	closed		2013-04-24 08:14:50+00	37548
9765bc35-0bb5-dc04-28cc-b632821ee332	8	opened	test	2013-04-24 08:15:07+00	293774
1c1d3126-df8f-7551-cdf3-6645652eba8d	9	opened	Building is currently demolished	2013-04-24 08:17:47+00	\N
ec4cd7b6-f481-b689-e0f1-502fe59b8712	9	closed	Hat schon jemand eingetragen...	2013-07-03 21:20:32+00	8296
dbc9ed29-de55-dbb9-48e5-e90f8fce2888	8	closed	test close	2013-05-24 08:15:07+00	293774
08424a3c-18ba-7083-8384-9ad9dbcd869f	10	opened	Building is currently demolished	2013-05-24 08:17:47+00	\N
\.


--
-- Data for Name: notes; Type: TABLE DATA; Schema: public; Owner: sanjaybhangar
--

COPY notes (id, created_at, closed_at, opened_by, point) FROM stdin;
4	2013-04-24 08:07:02+00	2013-04-24 08:08:51+00	1626	0101000020E6100000A835CD3B4E375140F5DC9D10955C4240
5	2013-04-24 08:10:38+00	2013-04-24 21:31:47+00	3980	0101000020E6100000FFC4122054F386BF79EBFCDB65E14940
6	2013-04-24 08:12:38+00	2013-05-10 12:28:11+00	378532	0101000020E61000000537AD6F3B7461407868B3452DC24140
7	2013-04-24 08:14:28+00	2013-04-24 08:14:50+00	\N	0101000020E610000060C6B9F2FEC4FD3F129150E916784940
8	2013-04-24 08:15:06+00	\N	293774	0101000020E6100000F0E65F819E8C18407BDF5394A6604940
9	2013-04-24 08:17:47+00	2013-07-03 21:20:32+00	\N	0101000020E6100000080E1E5CF0C02040D33252EFA9B24740
10	2013-05-24 08:17:47+00	2013-07-03 21:20:32+00	\N	0101000020E6100000101C3CB8E0811D40D33252EFA9324840
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: sanjaybhangar
--

COPY spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: sanjaybhangar
--

COPY users (id, name) FROM stdin;
1626	FredB
3980	TomH
378532	nyampire
10353	gorn
37548	Marcussacapuces91
293774	Oli-Wan
8296	kuede
344561	FahRadler
207581	Hjart
3188422	ansuta
3099780	Armire
44660	bjoern_m
1799626	AjBelnuovo
651782	Cyclizine
3318999	wanda987
\.


--
-- Name: changeset_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: sanjaybhangar; Tablespace: 
--

ALTER TABLE ONLY changeset_comments
    ADD CONSTRAINT changeset_comments_pkey PRIMARY KEY (id);


--
-- Name: changeset_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: sanjaybhangar; Tablespace: 
--

ALTER TABLE ONLY changeset_tags
    ADD CONSTRAINT changeset_tags_pkey PRIMARY KEY (id);


--
-- Name: changesets_pkey; Type: CONSTRAINT; Schema: public; Owner: sanjaybhangar; Tablespace: 
--

ALTER TABLE ONLY changesets
    ADD CONSTRAINT changesets_pkey PRIMARY KEY (id);


--
-- Name: note_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: sanjaybhangar; Tablespace: 
--

ALTER TABLE ONLY note_comments
    ADD CONSTRAINT note_comments_pkey PRIMARY KEY (id);


--
-- Name: notes_pkey; Type: CONSTRAINT; Schema: public; Owner: sanjaybhangar; Tablespace: 
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: sanjaybhangar; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: note_comments_note_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sanjaybhangar
--

ALTER TABLE ONLY note_comments
    ADD CONSTRAINT note_comments_note_id_fkey FOREIGN KEY (note_id) REFERENCES notes(id);


--
-- Name: note_comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sanjaybhangar
--

ALTER TABLE ONLY note_comments
    ADD CONSTRAINT note_comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: notes_opened_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sanjaybhangar
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_opened_by_fkey FOREIGN KEY (opened_by) REFERENCES users(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: sanjaybhangar
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--


