-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.education (
  education_id integer NOT NULL DEFAULT nextval('education_education_id_seq'::regclass),
  title character varying NOT NULL,
  image character varying,
  body text NOT NULL,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT education_pkey PRIMARY KEY (education_id)
);
CREATE TABLE public.reports (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  user_id uuid DEFAULT auth.uid(),
  description text,
  image_url text,
  title text,
  points integer NOT NULL DEFAULT 0,
  trashbin_id integer,
  CONSTRAINT reports_pkey PRIMARY KEY (id),
  CONSTRAINT reports_trashbin_id_fkey FOREIGN KEY (trashbin_id) REFERENCES public.trashbin(bin_id)
);
CREATE TABLE public.trashbin (
  bin_id integer NOT NULL DEFAULT nextval('trashbin_bin_id_seq'::regclass),
  location_name character varying NOT NULL,
  latitude numeric NOT NULL,
  longitude numeric NOT NULL,
  capacity character varying NOT NULL,
  type character varying NOT NULL,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT trashbin_pkey PRIMARY KEY (bin_id)
);
CREATE TABLE public.user_profiles (
  id uuid NOT NULL,
  total_reports integer DEFAULT 0,
  total_points integer DEFAULT 0,
  name text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT user_profiles_pkey PRIMARY KEY (id),
  CONSTRAINT user_profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);