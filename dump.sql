--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: file_fdw; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS file_fdw WITH SCHEMA public;


--
-- Name: EXTENSION file_fdw; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION file_fdw IS 'foreign-data wrapper for flat file access';


--
-- Name: calc_hash(); Type: FUNCTION; Schema: public; Owner: user2
--

CREATE FUNCTION public.calc_hash() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.pass = md5(NEW.pass);
  RETURN NEW;
END
$$;


ALTER FUNCTION public.calc_hash() OWNER TO user2;

--
-- Name: calc_sum(); Type: FUNCTION; Schema: public; Owner: user2
--

CREATE FUNCTION public.calc_sum() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.s = NEW.a + NEW.b;
  RETURN NEW;
END
$$;


ALTER FUNCTION public.calc_sum() OWNER TO user2;

--
-- Name: kmeans_classify(); Type: FUNCTION; Schema: public; Owner: user2
--

CREATE FUNCTION public.kmeans_classify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    d0 FLOAT;  -- distance from sample to each of the clusters
    d1 FLOAT;

    -- "learned" cluster centers
    cx0 FLOAT = 8.0; -- class "0" cluster center
    cy0 FLOAT = 7.4;

    cx1 FLOAT = 2.6; -- class "1" cluster center 
    cy1 FLOAT = 1.6;
BEGIN
    -- compute distances
    d0 = sqrt((cx0 - NEW.x) * (cx0 - NEW.x) + (cy0 - NEW.y) * (cy0 - NEW.y));
    d1 = sqrt((cx1 - NEW.x) * (cx1 - NEW.x) + (cy1 - NEW.y) * (cy1 - NEW.y));

    IF d0 < d1 THEN --pick nearest cluster
       NEW.z = 0;
    ELSE
       NEW.z = 1;
    END IF;
    RETURN NEW;
END
$$;


ALTER FUNCTION public.kmeans_classify() OWNER TO user2;

--
-- Name: log_event(); Type: FUNCTION; Schema: public; Owner: user2
--

CREATE FUNCTION public.log_event() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO logs (evt) VALUES (concat('account "', OLD.usr, '" deleted'));
  RETURN OLD;
END
$$;


ALTER FUNCTION public.log_event() OWNER TO user2;

--
-- Name: log_eventt(); Type: FUNCTION; Schema: public; Owner: user2
--

CREATE FUNCTION public.log_eventt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF OLD.usr = 'admin' THEN
    INSERT INTO logs (evt) VALUES ('an attempt to delete admin account!');
    RAISE NOTICE 'this will be reported!';
    RETURN NULL;
  END IF;
  INSERT INTO logs (evt) VALUES (concat('account "', OLD.usr, '" deleted'));
  RETURN OLD;
END
$$;


ALTER FUNCTION public.log_eventt() OWNER TO user2;

--
-- Name: solve_equation(); Type: FUNCTION; Schema: public; Owner: user2
--

CREATE FUNCTION public.solve_equation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    d FLOAT;
BEGIN
    d = NEW.b * NEW.b - 4.0 * NEW.a * NEW.c;
    IF d < 0.0 THEN
        RETURN NEW;
    END IF;
    IF d > 0.0 THEN
        NEW.x0 = (-NEW.b - sqrt(d)) / (2.0 * NEW.a);
        NEW.x1 = (-NEW.b + sqrt(d)) / (2.0 * NEW.a);
        RETURN NEW;
    END IF;
    NEW.x0 = -NEW.b / (2.0 * NEW.a);
    RETURN NEW;
END
$$;


ALTER FUNCTION public.solve_equation() OWNER TO user2;

--
-- Name: solve_equationn(); Type: FUNCTION; Schema: public; Owner: user2
--

CREATE FUNCTION public.solve_equationn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    d FLOAT;
BEGIN
    IF TG_OP = 'DELETE' THEN
       INSERT INTO logs (evt) VALUES ('equation deleted');
       RETURN OLD;
    END IF;

    d = NEW.b * NEW.b - 4.0 * NEW.a * NEW.c;
    IF d < 0.0 THEN
        RETURN NEW;
    END IF;
    IF d > 0.0 THEN
        NEW.x0 = (-NEW.b - sqrt(d)) / (2.0 * NEW.a);
        NEW.x1 = (-NEW.b + sqrt(d)) / (2.0 * NEW.a);
        RETURN NEW;
    END IF;
    NEW.x0 = -NEW.b / (2.0 * NEW.a);
    RETURN NEW;
END
$$;


ALTER FUNCTION public.solve_equationn() OWNER TO user2;

--
-- Name: file_srv; Type: SERVER; Schema: -; Owner: user2
--

CREATE SERVER file_srv FOREIGN DATA WRAPPER file_fdw;


ALTER SERVER file_srv OWNER TO user2;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accs; Type: TABLE; Schema: public; Owner: user2
--

CREATE TABLE public.accs (
    usr character varying(10),
    pass character varying(50)
);


ALTER TABLE public.accs OWNER TO user2;

--
-- Name: kmeans_test; Type: TABLE; Schema: public; Owner: user2
--

CREATE TABLE public.kmeans_test (
    x double precision,
    y double precision,
    z integer
);


ALTER TABLE public.kmeans_test OWNER TO user2;

--
-- Name: logs; Type: TABLE; Schema: public; Owner: user2
--

CREATE TABLE public.logs (
    ts timestamp without time zone DEFAULT now(),
    evt character varying(100)
);


ALTER TABLE public.logs OWNER TO user2;

--
-- Name: quads; Type: TABLE; Schema: public; Owner: user2
--

CREATE TABLE public.quads (
    a double precision,
    b double precision,
    c double precision,
    x0 double precision,
    x1 double precision
);


ALTER TABLE public.quads OWNER TO user2;

--
-- Name: sums; Type: TABLE; Schema: public; Owner: user2
--

CREATE TABLE public.sums (
    a integer,
    b integer,
    s integer,
    u integer
);


ALTER TABLE public.sums OWNER TO user2;

--
-- Name: synth_data; Type: FOREIGN TABLE; Schema: public; Owner: user2
--

CREATE FOREIGN TABLE public.synth_data (
    x double precision,
    y double precision,
    z integer
)
SERVER file_srv
OPTIONS (
    filename '/home/postgres/pr29/synth_data.csv',
    format 'csv'
);


ALTER FOREIGN TABLE public.synth_data OWNER TO user2;

--
-- Data for Name: accs; Type: TABLE DATA; Schema: public; Owner: user2
--

COPY public.accs (usr, pass) FROM stdin;
\.


--
-- Data for Name: kmeans_test; Type: TABLE DATA; Schema: public; Owner: user2
--

COPY public.kmeans_test (x, y, z) FROM stdin;
9.244424183207549	7.569555579383405	0
8.543813594491603	9.864162902964395	0
9.883017671360115	3.35837676591737	0
9.691690492892313	1.5820463049498557	0
1.5554917914363742	4.750378154577959	1
7.099006514018349	7.129781678523912	0
3.167425781816924	2.7423393551059405	1
6.80403338258909	0.04439848967443538	1
1.2008047647654863	6.637522942950795	1
3.3873776687299184	7.616348177477121	0
3.503678041419569	0.4971775069903117	1
8.454305688077817	9.828720076823672	0
4.197736623202708	2.9283154701326453	1
8.059333465411207	5.406227072909999	0
6.909785055352877	7.845326050385069	0
7.996605187859949	4.0723405994534545	0
2.5170379715624236	8.387089259758795	0
8.120680070333428	4.154191470049469	0
0.1183352098381718	6.067535219726921	1
8.427784872699213	8.256739323581925	0
1.8338188436161218	2.9645599298626735	1
7.675570570451775	2.09438979516797	1
9.905679263903444	1.9446295857578377	0
9.039390013130308	9.37009551874688	0
8.31483361277126	1.8692962283563475	0
0.41579193257671676	9.38565535111401	0
6.416676540884971	4.882473544435726	0
0.2412585112693577	0.8153164049547712	1
2.8884185669346962	7.337198652129189	0
3.3794020144251746	0.6470262152499373	1
9.307329379816629	5.947499321103891	0
8.057333853332374	8.967168264302572	0
1.9610103702169468	5.26091191929595	1
0.8474300064578344	9.21698378057819	0
1.8264606318631493	0.6124190719505407	1
6.171193104267978	7.370026830553726	0
8.124251759133507	4.069613189125505	0
3.1555568084088392	8.664058865837276	0
3.3189171119535743	6.39650828978958	0
1.3382455109106317	4.968153694949464	1
3.039268945959499	0.2906335491815071	1
7.668394969414116	1.3830949453487307	1
5.0566100407711545	3.7821133461939382	1
7.4835104050606205	5.47329609153671	0
7.389783326893884	5.077885914206206	0
8.197190945644586	3.7305986743962904	0
7.790031637255943	3.7988016270126934	0
4.8683362228970495	5.9997980502938475	0
9.5632982176895	8.658088106278683	0
4.737475554350503	2.084248510918556	1
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: user2
--

COPY public.logs (ts, evt) FROM stdin;
2022-12-20 22:40:42.859847	account "test" deleted
2022-12-20 22:44:14.629432	account "abc" deleted
2022-12-20 22:44:31.605064	account "admin" deleted
\.


--
-- Data for Name: quads; Type: TABLE DATA; Schema: public; Owner: user2
--

COPY public.quads (a, b, c, x0, x1) FROM stdin;
1	2	3	\N	\N
2	4	2	-1	\N
1	4	3	-3	-1
\.


--
-- Data for Name: sums; Type: TABLE DATA; Schema: public; Owner: user2
--

COPY public.sums (a, b, s, u) FROM stdin;
1	2	3	\N
3	4	7	\N
7	8	15	\N
11	12	23	\N
5	6	11	\N
9	10	19	0
13	14	27	0
17	18	\N	\N
119	120	239	\N
\.


--
-- Name: logs log_protect; Type: RULE; Schema: public; Owner: user2
--

CREATE RULE log_protect AS
    ON DELETE TO public.logs DO INSTEAD NOTHING;


--
-- Name: kmeans_test kmeans_predict; Type: TRIGGER; Schema: public; Owner: user2
--

CREATE TRIGGER kmeans_predict BEFORE INSERT ON public.kmeans_test FOR EACH ROW EXECUTE FUNCTION public.kmeans_classify();


--
-- Name: quads quad_roots; Type: TRIGGER; Schema: public; Owner: user2
--

CREATE TRIGGER quad_roots BEFORE INSERT OR DELETE ON public.quads FOR EACH ROW EXECUTE FUNCTION public.solve_equation();


--
-- Name: accs tg_log; Type: TRIGGER; Schema: public; Owner: user2
--

CREATE TRIGGER tg_log BEFORE DELETE ON public.accs FOR EACH ROW EXECUTE FUNCTION public.log_event();


--
-- Name: sums tg_sum; Type: TRIGGER; Schema: public; Owner: user2
--

CREATE TRIGGER tg_sum BEFORE INSERT OR UPDATE ON public.sums FOR EACH ROW WHEN ((new.a > 100)) EXECUTE FUNCTION public.calc_sum();


--
-- PostgreSQL database dump complete
--

