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
    username TEXT NULL,
    "timestamp" timestamp with time zone,
    comment text
);


--
-- Name: changeset_tags; Type: TABLE; Schema: public; Owner: sanjaybhangar; Tablespace: 
--

CREATE TABLE IF NOT EXISTS changeset_tags (
    id uuid NOT NULL,
    changeset_id integer,
    key text,
    value text
);


--
-- Name: changesets; Type: TABLE; Schema: public; Owner: sanjaybhangar; Tablespace: 
--

CREATE TABLE IF NOT EXISTS changesets (
    id integer NOT NULL,
    created_at timestamp with time zone,
    closed_at timestamp with time zone,
    is_open boolean,
    user_id integer,
    username TEXT,
    comment TEXT,
    source text NULL,
    created_by text NULL,
    imagery_used text NULL,
    min_lon double precision,
    min_lat double precision,
    max_lon double precision,
    max_lat double precision,
    bbox geometry(Polygon,4326),
    num_changes integer,
    discussion_count integer
);


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

--
-- Name: stats; Type: TABLE; Schema: public; Owner: sanjaybhangar; Tablespace: 
--

CREATE TABLE IF NOT EXISTS stats (
    id integer NOT NULL,
    change_at timestamp with time zone,
    uid integer,
    nodes jsonb,
    ways jsonb,
    relations jsonb,
    changesets integer[],
    tags_created jsonb,
    tags_modified jsonb,
    tags_deleted jsonb
);


--
-- Name: stats_id_seq; Type: SEQUENCE; Schema: public; Owner: sanjaybhangar
--

CREATE SEQUENCE stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sanjaybhangar
--

ALTER SEQUENCE stats_id_seq OWNED BY stats.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: sanjaybhangar; Tablespace: 
--

CREATE TABLE IF NOT EXISTS users (
    id integer NOT NULL,
    name text,
    first_edit timestamptz,
    changeset_count integer,
    num_changes integer
);


--
-- Data for Name: changeset_comments; Type: TABLE DATA; Schema: public; Owner: sanjaybhangar
--

COPY changeset_comments (id, changeset_id, user_id, username, "timestamp", comment) FROM stdin;
4d3664db-486d-4271-229e-9dd7e6cde1c5	34721793	207581	Hjart	2015-10-18 22:48:00+00	Danish addressnodes are maintained by scripts and are actually by law not associated with any specific building. Please do not touch them.
4ec37e85-5e39-f046-86f8-cdce9a0f6fc8	34721793	207581	Hjart	2015-10-18 22:55:00+00	test
8ff2092c-193d-7f7a-4e1f-36c58f685716	34721794	3099780	Armire	2015-11-18 22:49:00+00	Foo
cd7a41cc-f86e-dcd2-e4d4-4c43ba405af4	34721796	3099780	Armire	2015-11-18 22:49:05+00	Fun
920e00bb-5cd6-f262-e31b-3692b5619d01	34721797	44660	bjoern_m	2015-11-18 22:49:10+00	Test discussion item.
e2ecc6c8-3c32-53b4-cab8-25452492ae3f	34721798	1799626	AjBelnuovo	2015-11-18 22:49:15+00	Test discussion item.
9bffe297-5028-08cf-d499-7a9b72c59546	34721798	44660	bjoern_m	2015-11-18 23:49:20+00	Test discussion item.
cf6ff2d1-5fe1-391a-e09e-6170fe1f086a	34721798	44660	bjoern_m	2015-11-18 22:55:10+00	Test discussion item.
8bfd8469-4603-b3c4-066f-2894ee410662	34721798	44660	bjoern_m	2015-12-18 22:55:20+00	Test discussion item.
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

COPY changesets (id, created_at, closed_at, is_open, user_id, username, comment, source, created_by, imagery_used, min_lon, min_lat, max_lon, max_lat, bbox, num_changes, discussion_count) FROM stdin;
34721793	2015-10-18 22:23:15+00	2015-10-18 22:23:16+00	f	344561	username	comment	source	created_by	imagery_used	\N	\N	\N	\N	0103000020E6100000010000000500000072666089AC7E2440226C787AA5944C4072666089AC7E24408A0BF6155A954C404E113BAEA18324408A0BF6155A954C404E113BAEA1832440226C787AA5944C4072666089AC7E2440226C787AA5944C40	37	2
34721794	2015-10-18 22:23:19+00	2015-10-18 22:23:20+00	f	3188422	username	comment	source	created_by	imagery_used	\N	\N	\N	\N	0103000020E6100000010000000500000085DE2C6F5864D4BFF669CB6F8750454085DE2C6F5864D4BFE30C0FAB89504540FA02C46EE962D4BFE30C0FAB89504540FA02C46EE962D4BFF669CB6F8750454085DE2C6F5864D4BFF669CB6F87504540	5	1
34721796	2015-10-18 22:23:22+00	2015-10-18 22:23:53+00	f	44660	username	comment	source	created_by	imagery_used	\N	\N	\N	\N	0103000020E61000000100000005000000D40330AF6D5F24404A0E338F57BE4A40D40330AF6D5F24407496598462C44A4052770A5E99A824407496598462C44A4052770A5E99A824404A0E338F57BE4A40D40330AF6D5F24404A0E338F57BE4A40	5	1
34721797	2015-10-18 22:23:33+00	2015-10-18 22:23:34+00	f	1799626	username	comment	source	created_by	imagery_used	\N	\N	\N	\N	0103000020E61000000100000005000000930843D3C87447C06517B1F4462037C0930843D3C87447C0AB88E4750E1D37C084B70721207447C0AB88E4750E1D37C084B70721207447C06517B1F4462037C0930843D3C87447C06517B1F4462037C0	6	1
34721798	2015-10-18 22:23:37+00	2015-10-18 22:23:38+00	f	651782	username	comment	source	created_by	imagery_used	\N	\N	\N	\N	0103000020E61000000100000005000000BCCFF1D1E2FC00C02F1686C8E9934C40BCCFF1D1E2FC00C0B071FDBB3E944C40941FA79EBBF300C0B071FDBB3E944C40941FA79EBBF300C02F1686C8E9934C40BCCFF1D1E2FC00C02F1686C8E9934C40	16	4
34721799	2015-10-18 22:23:41+00	2015-10-18 22:23:42+00	f	3318999	username	comment	source	created_by	imagery_used	\N	\N	\N	\N	0103000020E610000001000000050000002A1F82AAD11A46406FC44950B2832A402A1F82AAD11A46406FC44950B2832A402A1F82AAD11A46406FC44950B2832A402A1F82AAD11A46406FC44950B2832A402A1F82AAD11A46406FC44950B2832A40	1	1
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
-- Data for Name: stats; Type: TABLE DATA; Schema: public; Owner: sanjaybhangar
--

COPY stats (id, change_at, uid, nodes, ways, relations, changesets, tags_created, tags_modified, tags_deleted) FROM stdin;
1	2017-02-01 10:33:04+05:30	148676	{"c": 304, "d": 0, "m": 26}	{"c": 69, "d": 0, "m": 4}	{"c": 0, "d": 0, "m": 0}	{45706209}	{"highway": {"residential": 1}, "source:geomatry": {"Bing": 1}}	{"building": {"yes": 1}}	{}
2	2017-02-01 10:33:04+05:30	485898	{"c": 122, "d": 16, "m": 19}	{"c": 13, "d": 2, "m": 7}	{"c": 0, "d": 0, "m": 2}	{45706210}	{"landuse": {"grass": 1}}	{"ref": {"RN9": 1}, "name": {"Autopista Ernesto Guevara": 1}, "type": {"route": 1}, "route": {"road": 1}, "loc_ref": {"AU9": 1}, "old_ref": {"1V09": 1}, "distance": {"387 km": 1}, "wikipedia": {"es:Autopista Rosario-Córdoba": 1}, "short_name": {"Ernesto Guevara": 1}, "is_in:country": {"Argentina": 1}}	{}
3	2017-02-01 10:33:04+05:30	597250	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706214}	{"name": {"Zierwerk Tätowier-Manufaktur": 1}, "shop": {"tattoo": 1}, "addr:city": {"Dorsten": 1}, "addr:street": {"Fürst Leopold Platz": 1}, "addr:country": {"DE": 1}, "addr:postcode": {"46284": 1}, "contact:phone": {"+4923629664799": 1}, "opening_hours": {"Tu-Fr 12:00-19:00": 1}, "contact:website": {"https://www.zierwerk-taetowier-manufaktur.de": 1}, "addr:housenumber": {"1": 1}}	{}	{}
4	2017-02-01 10:33:04+05:30	2292368	{"c": 29, "d": 14, "m": 71}	{"c": 7, "d": 3, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706216}	{"building": {"yes": 1}}	{"highway": {"track": 1}}	{}
5	2017-02-01 10:33:04+05:30	3429710	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706204}	{}	{"building": {"yes": 1}, "addr:city": {"Хабаровск": 1}, "addr:street": {"Посадочная улица": 1}, "addr:housenumber": {"4": 1}}	{}
6	2017-02-01 10:33:04+05:30	4718866	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 1}	{45706217}	{}	{"name": {"Navoiy shoh ko'chasi": 1}, "type": {"associatedStreet": 1}, "name:en": {"Navoiy Street": 1}, "name:eo": {"Navoiy strato": 1}, "name:ru": {"проспект Навои": 1}, "name:uz": {"Navoiy shoh ko'chasi": 1}, "old_name": {"Проспект Обухова; Обухова улица; Шейхантаурская улица; Ташкуча улица; Файзуллы Ходжаева улица; Проспект Алишера Навои": 1}, "old_name:ru": {"Проспект Обухова; Обухова улица; Шейхантаурская улица; Ташкуча улица; Файзуллы Ходжаева улица; Проспект Алишера Навои": 1}}	{}
7	2017-02-01 10:33:04+05:30	4803484	{"c": 2, "d": 2, "m": 5}	{"c": 2, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45706208}	{"source": {"Bing": 1}, "highway": {"service": 1}, "service": {"driveway": 1}}	{"source": {"Reconocimiento cartográfico 2016 por KG.": 1}, "building": {"roof": 1}, "addr:street": {"Tercer Anillo Interno": 1}}	{}
8	2017-02-01 10:33:04+05:30	4803527	{"c": 2, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45706211}	{}	{"name": {"Santa Rosa": 1}, "amenity": {"school": 1}}	{}
9	2017-02-01 10:33:04+05:30	4803528	{"c": 0, "d": 0, "m": 4}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706207}	{}	{}	{}
10	2017-02-01 10:33:04+05:30	4905512	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706218}	{"shop": {"laundry": 1}, "name:en": {"Laundry": 1}}	{}	{}
11	2017-02-01 10:33:04+05:30	5008873	{"c": 1, "d": 0, "m": 0}	{"c": 1, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706206}	{"lit": {"yes": 1}, "highway": {"footway": 1}, "surface": {"paved": 1}}	{"lit": {"yes": 1}, "highway": {"footway": 1}, "surface": {"paved": 1}}	{}
12	2017-02-01 10:33:04+05:30	5161593	{"c": 12, "d": 0, "m": 0}	{"c": 3, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706205,45706213,45706215}	{"building": {"house": 1}}	{}	{}
13	2017-02-01 10:33:04+05:30	5193137	{"c": 1, "d": 0, "m": 40}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706212}	{}	{"ref": {"23": 1}, "ncat": {"국도": 1}, "review": {"no": 1}, "source": {"NTIC": 1}, "highway": {"primary": 1}}	{}
14	2017-02-01 10:33:04+05:30	5238124	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 424}	{45706085}	{}	{"name": {"Paroo-Darling National Park": 1}, "type": {"boundary": 1}, "source": {"NSW LPI Base Map": 1}, "leisure": {"nature_reserve": 1}, "boundary": {"protected_area": 1}, "protect_class": {"2": 1}}	{}
15	2017-02-01 10:33:04+05:30	148676	{"c": 304, "d": 0, "m": 26}	{"c": 69, "d": 0, "m": 4}	{"c": 0, "d": 0, "m": 0}	{45706209}	{"highway": {"residential": 1}, "source:geomatry": {"Bing": 1}}	{"building": {"yes": 1}}	{}
34	2017-02-01 10:33:04+05:30	510836	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
16	2017-02-01 10:33:04+05:30	485898	{"c": 122, "d": 16, "m": 19}	{"c": 13, "d": 2, "m": 7}	{"c": 0, "d": 0, "m": 2}	{45706210}	{"landuse": {"grass": 1}}	{"ref": {"RN9": 1}, "name": {"Autopista Ernesto Guevara": 1}, "type": {"route": 1}, "route": {"road": 1}, "loc_ref": {"AU9": 1}, "old_ref": {"1V09": 1}, "distance": {"387 km": 1}, "wikipedia": {"es:Autopista Rosario-Córdoba": 1}, "short_name": {"Ernesto Guevara": 1}, "is_in:country": {"Argentina": 1}}	{}
17	2017-02-01 10:33:04+05:30	597250	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706214}	{"name": {"Zierwerk Tätowier-Manufaktur": 1}, "shop": {"tattoo": 1}, "addr:city": {"Dorsten": 1}, "addr:street": {"Fürst Leopold Platz": 1}, "addr:country": {"DE": 1}, "addr:postcode": {"46284": 1}, "contact:phone": {"+4923629664799": 1}, "opening_hours": {"Tu-Fr 12:00-19:00": 1}, "contact:website": {"https://www.zierwerk-taetowier-manufaktur.de": 1}, "addr:housenumber": {"1": 1}}	{}	{}
18	2017-02-01 10:33:04+05:30	2292368	{"c": 29, "d": 14, "m": 71}	{"c": 7, "d": 3, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706216}	{"building": {"yes": 1}}	{"highway": {"track": 1}}	{}
19	2017-02-01 10:33:04+05:30	3429710	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706204}	{}	{"building": {"yes": 1}, "addr:city": {"Хабаровск": 1}, "addr:street": {"Посадочная улица": 1}, "addr:housenumber": {"4": 1}}	{}
20	2017-02-01 10:33:04+05:30	4718866	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 1}	{45706217}	{}	{"name": {"Navoiy shoh ko'chasi": 1}, "type": {"associatedStreet": 1}, "name:en": {"Navoiy Street": 1}, "name:eo": {"Navoiy strato": 1}, "name:ru": {"проспект Навои": 1}, "name:uz": {"Navoiy shoh ko'chasi": 1}, "old_name": {"Проспект Обухова; Обухова улица; Шейхантаурская улица; Ташкуча улица; Файзуллы Ходжаева улица; Проспект Алишера Навои": 1}, "old_name:ru": {"Проспект Обухова; Обухова улица; Шейхантаурская улица; Ташкуча улица; Файзуллы Ходжаева улица; Проспект Алишера Навои": 1}}	{}
21	2017-02-01 10:33:04+05:30	4803484	{"c": 2, "d": 2, "m": 5}	{"c": 2, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45706208}	{"source": {"Bing": 1}, "highway": {"service": 1}, "service": {"driveway": 1}}	{"source": {"Reconocimiento cartográfico 2016 por KG.": 1}, "building": {"roof": 1}, "addr:street": {"Tercer Anillo Interno": 1}}	{}
22	2017-02-01 10:33:04+05:30	4803527	{"c": 2, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45706211}	{}	{"name": {"Santa Rosa": 1}, "amenity": {"school": 1}}	{}
23	2017-02-01 10:33:04+05:30	4803528	{"c": 0, "d": 0, "m": 4}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706207}	{}	{}	{}
24	2017-02-01 10:33:04+05:30	4905512	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706218}	{"shop": {"laundry": 1}, "name:en": {"Laundry": 1}}	{}	{}
25	2017-02-01 10:33:04+05:30	5008873	{"c": 1, "d": 0, "m": 0}	{"c": 1, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706206}	{"lit": {"yes": 1}, "highway": {"footway": 1}, "surface": {"paved": 1}}	{"lit": {"yes": 1}, "highway": {"footway": 1}, "surface": {"paved": 1}}	{}
26	2017-02-01 10:33:04+05:30	5161593	{"c": 12, "d": 0, "m": 0}	{"c": 3, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706205,45706213,45706215}	{"building": {"house": 1}}	{}	{}
27	2017-02-01 10:33:04+05:30	5193137	{"c": 1, "d": 0, "m": 40}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706212}	{}	{"ref": {"23": 1}, "ncat": {"국도": 1}, "review": {"no": 1}, "source": {"NTIC": 1}, "highway": {"primary": 1}}	{}
28	2017-02-01 10:33:04+05:30	5238124	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 424}	{45706085}	{}	{"name": {"Paroo-Darling National Park": 1}, "type": {"boundary": 1}, "source": {"NSW LPI Base Map": 1}, "leisure": {"nature_reserve": 1}, "boundary": {"protected_area": 1}, "protect_class": {"2": 1}}	{}
29	2017-02-01 10:33:04+05:30	1306	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
30	2017-02-01 10:33:04+05:30	53073	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
31	2017-02-01 10:33:04+05:30	94578	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
32	2017-02-01 10:33:04+05:30	146675	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
33	2017-02-01 10:33:04+05:30	261012	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
35	2017-02-01 10:33:04+05:30	589596	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
36	2017-02-01 10:33:04+05:30	706170	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
37	2017-02-01 10:33:04+05:30	1087876	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
38	2017-02-01 10:33:04+05:30	1240849	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
39	2017-02-01 10:33:04+05:30	1597155	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
40	2017-02-01 10:33:04+05:30	1829683	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
41	2017-02-01 10:33:04+05:30	2015224	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
42	2017-02-01 10:33:04+05:30	2115749	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
43	2017-02-01 10:33:04+05:30	2219338	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
44	2017-02-01 10:33:04+05:30	2226712	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
45	2017-02-01 10:33:04+05:30	2306749	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
46	2017-02-01 10:33:04+05:30	2477516	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
47	2017-02-01 10:33:04+05:30	2508151	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
48	2017-02-01 10:33:04+05:30	2511706	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
49	2017-02-01 10:33:04+05:30	2512300	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
50	2017-02-01 10:33:04+05:30	2554698	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
51	2017-02-01 10:33:04+05:30	2644101	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
52	2017-02-01 10:33:04+05:30	2748195	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
53	2017-02-01 10:33:04+05:30	2823295	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
54	2017-02-01 10:33:04+05:30	2835928	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
55	2017-02-01 10:33:04+05:30	2847988	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
56	2017-02-01 10:33:04+05:30	2905914	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
57	2017-02-01 10:33:04+05:30	2985232	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
58	2017-02-01 10:33:04+05:30	3029661	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
59	2017-02-01 10:33:04+05:30	3057995	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
60	2017-02-01 10:33:04+05:30	3272286	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
61	2017-02-01 10:33:04+05:30	3460649	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
62	2017-02-01 10:33:04+05:30	3479270	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
63	2017-02-01 10:33:04+05:30	3526564	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
64	2017-02-01 10:33:04+05:30	3572302	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
65	2017-02-01 10:33:04+05:30	3769434	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
66	2017-02-01 10:33:04+05:30	3877019	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
67	2017-02-01 10:33:04+05:30	3878839	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
68	2017-02-01 10:33:04+05:30	4007051	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
69	2017-02-01 10:33:04+05:30	4148813	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
70	2017-02-01 10:33:04+05:30	1306	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
71	2017-02-01 10:33:04+05:30	53073	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
72	2017-02-01 10:33:04+05:30	94578	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
73	2017-02-01 10:33:04+05:30	146675	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
74	2017-02-01 10:33:04+05:30	261012	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
75	2017-02-01 10:33:04+05:30	510836	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
76	2017-02-01 10:33:04+05:30	589596	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
77	2017-02-01 10:33:04+05:30	706170	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
78	2017-02-01 10:33:04+05:30	1087876	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
79	2017-02-01 10:33:04+05:30	1240849	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
80	2017-02-01 10:33:04+05:30	1597155	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
81	2017-02-01 10:33:04+05:30	1829683	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
82	2017-02-01 10:33:04+05:30	2015224	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
83	2017-02-01 10:33:04+05:30	2115749	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
84	2017-02-01 10:33:04+05:30	2219338	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
85	2017-02-01 10:33:04+05:30	2226712	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
86	2017-02-01 10:33:04+05:30	2306749	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
87	2017-02-01 10:33:04+05:30	2477516	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
88	2017-02-01 10:33:04+05:30	2508151	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
89	2017-02-01 10:33:04+05:30	2511706	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
90	2017-02-01 10:33:04+05:30	2512300	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
91	2017-02-01 10:33:04+05:30	2554698	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
92	2017-02-01 10:33:04+05:30	2644101	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
93	2017-02-01 10:33:04+05:30	2748195	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
94	2017-02-01 10:33:04+05:30	2823295	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
95	2017-02-01 10:33:04+05:30	2835928	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
96	2017-02-01 10:33:04+05:30	2847988	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
97	2017-02-01 10:33:04+05:30	2905914	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
98	2017-02-01 10:33:04+05:30	2985232	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
99	2017-02-01 10:33:04+05:30	3029661	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
100	2017-02-01 10:33:04+05:30	3057995	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
101	2017-02-01 10:33:04+05:30	3272286	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
102	2017-02-01 10:33:04+05:30	3460649	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
103	2017-02-01 10:33:04+05:30	3479270	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
104	2017-02-01 10:33:04+05:30	3526564	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
105	2017-02-01 10:33:04+05:30	3572302	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
106	2017-02-01 10:33:04+05:30	3769434	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
107	2017-02-01 10:33:04+05:30	3877019	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
108	2017-02-01 10:33:04+05:30	3878839	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
109	2017-02-01 10:33:04+05:30	4007051	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
110	2017-02-01 10:33:04+05:30	4148813	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
111	2017-02-01 10:33:04+05:30	148676	{"c": 304, "d": 0, "m": 26}	{"c": 69, "d": 0, "m": 4}	{"c": 0, "d": 0, "m": 0}	{45706209}	{"highway": {"residential": 1}, "source:geomatry": {"Bing": 1}}	{"building": {"yes": 1}}	{}
112	2017-02-01 10:33:04+05:30	485898	{"c": 122, "d": 16, "m": 19}	{"c": 13, "d": 2, "m": 7}	{"c": 0, "d": 0, "m": 2}	{45706210}	{"landuse": {"grass": 1}}	{"ref": {"RN9": 1}, "name": {"Autopista Ernesto Guevara": 1}, "type": {"route": 1}, "route": {"road": 1}, "loc_ref": {"AU9": 1}, "old_ref": {"1V09": 1}, "distance": {"387 km": 1}, "wikipedia": {"es:Autopista Rosario-Córdoba": 1}, "short_name": {"Ernesto Guevara": 1}, "is_in:country": {"Argentina": 1}}	{}
113	2017-02-01 10:33:04+05:30	597250	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706214}	{"name": {"Zierwerk Tätowier-Manufaktur": 1}, "shop": {"tattoo": 1}, "addr:city": {"Dorsten": 1}, "addr:street": {"Fürst Leopold Platz": 1}, "addr:country": {"DE": 1}, "addr:postcode": {"46284": 1}, "contact:phone": {"+4923629664799": 1}, "opening_hours": {"Tu-Fr 12:00-19:00": 1}, "contact:website": {"https://www.zierwerk-taetowier-manufaktur.de": 1}, "addr:housenumber": {"1": 1}}	{}	{}
114	2017-02-01 10:33:04+05:30	2292368	{"c": 29, "d": 14, "m": 71}	{"c": 7, "d": 3, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706216}	{"building": {"yes": 1}}	{"highway": {"track": 1}}	{}
115	2017-02-01 10:33:04+05:30	3429710	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706204}	{}	{"building": {"yes": 1}, "addr:city": {"Хабаровск": 1}, "addr:street": {"Посадочная улица": 1}, "addr:housenumber": {"4": 1}}	{}
116	2017-02-01 10:33:04+05:30	4718866	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 1}	{45706217}	{}	{"name": {"Navoiy shoh ko'chasi": 1}, "type": {"associatedStreet": 1}, "name:en": {"Navoiy Street": 1}, "name:eo": {"Navoiy strato": 1}, "name:ru": {"проспект Навои": 1}, "name:uz": {"Navoiy shoh ko'chasi": 1}, "old_name": {"Проспект Обухова; Обухова улица; Шейхантаурская улица; Ташкуча улица; Файзуллы Ходжаева улица; Проспект Алишера Навои": 1}, "old_name:ru": {"Проспект Обухова; Обухова улица; Шейхантаурская улица; Ташкуча улица; Файзуллы Ходжаева улица; Проспект Алишера Навои": 1}}	{}
117	2017-02-01 10:33:04+05:30	4803484	{"c": 2, "d": 2, "m": 5}	{"c": 2, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45706208}	{"source": {"Bing": 1}, "highway": {"service": 1}, "service": {"driveway": 1}}	{"source": {"Reconocimiento cartográfico 2016 por KG.": 1}, "building": {"roof": 1}, "addr:street": {"Tercer Anillo Interno": 1}}	{}
118	2017-02-01 10:33:04+05:30	4803527	{"c": 2, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45706211}	{}	{"name": {"Santa Rosa": 1}, "amenity": {"school": 1}}	{}
119	2017-02-01 10:33:04+05:30	4803528	{"c": 0, "d": 0, "m": 4}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706207}	{}	{}	{}
120	2017-02-01 10:33:04+05:30	4905512	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706218}	{"shop": {"laundry": 1}, "name:en": {"Laundry": 1}}	{}	{}
168	2017-02-01 10:34:38+05:30	3029661	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
121	2017-02-01 10:33:04+05:30	5008873	{"c": 1, "d": 0, "m": 0}	{"c": 1, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706206}	{"lit": {"yes": 1}, "highway": {"footway": 1}, "surface": {"paved": 1}}	{"lit": {"yes": 1}, "highway": {"footway": 1}, "surface": {"paved": 1}}	{}
122	2017-02-01 10:33:04+05:30	5161593	{"c": 12, "d": 0, "m": 0}	{"c": 3, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706205,45706213,45706215}	{"building": {"house": 1}}	{}	{}
123	2017-02-01 10:33:04+05:30	5193137	{"c": 1, "d": 0, "m": 40}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706212}	{}	{"ref": {"23": 1}, "ncat": {"국도": 1}, "review": {"no": 1}, "source": {"NTIC": 1}, "highway": {"primary": 1}}	{}
124	2017-02-01 10:33:04+05:30	5238124	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 424}	{45706085}	{}	{"name": {"Paroo-Darling National Park": 1}, "type": {"boundary": 1}, "source": {"NSW LPI Base Map": 1}, "leisure": {"nature_reserve": 1}, "boundary": {"protected_area": 1}, "protect_class": {"2": 1}}	{}
125	2017-02-01 10:33:04+05:30	148676	{"c": 304, "d": 0, "m": 26}	{"c": 69, "d": 0, "m": 4}	{"c": 0, "d": 0, "m": 0}	{45706209}	{"highway": {"residential": 1}, "source:geomatry": {"Bing": 1}}	{"building": {"yes": 1}}	{}
126	2017-02-01 10:33:04+05:30	485898	{"c": 122, "d": 16, "m": 19}	{"c": 13, "d": 2, "m": 7}	{"c": 0, "d": 0, "m": 2}	{45706210}	{"landuse": {"grass": 1}}	{"ref": {"RN9": 1}, "name": {"Autopista Ernesto Guevara": 1}, "type": {"route": 1}, "route": {"road": 1}, "loc_ref": {"AU9": 1}, "old_ref": {"1V09": 1}, "distance": {"387 km": 1}, "wikipedia": {"es:Autopista Rosario-Córdoba": 1}, "short_name": {"Ernesto Guevara": 1}, "is_in:country": {"Argentina": 1}}	{}
127	2017-02-01 10:33:04+05:30	597250	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706214}	{"name": {"Zierwerk Tätowier-Manufaktur": 1}, "shop": {"tattoo": 1}, "addr:city": {"Dorsten": 1}, "addr:street": {"Fürst Leopold Platz": 1}, "addr:country": {"DE": 1}, "addr:postcode": {"46284": 1}, "contact:phone": {"+4923629664799": 1}, "opening_hours": {"Tu-Fr 12:00-19:00": 1}, "contact:website": {"https://www.zierwerk-taetowier-manufaktur.de": 1}, "addr:housenumber": {"1": 1}}	{}	{}
128	2017-02-01 10:33:04+05:30	2292368	{"c": 29, "d": 14, "m": 71}	{"c": 7, "d": 3, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706216}	{"building": {"yes": 1}}	{"highway": {"track": 1}}	{}
129	2017-02-01 10:33:04+05:30	3429710	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706204}	{}	{"building": {"yes": 1}, "addr:city": {"Хабаровск": 1}, "addr:street": {"Посадочная улица": 1}, "addr:housenumber": {"4": 1}}	{}
130	2017-02-01 10:33:04+05:30	4718866	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 1}	{45706217}	{}	{"name": {"Navoiy shoh ko'chasi": 1}, "type": {"associatedStreet": 1}, "name:en": {"Navoiy Street": 1}, "name:eo": {"Navoiy strato": 1}, "name:ru": {"проспект Навои": 1}, "name:uz": {"Navoiy shoh ko'chasi": 1}, "old_name": {"Проспект Обухова; Обухова улица; Шейхантаурская улица; Ташкуча улица; Файзуллы Ходжаева улица; Проспект Алишера Навои": 1}, "old_name:ru": {"Проспект Обухова; Обухова улица; Шейхантаурская улица; Ташкуча улица; Файзуллы Ходжаева улица; Проспект Алишера Навои": 1}}	{}
131	2017-02-01 10:33:04+05:30	4803484	{"c": 2, "d": 2, "m": 5}	{"c": 2, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45706208}	{"source": {"Bing": 1}, "highway": {"service": 1}, "service": {"driveway": 1}}	{"source": {"Reconocimiento cartográfico 2016 por KG.": 1}, "building": {"roof": 1}, "addr:street": {"Tercer Anillo Interno": 1}}	{}
132	2017-02-01 10:33:04+05:30	4803527	{"c": 2, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45706211}	{}	{"name": {"Santa Rosa": 1}, "amenity": {"school": 1}}	{}
133	2017-02-01 10:33:04+05:30	4803528	{"c": 0, "d": 0, "m": 4}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706207}	{}	{}	{}
134	2017-02-01 10:33:04+05:30	4905512	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706218}	{"shop": {"laundry": 1}, "name:en": {"Laundry": 1}}	{}	{}
135	2017-02-01 10:33:04+05:30	5008873	{"c": 1, "d": 0, "m": 0}	{"c": 1, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706206}	{"lit": {"yes": 1}, "highway": {"footway": 1}, "surface": {"paved": 1}}	{"lit": {"yes": 1}, "highway": {"footway": 1}, "surface": {"paved": 1}}	{}
136	2017-02-01 10:33:04+05:30	5161593	{"c": 12, "d": 0, "m": 0}	{"c": 3, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706205,45706213,45706215}	{"building": {"house": 1}}	{}	{}
137	2017-02-01 10:33:04+05:30	5193137	{"c": 1, "d": 0, "m": 40}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706212}	{}	{"ref": {"23": 1}, "ncat": {"국도": 1}, "review": {"no": 1}, "source": {"NTIC": 1}, "highway": {"primary": 1}}	{}
138	2017-02-01 10:33:04+05:30	5238124	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 424}	{45706085}	{}	{"name": {"Paroo-Darling National Park": 1}, "type": {"boundary": 1}, "source": {"NSW LPI Base Map": 1}, "leisure": {"nature_reserve": 1}, "boundary": {"protected_area": 1}, "protect_class": {"2": 1}}	{}
139	2017-02-01 10:34:38+05:30	1306	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
140	2017-02-01 10:34:38+05:30	53073	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
141	2017-02-01 10:34:38+05:30	94578	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
142	2017-02-01 10:34:38+05:30	146675	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
143	2017-02-01 10:34:38+05:30	261012	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
144	2017-02-01 10:34:38+05:30	510836	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
145	2017-02-01 10:34:38+05:30	589596	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
146	2017-02-01 10:34:38+05:30	706170	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
147	2017-02-01 10:34:38+05:30	1087876	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
148	2017-02-01 10:34:38+05:30	1240849	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
149	2017-02-01 10:34:38+05:30	1597155	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
150	2017-02-01 10:34:38+05:30	1829683	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
151	2017-02-01 10:34:38+05:30	2015224	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
152	2017-02-01 10:34:38+05:30	2115749	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
153	2017-02-01 10:34:38+05:30	2219338	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
154	2017-02-01 10:34:38+05:30	2226712	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
155	2017-02-01 10:34:38+05:30	2306749	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
156	2017-02-01 10:34:38+05:30	2477516	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
157	2017-02-01 10:34:38+05:30	2508151	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
158	2017-02-01 10:34:38+05:30	2511706	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
159	2017-02-01 10:34:38+05:30	2512300	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
160	2017-02-01 10:34:38+05:30	2554698	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
161	2017-02-01 10:34:38+05:30	2644101	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
162	2017-02-01 10:34:38+05:30	2748195	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
163	2017-02-01 10:34:38+05:30	2823295	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
164	2017-02-01 10:34:38+05:30	2835928	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
165	2017-02-01 10:34:38+05:30	2847988	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
166	2017-02-01 10:34:38+05:30	2905914	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
167	2017-02-01 10:34:38+05:30	2985232	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
169	2017-02-01 10:34:38+05:30	3057995	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
170	2017-02-01 10:34:38+05:30	3272286	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
171	2017-02-01 10:34:38+05:30	3460649	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
172	2017-02-01 10:34:38+05:30	3479270	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
173	2017-02-01 10:34:38+05:30	3526564	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
174	2017-02-01 10:34:38+05:30	3572302	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
175	2017-02-01 10:34:38+05:30	3769434	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
176	2017-02-01 10:34:38+05:30	3877019	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
177	2017-02-01 10:34:38+05:30	3878839	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
178	2017-02-01 10:34:38+05:30	4007051	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
179	2017-02-01 10:34:38+05:30	4148813	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{}	{}	{}	{}
180	2017-02-01 10:34:38+05:30	148676	{"c": 304, "d": 0, "m": 26}	{"c": 69, "d": 0, "m": 4}	{"c": 0, "d": 0, "m": 0}	{45706209}	{"highway": {"residential": 1}, "source:geomatry": {"Bing": 1}}	{"building": {"yes": 1}}	{}
181	2017-02-01 10:34:38+05:30	485898	{"c": 122, "d": 16, "m": 19}	{"c": 13, "d": 2, "m": 7}	{"c": 0, "d": 0, "m": 2}	{45706210}	{"landuse": {"grass": 1}}	{"ref": {"RN9": 1}, "name": {"Autopista Ernesto Guevara": 1}, "type": {"route": 1}, "route": {"road": 1}, "loc_ref": {"AU9": 1}, "old_ref": {"1V09": 1}, "distance": {"387 km": 1}, "wikipedia": {"es:Autopista Rosario-Córdoba": 1}, "short_name": {"Ernesto Guevara": 1}, "is_in:country": {"Argentina": 1}}	{}
182	2017-02-01 10:34:38+05:30	597250	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706214}	{"name": {"Zierwerk Tätowier-Manufaktur": 1}, "shop": {"tattoo": 1}, "addr:city": {"Dorsten": 1}, "addr:street": {"Fürst Leopold Platz": 1}, "addr:country": {"DE": 1}, "addr:postcode": {"46284": 1}, "contact:phone": {"+4923629664799": 1}, "opening_hours": {"Tu-Fr 12:00-19:00": 1}, "contact:website": {"https://www.zierwerk-taetowier-manufaktur.de": 1}, "addr:housenumber": {"1": 1}}	{}	{}
183	2017-02-01 10:34:38+05:30	2292368	{"c": 29, "d": 14, "m": 71}	{"c": 7, "d": 3, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706216}	{"building": {"yes": 1}}	{"highway": {"track": 1}}	{}
184	2017-02-01 10:34:38+05:30	3429710	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706204}	{}	{"building": {"yes": 1}, "addr:city": {"Хабаровск": 1}, "addr:street": {"Посадочная улица": 1}, "addr:housenumber": {"4": 1}}	{}
185	2017-02-01 10:34:38+05:30	4718866	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 1}	{45706217}	{}	{"name": {"Navoiy shoh ko'chasi": 1}, "type": {"associatedStreet": 1}, "name:en": {"Navoiy Street": 1}, "name:eo": {"Navoiy strato": 1}, "name:ru": {"проспект Навои": 1}, "name:uz": {"Navoiy shoh ko'chasi": 1}, "old_name": {"Проспект Обухова; Обухова улица; Шейхантаурская улица; Ташкуча улица; Файзуллы Ходжаева улица; Проспект Алишера Навои": 1}, "old_name:ru": {"Проспект Обухова; Обухова улица; Шейхантаурская улица; Ташкуча улица; Файзуллы Ходжаева улица; Проспект Алишера Навои": 1}}	{}
186	2017-02-01 10:34:38+05:30	4803484	{"c": 2, "d": 2, "m": 5}	{"c": 2, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45706208}	{"source": {"Bing": 1}, "highway": {"service": 1}, "service": {"driveway": 1}}	{"source": {"Reconocimiento cartográfico 2016 por KG.": 1}, "building": {"roof": 1}, "addr:street": {"Tercer Anillo Interno": 1}}	{}
187	2017-02-01 10:34:38+05:30	4803527	{"c": 2, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45706211}	{}	{"name": {"Santa Rosa": 1}, "amenity": {"school": 1}}	{}
188	2017-02-01 10:34:38+05:30	4803528	{"c": 0, "d": 0, "m": 4}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706207}	{}	{}	{}
189	2017-02-01 10:34:38+05:30	4905512	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706218}	{"shop": {"laundry": 1}, "name:en": {"Laundry": 1}}	{}	{}
190	2017-02-01 10:34:38+05:30	5008873	{"c": 1, "d": 0, "m": 0}	{"c": 1, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706206}	{"lit": {"yes": 1}, "highway": {"footway": 1}, "surface": {"paved": 1}}	{"lit": {"yes": 1}, "highway": {"footway": 1}, "surface": {"paved": 1}}	{}
191	2017-02-01 10:34:38+05:30	5161593	{"c": 12, "d": 0, "m": 0}	{"c": 3, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45706205,45706213,45706215}	{"building": {"house": 1}}	{}	{}
192	2017-02-01 10:34:38+05:30	5193137	{"c": 1, "d": 0, "m": 40}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45706212}	{}	{"ref": {"23": 1}, "ncat": {"국도": 1}, "review": {"no": 1}, "source": {"NTIC": 1}, "highway": {"primary": 1}}	{}
193	2017-02-01 10:34:38+05:30	5238124	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 424}	{45706085}	{}	{"name": {"Paroo-Darling National Park": 1}, "type": {"boundary": 1}, "source": {"NSW LPI Base Map": 1}, "leisure": {"nature_reserve": 1}, "boundary": {"protected_area": 1}, "protect_class": {"2": 1}}	{}
194	2017-02-06 15:03:30+05:30	81841	{"c": 0, "d": 0, "m": 0}	{"c": 66, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850292}	{"building": {"house": 1}, "addr:city": {"Abuyog": 1}, "addr:postcode": {"6510": 1}, "addr:province": {"Leyte": 1}}	{}	{}
195	2017-02-06 15:03:30+05:30	113813	{"c": 48, "d": 0, "m": 60}	{"c": 6, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850298}	{"source": {"Bing": 1}, "landuse": {"meadow": 1}}	{}	{}
196	2017-02-06 15:03:30+05:30	198366	{"c": 6, "d": 0, "m": 2}	{"c": 2, "d": 0, "m": 2}	{"c": 1, "d": 0, "m": 0}	{45850326}	{"name": {"parking": 1}, "site": {"parking": 1}, "type": {"site": 1}}	{"access": {"private": 1}, "amenity": {"parking": 1}}	{}
197	2017-02-06 15:03:30+05:30	213513	{"c": 0, "d": 3, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850330}	{}	{"source": {"cadastre-dgi-fr source : Direction Générale des Finances Publiques - Cadastre. Mise à jour : 2015": 1}, "building": {"yes": 1}}	{}
198	2017-02-06 15:03:30+05:30	362126	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850308}	{}	{"landuse": {"construction": 1}}	{}
199	2017-02-06 15:03:30+05:30	672542	{"c": 2, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850314}	{"amenity": {"restaurant": 1}}	{}	{}
200	2017-02-06 15:03:30+05:30	684298	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 12}	{"c": 0, "d": 0, "m": 0}	{45850320}	{}	{"building": {"yes": 1}, "addr:city": {"Geldern": 1}, "addr:street": {"Neustraße": 1}, "addr:postcode": {"47608": 1}, "addr:housenumber": {"7": 1}}	{}
201	2017-02-06 15:03:30+05:30	708145	{"c": 34, "d": 3, "m": 21}	{"c": 7, "d": 1, "m": 5}	{"c": 0, "d": 0, "m": 0}	{45850302}	{"building": {"yes": 1}}	{"building": {"yes": 1}}	{}
202	2017-02-06 15:03:30+05:30	717069	{"c": 119, "d": 4, "m": 3}	{"c": 21, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45850318}	{"highway": {"track": 1}}	{"highway": {"residential": 1}, "surface": {"asphalt": 1}, "maxspeed": {"30": 1}}	{}
203	2017-02-06 15:03:30+05:30	1771198	{"c": 37, "d": 5, "m": 20}	{"c": 8, "d": 1, "m": 9}	{"c": 0, "d": 0, "m": 0}	{45850300}	{"layer": {"-1": 1}, "tunnel": {"culvert": 1}, "waterway": {"ditch": 1}}	{"waterway": {"ditch": 1}}	{}
204	2017-02-06 15:03:30+05:30	1981984	{"c": 36, "d": 0, "m": 0}	{"c": 12, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850316}	{"building": {"yes": 1}}	{}	{}
205	2017-02-06 15:03:30+05:30	2110714	{"c": 118, "d": 3, "m": 29}	{"c": 32, "d": 0, "m": 14}	{"c": 0, "d": 0, "m": 0}	{45850311}	{"highway": {"footway": 1}}	{"highway": {"service": 1}}	{}
206	2017-02-06 15:03:30+05:30	2855576	{"c": 45, "d": 0, "m": 0}	{"c": 2, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850301,45850324}	{"water": {"lake": 1}, "natural": {"water": 1}}	{"name": {"11 ветка": 1}, "source": {"ScanEx IRS": 1}, "highway": {"unclassified": 1}, "surface": {"unpaved": 1}, "maxspeed": {"50": 1}}	{}
207	2017-02-06 15:03:30+05:30	2955770	{"c": 10, "d": 0, "m": 23}	{"c": 0, "d": 0, "m": 3}	{"c": 0, "d": 0, "m": 0}	{45850325}	{"name": {"Fergusson Drive at Vista Crescent": 1}, "source": {"Survey": 1}, "amenity": {"shelter": 1}, "shelter_type": {"public_transport": 1}}	{"landuse": {"residential": 1}}	{}
208	2017-02-06 15:03:30+05:30	3068577	{"c": 5, "d": 0, "m": 2}	{"c": 2, "d": 0, "m": 3}	{"c": 0, "d": 0, "m": 0}	{45850310}	{"highway": {"cycleway": 1}}	{"landuse": {"residential": 1}}	{}
209	2017-02-06 15:03:30+05:30	3153457	{"c": 0, "d": 0, "m": 519}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850313}	{}	{"curve_geometry": {"yes": 1}}	{}
210	2017-02-06 15:03:30+05:30	3528297	{"c": 81, "d": 0, "m": 1}	{"c": 17, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850327}	{"building": {"yes": 1}}	{"highway": {"unclassified": 1}}	{}
211	2017-02-06 15:03:30+05:30	3969644	{"c": 3, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850303}	{"name": {"Ibn Al-Baytar": 1}, "tourism": {"artwork": 1}, "artwork_type": {"statue": 1}}	{}	{}
212	2017-02-06 15:03:30+05:30	4048394	{"c": 10, "d": 0, "m": 0}	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850331}	{"water": {"pond": 1}, "natural": {"water": 1}}	{}	{}
213	2017-02-06 15:03:30+05:30	4355310	{"c": 22, "d": 0, "m": 1}	{"c": 1, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45850299}	{"highway": {"path": 1}}	{"bicycle": {"yes": 1}, "highway": {"cycleway": 1}, "surface": {"paved": 1}, "vehicle": {"no": 1}}	{}
214	2017-02-06 15:03:30+05:30	4433679	{"c": 0, "d": 0, "m": 3}	{"c": 0, "d": 0, "m": 3}	{"c": 0, "d": 0, "m": 0}	{45850051}	{}	{"name": {"Whitemud Drive NW": 1}, "oneway": {"yes": 1}, "highway": {"tertiary": 1}}	{}
215	2017-02-06 15:03:30+05:30	4800002	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850323}	{"amenity": {"bench": 1}}	{}	{}
216	2017-02-06 15:03:30+05:30	4803525	{"c": 0, "d": 0, "m": 5}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850315}	{}	{}	{}
217	2017-02-06 15:03:30+05:30	4803526	{"c": 0, "d": 0, "m": 4}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850309}	{}	{}	{}
218	2017-02-06 15:03:30+05:30	4804712	{"c": 81, "d": 0, "m": 0}	{"c": 3, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850317}	{"natural": {"scree": 1}}	{}	{}
219	2017-02-06 15:03:30+05:30	4902491	{"c": 25, "d": 0, "m": 0}	{"c": 2, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850312}	{"building": {"yes": 1}}	{}	{}
220	2017-02-06 15:03:30+05:30	4902496	{"c": 16, "d": 0, "m": 0}	{"c": 4, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850305}	{"building": {"yes": 1}}	{}	{}
221	2017-02-06 15:03:30+05:30	4902516	{"c": 80, "d": 0, "m": 0}	{"c": 20, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850304}	{"building": {"yes": 1}}	{}	{}
222	2017-02-06 15:03:30+05:30	5131884	{"c": 0, "d": 1, "m": 1}	{"c": 1, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45850328}	{"footway": {"crossing": 1}, "highway": {"footway": 1}, "crossing": {"zebra": 1}}	{"footway": {"sidewalk": 1}, "highway": {"footway": 1}}	{}
223	2017-02-06 15:03:30+05:30	5181167	{"c": 7, "d": 0, "m": 0}	{"c": 2, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850329}	{"amenity": {"parking": 1}}	{}	{}
224	2017-02-06 15:03:30+05:30	5181576	{"c": 11, "d": 0, "m": 1}	{"c": 3, "d": 0, "m": 6}	{"c": 0, "d": 0, "m": 1}	{45850322}	{"amenity": {"parking": 1}}	{"name": {"Wheeler Lake": 1}, "type": {"multipolygon": 1}, "waterway": {"riverbank": 1}}	{}
225	2017-02-06 15:03:30+05:30	5206783	{"c": 35, "d": 0, "m": 0}	{"c": 8, "d": 0, "m": 6}	{"c": 0, "d": 0, "m": 0}	{45850297}	{"name": {"Eastpointe RV Resort": 1}, "tourism": {"caravan_site": 1}}	{"landuse": {"grass": 1}}	{}
226	2017-02-06 15:03:30+05:30	5239832	{"c": 1100, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850319}	{}	{}	{}
227	2017-02-06 15:03:30+05:30	5268503	{"c": 4, "d": 0, "m": 0}	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850307}	{"building": {"yes": 1}}	{}	{}
228	2017-02-06 15:03:30+05:30	5268581	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850321}	{}	{"name": {"금산건강식품": 1}, "addr:street": {"GwangCheonLoad": 1}, "addr:housenumber": {"399-12": 1}}	{}
229	2017-02-06 15:03:29+05:30	8414	{"c": 1, "d": 0, "m": 0}	{"c": 1, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850352}	{"landuse": {"grass": 1}}	{"name": {"Viby": 1}, "landuse": {"residential": 1}}	{}
230	2017-02-06 15:03:29+05:30	13382	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850341}	{"name": {"Capt. Beasto Tattoo": 1}, "shop": {"tattoo": 1}, "email": {"ahoi@captbeasto.tattoo": 1}, "level": {"1": 1}, "phone": {"+49 1577 3635890": 1}, "website": {"https://www.facebook.com/captbeastotattoo": 1}}	{}	{}
231	2017-02-06 15:03:29+05:30	198366	{"c": 2, "d": 0, "m": 0}	{"c": 1, "d": 0, "m": 2}	{"c": 1, "d": 0, "m": 0}	{45850351}	{"name": {"parking2": 1}, "site": {"parking": 1}, "type": {"site": 1}}	{"access": {"private": 1}, "amenity": {"parking": 1}}	{}
232	2017-02-06 15:03:29+05:30	226708	{"c": 235, "d": 0, "m": 340}	{"c": 25, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850342}	{"source": {"BDOrtho IGN; Cadastre MàJ 2015": 1}, "highway": {"service": 1}, "service": {"driveway": 1}}	{}	{}
233	2017-02-06 15:03:29+05:30	334061	{"c": 2, "d": 0, "m": 4}	{"c": 1, "d": 0, "m": 10}	{"c": 0, "d": 0, "m": 0}	{45850343}	{"building": {"house": 1}, "addr:city": {"Boursonne": 1}, "addr:street": {"Rue Lucien Hubaut": 1}, "addr:postcode": {"60141": 1}, "addr:housenumber": {"16": 1}}	{"source": {"cadastre-dgi-fr source : Direction Générale des Impôts - Cadastre. Mise à jour : 2012": 1}, "building": {"yes": 1}, "addr:city": {"Boursonne": 1}, "addr:street": {"Rue Lucien Hubaut": 1}, "addr:postcode": {"60141": 1}, "addr:housenumber": {"5": 1}}	{}
234	2017-02-06 15:03:29+05:30	334075	{"c": 78, "d": 3, "m": 18}	{"c": 5, "d": 1, "m": 7}	{"c": 0, "d": 0, "m": 1}	{45850339}	{"landuse": {"forest": 1}}	{"type": {"multipolygon": 1}, "landuse": {"grass": 1}}	{}
235	2017-02-06 15:03:29+05:30	437941	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850353}	{}	{"name": {"bft": 1}, "shop": {"yes": 1}, "amenity": {"fuel": 1}, "website": {"http://tankstelle-heidbunge.de": 1}, "fuel:e10": {"yes": 1}, "fuel:lpg": {"yes": 1}, "addr:city": {"Kropp": 1}, "addr:place": {"Heidbunge": 1}, "addr:suburb": {"Heidbunge": 1}, "fuel:diesel": {"yes": 1}, "payment:dkv": {"yes": 1}, "payment:uta": {"yes": 1}, "addr:postcode": {"24848": 1}, "opening_hours": {"Mo-Fr 06:00-21:00; Sa 07:00-21:00; Su 08:00-21:00": 1}, "fuel:octane_95": {"yes": 1}, "addr:housenumber": {"3": 1}}	{}
236	2017-02-06 15:03:29+05:30	717069	{"c": 5, "d": 0, "m": 0}	{"c": 1, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850344}	{"highway": {"track": 1}}	{"highway": {"residential": 1}, "surface": {"asphalt": 1}}	{}
237	2017-02-06 15:03:29+05:30	1102411	{"c": 43, "d": 36, "m": 13}	{"c": 7, "d": 6, "m": 13}	{"c": 0, "d": 0, "m": 0}	{45850359}	{"highway": {"track": 1}}	{"highway": {"service": 1}, "service": {"parking_aisle": 1}}	{}
238	2017-02-06 15:03:29+05:30	1865465	{"c": 30, "d": 0, "m": 1}	{"c": 7, "d": 0, "m": 3}	{"c": 0, "d": 0, "m": 0}	{45850338}	{"highway": {"path": 1}}	{"highway": {"path": 1}}	{}
239	2017-02-06 15:03:29+05:30	1981984	{"c": 24, "d": 0, "m": 0}	{"c": 10, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850337}	{"building": {"yes": 1}}	{}	{}
240	2017-02-06 15:03:29+05:30	2075213	{"c": 58, "d": 0, "m": 2}	{"c": 14, "d": 0, "m": 3}	{"c": 0, "d": 0, "m": 0}	{45850348}	{"highway": {"tertiary": 1}}	{"name": {"北二环路": 1}, "oneway": {"yes": 1}, "highway": {"trunk": 1}}	{}
241	2017-02-06 15:03:29+05:30	2715439	{"c": 0, "d": 0, "m": 14}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850335}	{}	{}	{}
242	2017-02-06 15:03:29+05:30	2855576	{"c": 10, "d": 0, "m": 0}	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850334}	{"water": {"lake": 1}, "natural": {"water": 1}}	{}	{}
243	2017-02-06 15:03:29+05:30	3969644	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850356}	{"name": {"Playa de Torrebermeja": 1}, "natural": {"beach": 1}}	{}	{}
244	2017-02-06 15:03:29+05:30	3845071	{"c": 700, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850357}	{}	{}	{}
245	2017-02-06 15:03:29+05:30	4517122	{"c": 2000, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850336}	{}	{}	{}
246	2017-02-06 15:03:29+05:30	4749148	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850345}	{}	{"name": {"Leng Oung Waterfall": 1}}	{}
247	2017-02-06 15:03:29+05:30	4803525	{"c": 0, "d": 0, "m": 5}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850360}	{}	{}	{}
248	2017-02-06 15:03:29+05:30	4778871	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850340}	{"name": {"สหพันธมิตร": 1}, "shop": {"hardware": 1}, "name:th": {"สหพันธมิตร": 1}}	{}	{}
249	2017-02-06 15:03:29+05:30	4803526	{"c": 0, "d": 0, "m": 7}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850347}	{}	{}	{}
327	2017-02-06 15:03:27+05:30	4749148	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850407}	{"name": {"Leng Ranak Waterfall": 1}}	{}	{}
250	2017-02-06 15:03:29+05:30	4856814	{"c": 3, "d": 0, "m": 0}	{"c": 1, "d": 0, "m": 3}	{"c": 0, "d": 0, "m": 0}	{45850346}	{"highway": {"footway": 1}}	{"name": {"Stade du Collège": 1}, "leisure": {"stadium": 1}}	{}
251	2017-02-06 15:03:29+05:30	4902496	{"c": 12, "d": 0, "m": 0}	{"c": 3, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850358}	{"building": {"yes": 1}}	{}	{}
252	2017-02-06 15:03:29+05:30	5131884	{"c": 0, "d": 0, "m": 0}	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850349}	{"footway": {"crossing": 1}, "highway": {"footway": 1}, "crossing": {"zebra": 1}}	{}	{}
253	2017-02-06 15:03:29+05:30	4902543	{"c": 168, "d": 0, "m": 0}	{"c": 30, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850332}	{"building": {"yes": 1}}	{}	{}
254	2017-02-06 15:03:29+05:30	5239832	{"c": 2500, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850319}	{}	{}	{}
255	2017-02-06 15:03:29+05:30	5159385	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850361}	{"name": {"Villa Kejora": 1}, "shop": {"bookmaker": 1}, "name:en": {"Villa Kejora": 1}}	{}	{}
256	2017-02-06 15:03:29+05:30	5252054	{"c": 3, "d": 2, "m": 0}	{"c": 1, "d": 2, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850364}	{"highway": {"unclassified": 1}}	{"highway": {"residential": 1}}	{}
257	2017-02-06 15:03:29+05:30	5256067	{"c": 89, "d": 0, "m": 5}	{"c": 16, "d": 0, "m": 8}	{"c": 0, "d": 0, "m": 0}	{45850354}	{"highway": {"residential": 1}}	{"highway": {"residential": 1}}	{}
258	2017-02-06 15:03:29+05:30	5268686	{"c": 11, "d": 0, "m": 6}	{"c": 2, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850333}	{"tunnel": {"culvert": 1}, "waterway": {"drain": 1}}	{"name": {"Pöhlauer Bach": 1}, "waterway": {"stream": 1}}	{}
259	2017-02-06 15:03:29+05:30	165	{"c": 0, "d": 2, "m": 0}	{"c": 8, "d": 1, "m": 21}	{"c": 0, "d": 0, "m": 0}	{45850375}	{"name": {"County Road 24": 1}, "highway": {"track": 1}, "tiger:cfcc": {"A41": 1}, "tiger:county": {"Washington, CO": 1}, "tiger:reviewed": {"no": 1}, "tiger:name_base": {"County Road 24": 1}}	{"name": {"County Road 27": 1}, "highway": {"track": 1}, "tiger:cfcc": {"A51": 1}, "tiger:county": {"Washington, CO": 1}, "tiger:reviewed": {"no": 1}, "tiger:name_base": {"County Road 27": 1}}	{}
260	2017-02-06 15:03:29+05:30	11374	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850389}	{}	{"name": {"Strauß Familiengruft": 1}, "source": {"Bing;survey": 1}, "alt_name": {"Kaisergruft": 1}, "building": {"yes": 1}, "old_name": {"Kaiser Familiengruft": 1}, "long_name": {"Kaiser/Zwicknagl/Strauß Familiengruft": 1}}	{}
261	2017-02-06 15:03:29+05:30	39717	{"c": 241, "d": 61, "m": 6}	{"c": 9, "d": 2, "m": 13}	{"c": 0, "d": 0, "m": 0}	{45850372}	{"building": {"yes": 1}, "addr:city": {"Dortmund": 1}, "addr:street": {"Weißenburger Straße": 1}, "addr:country": {"DE": 1}, "addr:postcode": {"44143": 1}, "addr:housenumber": {"62": 1}}	{"building": {"yes": 1}}	{}
262	2017-02-06 15:03:29+05:30	45347	{"c": 106, "d": 0, "m": 1}	{"c": 1, "d": 0, "m": 2}	{"c": 1, "d": 0, "m": 0}	{45850370}	{"type": {"multipolygon": 1}, "landuse": {"forest": 1}}	{"amenity": {"place_of_worship": 1}, "building": {"yes": 1}, "religion": {"christian": 1}, "denomination": {"roman_catholic": 1}}	{}
263	2017-02-06 15:03:29+05:30	81841	{"c": 400, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850394}	{}	{}	{}
264	2017-02-06 15:03:29+05:30	213513	{"c": 0, "d": 3, "m": 1}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850387}	{}	{"source": {"Bing": 1}, "natural": {"wood": 1}, "leaf_type": {"mixed": 1}}	{}
265	2017-02-06 15:03:29+05:30	226708	{"c": 0, "d": 28, "m": 199}	{"c": 0, "d": 0, "m": 176}	{"c": 0, "d": 0, "m": 0}	{45850342}	{}	{"name": {"Zône d'activités du Comblat": 1}, "source": {"BDOrtho IGN; Cadastre MàJ 2015": 1}, "landuse": {"industrial": 1}}	{}
266	2017-02-06 15:03:29+05:30	524500	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45849320}	{}	{"fee": {"no": 1}, "name": {"Piazzale Giovanni Battista Resasco": 1}, "amenity": {"parking": 1}, "parking": {"surface": 1}, "wheelchair": {"yes": 1}}	{}
267	2017-02-06 15:03:29+05:30	550560	{"c": 1788, "d": 17, "m": 11}	{"c": 65, "d": 1, "m": 5}	{"c": 0, "d": 0, "m": 0}	{45850350}	{"highway": {"tertiary": 1}, "surface": {"unpaved": 1}}	{"highway": {"tertiary": 1}, "surface": {"unpaved": 1}}	{}
268	2017-02-06 15:03:29+05:30	728316	{"c": 1398, "d": 0, "m": 0}	{"c": 102, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850379}	{"building": {"yes": 1}}	{}	{}
269	2017-02-06 15:03:29+05:30	1204984	{"c": 0, "d": 0, "m": 0}	{"c": 2, "d": 0, "m": 18}	{"c": 0, "d": 0, "m": 2}	{45850362}	{"name": {"Banfi": 1}, "lanes": {"1": 1}, "oneway": {"no": 1}, "highway": {"unclassified": 1}, "surface": {"asphalt": 1}}	{"ref": {"R2": 1}, "name": {"Mura Bike": 1}, "type": {"route": 1}, "route": {"bicycle": 1}, "source": {"http://www.mura-drava-bike.com": 1}, "network": {"ncn": 1}, "int_name": {"R2": 1}, "wikipedia": {"de:Murradweg": 1}}	{}
270	2017-02-06 15:03:29+05:30	1302721	{"c": 84, "d": 0, "m": 0}	{"c": 11, "d": 0, "m": 4}	{"c": 0, "d": 0, "m": 0}	{45850376}	{"natural": {"wood": 1}}	{"boat": {"no": 1}, "name": {"River Welland": 1}, "source": {"survey": 1}, "waterway": {"river": 1}}	{}
271	2017-02-06 15:03:29+05:30	1748423	{"c": 0, "d": 1, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850382,45850366}	{}	{"name": {"Θέατρο Βλησίδη": 1}, "amenity": {"theatre": 1}, "building": {"yes": 1}, "addr:city": {"Χανιά": 1}, "addr:street": {"Μαριδακη": 1}}	{}
272	2017-02-06 15:03:29+05:30	1865465	{"c": 8, "d": 0, "m": 0}	{"c": 4, "d": 0, "m": 3}	{"c": 0, "d": 0, "m": 0}	{45850388}	{"highway": {"residential": 1}}	{"name": {"بلوار مادر": 1}, "oneway": {"yes": 1}, "source": {"Yahoo": 1}, "highway": {"tertiary": 1}, "name:en": {"Mother Boulevard": 1}}	{}
273	2017-02-06 15:03:29+05:30	2481418	{"c": 509, "d": 1, "m": 69}	{"c": 65, "d": 0, "m": 9}	{"c": 0, "d": 0, "m": 0}	{45850384}	{"highway": {"residential": 1}}	{"ref": {"Т-17-16": 1}, "highway": {"secondary": 1}}	{}
274	2017-02-06 15:03:29+05:30	2496484	{"c": 25, "d": 0, "m": 34}	{"c": 1, "d": 0, "m": 5}	{"c": 0, "d": 0, "m": 0}	{45850373}	{"highway": {"track": 1}}	{"name": {"Tir à l'Arc": 1}, "sport": {"archery": 1}, "source": {"cadastre-dgi-fr source : Direction Générale des Impôts - Cadastre. Mise à jour : 2010": 1}, "leisure": {"pitch": 1}}	{}
275	2017-02-06 15:03:29+05:30	2715439	{"c": 0, "d": 0, "m": 7}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850392,45850365}	{}	{}	{}
276	2017-02-06 15:03:29+05:30	2855576	{"c": 15, "d": 0, "m": 0}	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850378}	{"water": {"lake": 1}, "natural": {"water": 1}}	{}	{}
277	2017-02-06 15:03:29+05:30	2901733	{"c": 20, "d": 0, "m": 0}	{"c": 6, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850367}	{"building": {"yes": 1}}	{}	{}
278	2017-02-06 15:03:29+05:30	3023145	{"c": 9, "d": 0, "m": 1}	{"c": 2, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850390}	{"leisure": {"fitness_station": 1}}	{"name": {"Park Jana Pawła II": 1}, "landuse": {"grass": 1}, "leisure": {"park": 1}}	{}
279	2017-02-06 15:03:29+05:30	3423733	{"c": 267, "d": 0, "m": 0}	{"c": 13, "d": 0, "m": 3}	{"c": 0, "d": 0, "m": 0}	{45850363}	{"highway": {"road": 1}, "surface": {"ground": 1}}	{"ref": {"2091": 1}, "highway": {"secondary": 1}}	{}
280	2017-02-06 15:03:29+05:30	3776031	{"c": 824, "d": 0, "m": 0}	{"c": 201, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850355}	{"building": {"yes": 1}, "addr:city": {"Mariveles": 1}}	{}	{}
281	2017-02-06 15:03:29+05:30	3845071	{"c": 2500, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850357}	{}	{}	{}
282	2017-02-06 15:03:29+05:30	3885962	{"c": 24, "d": 4, "m": 0}	{"c": 3, "d": 1, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850396}	{"building": {"apartments": 1}}	{}	{}
283	2017-02-06 15:03:29+05:30	4089636	{"c": 240, "d": 0, "m": 0}	{"c": 11, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850377}	{"natural": {"scrub": 1}}	{"waterway": {"stream": 1}, "intermittent": {"yes": 1}}	{}
284	2017-02-06 15:03:29+05:30	4355402	{"c": 3, "d": 0, "m": 1}	{"c": 1, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850371}	{"oneway": {"yes": 1}, "highway": {"service": 1}, "service": {"driveway": 1}}	{"oneway": {"yes": 1}, "highway": {"service": 1}, "service": {"driveway": 1}}	{}
285	2017-02-06 15:03:29+05:30	4517122	{"c": 2500, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850336}	{}	{}	{}
286	2017-02-06 15:03:29+05:30	4803484	{"c": 5, "d": 0, "m": 7}	{"c": 0, "d": 0, "m": 3}	{"c": 0, "d": 0, "m": 0}	{45850368}	{}	{"building": {"yes": 1}}	{}
287	2017-02-06 15:03:29+05:30	4803525	{"c": 0, "d": 0, "m": 4}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850386}	{}	{}	{}
288	2017-02-06 15:03:29+05:30	4803526	{"c": 0, "d": 0, "m": 12}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850374}	{}	{}	{}
289	2017-02-06 15:03:29+05:30	4804730	{"c": 13, "d": 0, "m": 1}	{"c": 2, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850381}	{"crop": {"rice": 1}, "landuse": {"farmland": 1}}	{"waterway": {"riverbank": 1}}	{}
290	2017-02-06 15:03:29+05:30	4935702	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850383}	{"name": {"Hercegovima promet stolac podgrad": 1}, "shop": {"supermarket": 1}, "name:hr": {"Hercegovima promet stolac podgrad": 1}}	{}	{}
291	2017-02-06 15:03:29+05:30	5131884	{"c": 0, "d": 0, "m": 3}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850380}	{}	{}	{}
292	2017-02-06 15:03:29+05:30	5154864	{"c": 20, "d": 0, "m": 0}	{"c": 1, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850385}	{"highway": {"service": 1}}	{"highway": {"service": 1}}	{}
293	2017-02-06 15:03:29+05:30	5188386	{"c": 24, "d": 0, "m": 0}	{"c": 6, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850393}	{"amenity": {"parking": 1}}	{}	{}
294	2017-02-06 15:03:29+05:30	5239832	{"c": 2200, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850319}	{}	{}	{}
295	2017-02-06 15:03:29+05:30	5227092	{"c": 2300, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850369}	{}	{}	{}
296	2017-02-06 15:03:29+05:30	5268860	{"c": 3, "d": 0, "m": 5}	{"c": 0, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45850395}	{}	{"highway": {"path": 1}, "surface": {"earth": 1}}	{}
297	2017-02-06 15:03:27+05:30	60129	{"c": 215, "d": 17, "m": 84}	{"c": 49, "d": 0, "m": 11}	{"c": 1, "d": 0, "m": 1}	{45850401}	{"type": {"multipolygon": 1}, "landuse": {"residential": 1}}	{"type": {"multipolygon": 1}, "landuse": {"forest": 1}}	{}
298	2017-02-06 15:03:27+05:30	74275	{"c": 366, "d": 1, "m": 22}	{"c": 77, "d": 11, "m": 23}	{"c": 5, "d": 0, "m": 2}	{45850391}	{"type": {"multipolygon": 1}, "source": {"bing": 1}, "building": {"apartments": 1}}	{"area": {"yes": 1}, "type": {"multipolygon": 1}, "source": {"bing": 1}, "highway": {"pedestrian": 1}, "surface": {"concrete": 1}}	{}
299	2017-02-06 15:03:27+05:30	81841	{"c": 167, "d": 0, "m": 0}	{"c": 142, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850394}	{"building": {"house": 1}, "addr:city": {"Abuyog": 1}, "addr:postcode": {"6510": 1}, "addr:province": {"Leyte": 1}}	{}	{}
300	2017-02-06 15:03:27+05:30	133272	{"c": 3, "d": 1, "m": 8}	{"c": 6, "d": 1, "m": 12}	{"c": 1, "d": 0, "m": 1}	{45850418}	{"type": {"multipolygon": 1}, "building": {"yes": 1}}	{"type": {"multipolygon": 1}, "natural": {"wood": 1}}	{}
301	2017-02-06 15:03:27+05:30	139351	{"c": 147, "d": 0, "m": 8}	{"c": 28, "d": 0, "m": 6}	{"c": 2, "d": 0, "m": 0}	{45850399}	{"type": {"multipolygon": 1}, "building": {"yes": 1}, "building:levels": {"4": 1}}	{"highway": {"footway": 1}, "incline": {"up": 1}}	{}
302	2017-02-06 15:03:27+05:30	142831	{"c": 3, "d": 0, "m": 5}	{"c": 1, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850427}	{"highway": {"unclassified": 1}}	{"name": {"Kawakawa Bay Coast Road": 1}, "highway": {"unclassified": 1}}	{}
303	2017-02-06 15:03:27+05:30	198366	{"c": 2, "d": 0, "m": 1}	{"c": 1, "d": 0, "m": 3}	{"c": 2, "d": 0, "m": 0}	{45850424}	{"name": {"parking4": 1}, "site": {"parking": 1}, "type": {"site": 1}}	{"access": {"private": 1}, "amenity": {"parking": 1}}	{}
304	2017-02-06 15:03:27+05:30	213513	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850411}	{}	{"name": {"École communale": 1}, "source": {"data.gouv.fr:Ministère de l'Éducation nationale, de la Jeunesse et de la Vie associative - 05/2012": 1}, "amenity": {"school": 1}, "ref:UAI": {"0011024H": 1}, "school:FR": {"primaire": 1}}	{}
305	2017-02-06 15:03:27+05:30	334075	{"c": 27, "d": 0, "m": 0}	{"c": 3, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{45850402}	{"natural": {"water": 1}}	{"type": {"multipolygon": 1}, "landuse": {"grass": 1}}	{}
306	2017-02-06 15:03:27+05:30	524500	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45849320}	{}	{"fee": {"no": 1}, "amenity": {"parking": 1}, "maxstay": {"2": 1}, "parking": {"surface": 1}, "wheelchair": {"yes": 1}}	{}
307	2017-02-06 15:03:27+05:30	501824	{"c": 9, "d": 3, "m": 2}	{"c": 7, "d": 1, "m": 3}	{"c": 1, "d": 0, "m": 1}	{45850426}	{"type": {"multipolygon": 1}, "landuse": {"commercial": 1}}	{"name": {"Строительство игорной зоны \\"Янтарная\\"": 1}, "type": {"multipolygon": 1}, "landuse": {"construction": 1}, "source_ref": {"http://www.pravo.gov.ru/proxy/ips/?docbody=&nd=102352528": 1}, "construction": {"casino": 1}}	{}
308	2017-02-06 15:03:27+05:30	728316	{"c": 0, "d": 1, "m": 180}	{"c": 97, "d": 15, "m": 8}	{"c": 1, "d": 0, "m": 1}	{45850379}	{"name": {"きららの森・赤岩": 1}, "type": {"multipolygon": 1}, "landuse": {"recreation_ground": 1}}	{"type": {"multipolygon": 1}, "source": {"bing": 1}, "landuse": {"forest": 1}}	{}
309	2017-02-06 15:03:27+05:30	564585	{"c": 2, "d": 18, "m": 13}	{"c": 5, "d": 2, "m": 17}	{"c": 0, "d": 1, "m": 4}	{45850408}	{"lit": {"yes": 1}, "name": {"Neue Mainzer Straße": 1}, "lanes": {"2": 1}, "oneway": {"yes": 1}, "highway": {"secondary": 1}, "surface": {"asphalt": 1}, "maxspeed": {"50": 1}, "smoothness": {"good": 1}}	{"to": {"Europaviertel West": 1}, "ref": {"64": 1}, "from": {"Ginnheim [U]": 1}, "name": {"Bus 64: Ginnheim [U] => Europaviertel West": 1}, "type": {"route": 1}, "route": {"bus": 1}, "network": {"RMV": 1}, "operator": {"VGF": 1}, "public_transport:version": {"2": 1}}	{}
310	2017-02-06 15:03:27+05:30	1302721	{"c": 28, "d": 0, "m": 0}	{"c": 2, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850416}	{"natural": {"wood": 1}}	{}	{}
311	2017-02-06 15:03:27+05:30	1959254	{"c": 4, "d": 2, "m": 25}	{"c": 0, "d": 0, "m": 3}	{"c": 0, "d": 0, "m": 0}	{45850404}	{}	{"building": {"yes": 1}, "addr:city": {"Sinzig": 1}, "addr:street": {"Kuhbachweg": 1}, "addr:country": {"DE": 1}, "addr:postcode": {"53489": 1}, "addr:housenumber": {"2": 1}}	{}
312	2017-02-06 15:03:27+05:30	1981984	{"c": 65, "d": 0, "m": 0}	{"c": 22, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850397}	{"building": {"yes": 1}}	{}	{}
313	2017-02-06 15:03:27+05:30	2715439	{"c": 0, "d": 0, "m": 5}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850434,45850419}	{}	{}	{}
314	2017-02-06 15:03:27+05:30	2574748	{"c": 473, "d": 12, "m": 0}	{"c": 106, "d": 2, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850422}	{"building": {"yes": 1}}	{}	{}
315	2017-02-06 15:03:27+05:30	2734587	{"c": 115, "d": 0, "m": 6}	{"c": 1, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45850420}	{"highway": {"service": 1}}	{"highway": {"service": 1}}	{}
316	2017-02-06 15:03:27+05:30	2853561	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850421}	{}	{"name": {"улица Первомайская": 1}, "lanes": {"2": 1}, "highway": {"residential": 1}, "surface": {"asphalt": 1}, "maxspeed": {"20": 1}, "addr:street": {"улица Первомайская": 1}}	{}
317	2017-02-06 15:03:27+05:30	2855576	{"c": 44, "d": 0, "m": 0}	{"c": 1, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850429}	{"natural": {"wetland": 1}}	{"name": {"зимник": 1}, "highway": {"track": 1}}	{}
318	2017-02-06 15:03:27+05:30	3227822	{"c": 5, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850431}	{}	{"source": {"Bing": 1}, "natural": {"coastline": 1}}	{}
319	2017-02-06 15:03:27+05:30	3253957	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45850405}	{}	{"ref": {"162": 1}, "name": {"Drawska": 1}, "lanes": {"2": 1}, "highway": {"secondary": 1}, "surface": {"asphalt": 1}, "old_name:de": {"Scheunenstraße": 1}}	{}
320	2017-02-06 15:03:27+05:30	3315483	{"c": 0, "d": 1, "m": 19}	{"c": 0, "d": 0, "m": 3}	{"c": 0, "d": 0, "m": 0}	{45850430}	{}	{"name": {"八戸自動車道": 1}, "layer": {"1": 1}, "oneway": {"yes": 1}, "highway": {"motorway": 1}, "name:en": {"Hachinohe Expressway": 1}, "name:ja": {"八戸自動車道": 1}}	{}
321	2017-02-06 15:03:27+05:30	3845071	{"c": 2200, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850357}	{}	{}	{}
322	2017-02-06 15:03:27+05:30	3885962	{"c": 0, "d": 0, "m": 8}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850406}	{}	{}	{}
323	2017-02-06 15:03:27+05:30	3921624	{"c": 6, "d": 0, "m": 1}	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850410}	{"amenity": {"parking": 1}}	{"highway": {"crossing": 1}, "crossing": {"uncontrolled": 1}}	{}
324	2017-02-06 15:03:27+05:30	4222212	{"c": 400, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850433}	{}	{}	{}
325	2017-02-06 15:03:27+05:30	4464541	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850400}	{"name": {"Shorai Philippines": 1}, "shop": {"bicycle": 1}, "name:en": {"Shorai Philippines": 1}, "addr:street": {"P. Burgos": 1}}	{}	{}
326	2017-02-06 15:03:27+05:30	4517122	{"c": 2100, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850336}	{}	{}	{}
328	2017-02-06 15:03:27+05:30	4803525	{"c": 1, "d": 0, "m": 4}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850414}	{}	{"building": {"yes": 1}}	{}
329	2017-02-06 15:03:27+05:30	4803526	{"c": 2, "d": 0, "m": 9}	{"c": 0, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45850417,45850398}	{}	{"highway": {"residential": 1}}	{}
330	2017-02-06 15:03:27+05:30	4848896	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850412}	{}	{"name": {"Grljevačka": 1}, "highway": {"turning_loop": 1}}	{}
331	2017-02-06 15:03:27+05:30	4902496	{"c": 8, "d": 0, "m": 0}	{"c": 2, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850413}	{"building": {"yes": 1}}	{}	{}
332	2017-02-06 15:03:27+05:30	5227092	{"c": 800, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850369}	{}	{}	{}
333	2017-02-06 15:03:27+05:30	5175602	{"c": 66, "d": 0, "m": 0}	{"c": 10, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850403}	{"highway": {"track": 1}}	{}	{}
334	2017-02-06 15:03:27+05:30	5239832	{"c": 1238, "d": 0, "m": 0}	{"c": 62, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850319}	{"ele": {"425.5": 1}, "height": {"6.6": 1}, "building": {"house": 1}, "start_date": {"1978": 1}, "lacounty:ain": {"2810015009": 1}, "building:units": {"1": 1}, "lacounty:bld_id": {"398353982103": 1}}	{}	{}
335	2017-02-06 15:03:27+05:30	5259334	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850432}	{"name:en": {"Golden Sky Guest House": 1}, "tourism": {"guest_house": 1}, "internet_access": {"wlan": 1}}	{}	{}
336	2017-02-06 15:03:27+05:30	5262688	{"c": 0, "d": 1, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850409}	{}	{}	{}
337	2017-02-06 15:03:27+05:30	5266208	{"c": 47, "d": 0, "m": 0}	{"c": 5, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850435}	{"highway": {"road": 1}}	{"highway": {"residential": 1}}	{}
338	2017-02-06 15:03:27+05:30	5268503	{"c": 4, "d": 4, "m": 0}	{"c": 1, "d": 1, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850425}	{"building": {"yes": 1}}	{}	{}
339	2017-02-06 15:03:26+05:30	133272	{"c": 0, "d": 0, "m": 0}	{"c": 2, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850438}	{"natural": {"wood": 1}}	{"natural": {"wood": 1}}	{}
340	2017-02-06 15:03:26+05:30	35273	{"c": 22, "d": 1, "m": 1}	{"c": 2, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850239}	{"building": {"yes": 1}}	{"amenity": {"bicycle_parking": 1}, "capacity": {"49": 1}}	{}
341	2017-02-06 15:03:26+05:30	198366	{"c": 0, "d": 1, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850446}	{}	{}	{}
342	2017-02-06 15:03:26+05:30	163896	{"c": 0, "d": 0, "m": 31}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850437}	{}	{"addr:city": {"Majków": 1}, "addr:street": {"Pleśniówka": 1}, "source:addr": {"EMUiA (emuia.geoportal.gov.pl)": 1}, "addr:postcode": {"26-110": 1}, "addr:housenumber": {"72": 1}}	{}
343	2017-02-06 15:03:26+05:30	524500	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45849320}	{}	{"fee": {"no": 1}, "name": {"Piazzale Giovanni Battista Resasco": 1}, "amenity": {"parking": 1}, "parking": {"surface": 1}, "wheelchair": {"yes": 1}}	{}
344	2017-02-06 15:03:26+05:30	1164579	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850449}	{}	{"name": {"Kaufland Barbu Văcărescu": 1}, "shop": {"supermarket": 1}, "phone": {"+40372 092 601": 1}, "website": {"http://www.kaufland.ro": 1}, "building": {"commercial": 1}, "is_in:city": {"București": 1}, "addr:street": {"Strada Barbu Văcărescu": 1}, "addr:postcode": {"020284": 1}, "opening_hours": {"Mo-Sa 07:30-22:00; Su 08:00-20:00": 1}, "addr:housenumber": {"120-144": 1}}	{}
345	2017-02-06 15:03:26+05:30	1445756	{"c": 1079, "d": 0, "m": 0}	{"c": 216, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850441}	{"source": {"cadastre-dgi-fr source : Direction Générale des Finances Publiques - Cadastre. Mise à jour : 2017": 1}, "building": {"yes": 1}}	{}	{}
346	2017-02-06 15:03:26+05:30	1959254	{"c": 2, "d": 0, "m": 16}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850447}	{}	{"building": {"yes": 1}}	{}
347	2017-02-06 15:03:26+05:30	1981984	{"c": 42, "d": 4, "m": 0}	{"c": 9, "d": 1, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850448}	{"building": {"yes": 1}}	{}	{}
366	2017-02-06 15:03:26+05:30	4902516	{"c": 12, "d": 0, "m": 0}	{"c": 3, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850456}	{"building": {"yes": 1}}	{}	{}
348	2017-02-06 15:03:26+05:30	2061760	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850459}	{"name": {"Medicentrum": 1}, "amenity": {"hospital": 1}, "addr:city": {"Piešťany": 1}, "emergency": {"no": 1}, "addr:street": {"Pod Párovcami": 1}, "addr:postcode": {"92101": 1}, "addr:housenumber": {"5190/3C": 1}}	{"import": {"budovy201004": 1}, "source": {"kapor2": 1}, "building": {"hospital": 1}, "addr:city": {"Piešťany": 1}, "addr:street": {"Pod Párovcami": 1}, "addr:postcode": {"92101": 1}, "contact:email": {"medicentrum@klinika.sk": 1}, "contact:phone": {"+421337735091": 1}, "building:levels": {"2": 1}, "addr:housenumber": {"5190/3C": 1}}	{}
349	2017-02-06 15:03:26+05:30	2540799	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850445}	{}	{"name": {"Thüringer Straße": 1}, "highway": {"residential": 1}, "maxspeed": {"30": 1}, "source:maxspeed": {"DE:zone30": 1}}	{}
350	2017-02-06 15:03:26+05:30	2853561	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45850452}	{}	{"name": {"Восьмилетняя школа": 1}, "amenity": {"school": 1}}	{}
351	2017-02-06 15:03:26+05:30	3044490	{"c": 242, "d": 0, "m": 0}	{"c": 49, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850436}	{"building": {"yes": 1}}	{}	{}
352	2017-02-06 15:03:26+05:30	3217737	{"c": 362, "d": 0, "m": 0}	{"c": 50, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850450}	{"source": {"Bing": 1}, "building": {"yes": 1}}	{}	{}
353	2017-02-06 15:03:26+05:30	3845071	{"c": 1900, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850357}	{}	{}	{}
354	2017-02-06 15:03:26+05:30	3337880	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850458}	{}	{"ref": {"D 20": 1}, "name": {"Rue des Bains Romains": 1}, "highway": {"tertiary": 1}, "maxspeed": {"70": 1}}	{}
355	2017-02-06 15:03:26+05:30	3885962	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850451}	{}	{"name": {"כפר סבא": 1}, "note": {"not accurate": 1}, "place": {"city": 1}, "landuse": {"residential": 1}, "name:ar": {"كفار سابا": 1}, "name:en": {"Kfar Saba": 1}, "name:he": {"כפר סבא": 1}, "name:ru": {"Кфар-Саба": 1}, "website": {"http://www.kfar-saba.muni.il/": 1}, "wikidata": {"Q152436": 1}, "wikipedia": {"en:Kfar_Saba": 1}, "contact:website": {"http://www.kfar-saba.muni.il/": 1}}	{}
356	2017-02-06 15:03:26+05:30	4222212	{"c": 2500, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850433}	{}	{}	{}
357	2017-02-06 15:03:26+05:30	4433679	{"c": 0, "d": 1, "m": 1}	{"c": 0, "d": 0, "m": 2}	{"c": 0, "d": 0, "m": 0}	{45850051}	{}	{"lit": {"yes": 1}, "name": {"53 Avenue NW": 1}, "lanes": {"2": 1}, "oneway": {"yes": 1}, "source": {"Geobase_Import_2009": 1}, "highway": {"tertiary": 1}, "attribution": {"GeoBase®": 1}, "geobase:acquisitionTechnique": {"GPS": 1}}	{}
358	2017-02-06 15:03:26+05:30	4342700	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 38}	{"c": 0, "d": 0, "m": 0}	{45850428}	{}	{"note": {"National-Land Numerical Information (River) 2009, MLIT Japan": 1}, "source": {"KSJ2": 1}, "note:ja": {"国土数値情報(河川データ)平成21年度 国土交通省": 1}, "KSJ2:ODC": {"数値地図25000空間データ基盤": 1}, "waterway": {"stream": 1}, "source_ref": {"http://nlftp.mlit.go.jp/ksj/jpgis/datalist/KsjTmplt-W05.html": 1}}	{}
359	2017-02-06 15:03:26+05:30	4517122	{"c": 2000, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850336}	{}	{}	{}
360	2017-02-06 15:03:26+05:30	4516666	{"c": 63, "d": 0, "m": 0}	{"c": 12, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850440}	{"highway": {"unclassified": 1}}	{}	{}
361	2017-02-06 15:03:26+05:30	4778871	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850442}	{"name": {"วิบูลสิน": 1}, "shop": {"hardware": 1}, "addr:street": {"ถนนเพชรเกษม": 1}}	{}	{}
362	2017-02-06 15:03:26+05:30	4801531	{"c": 1, "d": 44, "m": 20}	{"c": 0, "d": 7, "m": 4}	{"c": 0, "d": 0, "m": 0}	{45850454}	{}	{"crop": {"rice": 1}, "landuse": {"farmland": 1}}	{}
363	2017-02-06 15:03:26+05:30	4803526	{"c": 0, "d": 0, "m": 10}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850444,45850453}	{}	{}	{}
364	2017-02-06 15:03:26+05:30	4848896	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 1}	{"c": 0, "d": 0, "m": 0}	{45850455}	{}	{"oneway": {"yes": 1}, "highway": {"residential": 1}, "junction": {"roundabout": 1}}	{}
365	2017-02-06 15:03:26+05:30	4841402	{"c": 1, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850457}	{"name:en": {"Extra hotel": 1}, "tourism": {"hotel": 1}}	{}	{}
367	2017-02-06 15:03:26+05:30	4999043	{"c": 146, "d": 3, "m": 21}	{"c": 14, "d": 0, "m": 9}	{"c": 0, "d": 0, "m": 0}	{45850439}	{"landuse": {"meadow": 1}}	{"name": {"虎溪河": 1}, "waterway": {"river": 1}}	{}
368	2017-02-06 15:03:26+05:30	5227092	{"c": 540, "d": 0, "m": 0}	{"c": 60, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850369}	{"ele": {"402.4": 1}, "building": {"house": 1}, "start_date": {"1951": 1}, "lacounty:ain": {"5610014037": 1}, "building:units": {"1": 1}, "lacounty:bld_id": {"GLEN44117": 1}}	{}	{}
369	2017-02-06 15:03:26+05:30	5239832	{"c": 0, "d": 0, "m": 0}	{"c": 400, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850319}	{"ele": {"386.3": 1}, "height": {"4.9": 1}, "building": {"house": 1}, "start_date": {"1971": 1}, "lacounty:ain": {"2811011001": 1}, "building:units": {"1": 1}, "lacounty:bld_id": {"399165981033": 1}}	{}	{}
370	2017-02-06 15:03:26+05:30	5268506	{"c": 108, "d": 0, "m": 0}	{"c": 8, "d": 0, "m": 0}	{"c": 0, "d": 0, "m": 0}	{45850443}	{"building": {"yes": 1}}	{}	{}
\.


--
-- Name: stats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sanjaybhangar
--

SELECT pg_catalog.setval('stats_id_seq', 370, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: sanjaybhangar
--

COPY users (id, name, first_edit, changeset_count, num_changes) FROM stdin;
1626	FredB	2013-04-24	5	50
3980	TomH	2013-04-24	3	30
378532	nyampire	2013-04-24	2	20
10353	gorn	2013-04-24	1	10
37548	Marcussacapuces91	2013-04-24	12	120
293774	Oli-Wan	2013-04-24	11	110
8296	kuede	2013-04-24	5 	11
344561	FahRadler	2013-04-24	1	1
207581	Hjart	2013-04-24	4	44
3188422	ansuta	2013-04-24	2	22
3099780	Armire	2013-04-24	1	400
44660	bjoern_m	2013-04-24	55	5555
1799626	AjBelnuovo	2013-04-24	1	11
651782	Cyclizine	2013-04-24	1	10
3318999	wanda987	2013-04-24	1	11
148676	nickagee	\N	0	0
485898	Víctor L	\N	0	0
597250	Ziltoidium	\N	0	0
2292368	naomiangelia	\N	0	0
3429710	\N	\N	0	0
4718866	\N	\N	0	0
4803484	Stella Lee	\N	0	0
4803527	Kate Diaz	\N	0	0
4803528	Eva Blue	\N	0	0
4905512	Михаил Гнатковский	\N	0	0
5008873	Rightful49	\N	0	0
5161593	jdbajar0	\N	0	0
5193137	루시루스	\N	0	0
5238124	\N	\N	0	0
1306	PlaneMad	\N	0	0
53073	Aaron Lidman	\N	0	0
94578	andygol	\N	0	0
146675	geohacker	\N	0	0
261012	sanjayb	\N	0	0
510836	Rub21	\N	0	0
589596	lxbarth	\N	0	0
706170	BharataHS	\N	0	0
1087876	bkowshik	\N	0	0
1240849	ediyes	\N	0	0
1597155	poornibadrinath	\N	0	0
1829683	Luis36995	\N	0	0
2015224	Jothirnadh	\N	0	0
2115749	srividya_c	\N	0	0
2219338	RichRico	\N	0	0
2226712	dannykath	\N	0	0
2306749	shvrm	\N	0	0
2477516	Arunasank	\N	0	0
2508151	ridixcr	\N	0	0
2511706	calfarome	\N	0	0
2512300	samely	\N	0	0
2554698	ruthmaben	\N	0	0
2644101	Chetan_Gowda	\N	0	0
2748195	karitotp	\N	0	0
2823295	ramyaragupathy	\N	0	0
2835928	nikhilprabhakar	\N	0	0
2847988	jinalfoflia	\N	0	0
2905914	pratikyadav	\N	0	0
2985232	aarthy	\N	0	0
3029661	saikabhi	\N	0	0
3057995	oini	\N	0	0
3272286	manings	\N	0	0
3460649	Amisha Singla	\N	0	0
3479270	nammala	\N	0	0
3526564	yurasi	\N	0	0
3572302	Maanya	\N	0	0
3769434	manoharuss	\N	0	0
3877019	piligab	\N	0	0
3878839	ajithranka	\N	0	0
4007051	upendrakarukonda	\N	0	0
4148813	Fa7C0N	\N	0	0
81841	schadow1	\N	0	0
113813	AndersAndersson	\N	0	0
198366	chene	\N	0	0
213513	ThomR	\N	0	0
362126	Зелёный Кошак	\N	0	0
672542	Nearo	\N	0	0
684298	pili-pili	\N	0	0
708145	openpablo3	\N	0	0
717069	Ventlan	\N	0	0
1771198	Commodoortje	\N	0	0
1981984	hehe1234	\N	0	0
2110714	captain_slow	\N	0	0
2855576	alexandr29	\N	0	0
2955770	Huttite	\N	0	0
3068577	Mkxd	\N	0	0
3153457	GidonW	\N	0	0
3528297	uldisz	\N	0	0
3969644	René V	\N	0	0
4048394	Дмитро Вишинський	\N	0	0
4355310	pointseven	\N	0	0
4433679	bogdanp_telenav	\N	0	0
4800002	بهزاد علي	\N	0	0
4803525	Shaun Austin	\N	0	0
4803526	Lexi Johnson	\N	0	0
4804712	Tharshika5445	\N	0	0
4902491	DenisMaja	\N	0	0
4902496	Kutlo Oduetse	\N	0	0
4902516	Pearl kgotla	\N	0	0
5131884	Wow@Osm	\N	0	0
5181167	0Geert0	\N	0	0
5181576	Kpburns	\N	0	0
5206783	BigFreaky	\N	0	0
5239832	BharataHS_laimport	\N	0	0
5268503	Javihno	\N	0	0
5268581	AhChoo	\N	0	0
8414	Björn B	\N	0	0
13382	Schramme	\N	0	0
226708	Captain47	\N	0	0
334061	Coilans	\N	0	0
334075	eggie	\N	0	0
437941	Fischkopp0815	\N	0	0
1102411	Slowianadi	\N	0	0
1865465	ezzatalla memar	\N	0	0
2075213	汤鹏程	\N	0	0
2715439	ndm000	\N	0	0
3845071	nikhil_labuildings	\N	0	0
4517122	upendra_labuilding	\N	0	0
4749148	paongquinho	\N	0	0
4778871	PalangChai Pawatavekasamesuk	\N	0	0
4856814	christian lassalle	\N	0	0
4902543	aobakwerapharing	\N	0	0
5159385	Chan Eng Kooi	\N	0	0
5252054	Ranjana Devanand	\N	0	0
5256067	SE0ULsaram	\N	0	0
5268686	josreu	\N	0	0
165	Richard	\N	0	0
11374	q_un_go	\N	0	0
39717	M_Kucha	\N	0	0
45347	eriosw	\N	0	0
524500	wheelmap_android	\N	0	0
550560	Seandebasti	\N	0	0
728316	TKE-waka	\N	0	0
1204984	north79	\N	0	0
1302721	Glucosamine	\N	0	0
1748423	Αντρέ	\N	0	0
2481418	Urii_67	\N	0	0
2496484	Sven Witte	\N	0	0
2901733	adiatmad	\N	0	0
3023145	matpis	\N	0	0
3423733	A_Ku	\N	0	0
3776031	krichicabacaba	\N	0	0
3885962	Юкатан	\N	0	0
4089636	TC Mofolo	\N	0	0
4355402	biancah_telenav	\N	0	0
4804730	leniya	\N	0	0
4935702	Blago Musa	\N	0	0
5154864	kolai	\N	0	0
5188386	JorgeFerreira	\N	0	0
5227092	Fa7C0N_imports	\N	0	0
5268860	Jonathan Zaudig	\N	0	0
60129	Tomas Straupis	\N	0	0
74275	balcoath	\N	0	0
133272	wongataa	\N	0	0
139351	Civitas	\N	0	0
142831	Rudy355	\N	0	0
501824	i29	\N	0	0
564585	wegavision	\N	0	0
1959254	maphnsj	\N	0	0
2574748	tasauf1980	\N	0	0
2734587	part0s	\N	0	0
2853561	Владимир К	\N	0	0
3227822	Paweł OSM	\N	0	0
3253957	Dawid | Yanosik	\N	0	0
3315483	8dirfriend	\N	0	0
3921624	Sovetchanin	\N	0	0
4222212	nammala_labuildings	\N	0	0
4464541	Lorenzo Adriel Chuidian	\N	0	0
4848896	judith92	\N	0	0
5175602	Maggie in Leith	\N	0	0
5259334	Tzvi  W	\N	0	0
5262688	Hyun-Chul Jung	\N	0	0
5266208	jacbarcam	\N	0	0
35273	Ernst Poulsen	\N	0	0
163896	Zbigniew_Czernik	\N	0	0
1164579	dincaionclaudiu	\N	0	0
1445756	agab29	\N	0	0
2061760	Pmts03	\N	0	0
2540799	Athalis	\N	0	0
3044490	Hawa Adinani	\N	0	0
3217737	mmahmud	\N	0	0
3337880	Anthony2015	\N	0	0
4342700	Hokko-sha	\N	0	0
4516666	KALUBA MICHEAL	\N	0	0
4801531	kirisha mv	\N	0	0
4841402	Olga Pakina	\N	0	0
4999043	一米阳光	\N	0	0
5268506	Mokgosi	\N	0	0
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
-- Name: stats_pkey; Type: CONSTRAINT; Schema: public; Owner: sanjaybhangar; Tablespace: 
--

ALTER TABLE ONLY stats
    ADD CONSTRAINT stats_pkey PRIMARY KEY (id);


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
-- Name: stats_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sanjaybhangar
--

ALTER TABLE ONLY stats
    ADD CONSTRAINT stats_uid_fkey FOREIGN KEY (uid) REFERENCES users(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: sanjaybhangar
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--


