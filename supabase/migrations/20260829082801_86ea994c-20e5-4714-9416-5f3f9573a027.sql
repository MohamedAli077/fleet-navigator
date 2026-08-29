CREATE TABLE public.trip_assignments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id text NOT NULL,
  trip_code text NOT NULL,
  route_number text NOT NULL,
  origin text,
  destination text,
  depot text NOT NULL,
  start_min integer NOT NULL,
  end_min integer NOT NULL,
  bus_id uuid REFERENCES public.buses(id) ON DELETE SET NULL,
  bus_label text,
  driver_id uuid REFERENCES public.crew(id) ON DELETE SET NULL,
  driver_name text,
  conductor_id uuid REFERENCES public.crew(id) ON DELETE SET NULL,
  conductor_name text,
  delay_min integer NOT NULL DEFAULT 0,
  same_depot boolean NOT NULL DEFAULT true,
  source text NOT NULL DEFAULT 'AUTO_ASSIGN',
  disruption_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (trip_id)
);

CREATE INDEX trip_assignments_route_idx ON public.trip_assignments (route_number, start_min);

CREATE TABLE public.disruptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reference text NOT NULL,
  route_number text NOT NULL,
  disruption_type text NOT NULL,
  severity text NOT NULL,
  start_min integer NOT NULL,
  duration_min integer NOT NULL,
  location text,
  description text,
  status text NOT NULL DEFAULT 'ACTIVE',
  affected_trips integer NOT NULL DEFAULT 0,
  affected_bus_ids uuid[] NOT NULL DEFAULT '{}',
  affected_crew_ids uuid[] NOT NULL DEFAULT '{}',
  recovered_trips integer NOT NULL DEFAULT 0,
  unrecovered_trips integer NOT NULL DEFAULT 0,
  recovery_rate_pct integer NOT NULL DEFAULT 0,
  added_delay_min integer NOT NULL DEFAULT 0,
  passengers_impacted integer NOT NULL DEFAULT 0,
  impact jsonb NOT NULL DEFAULT '{}'::jsonb,
  resolved_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX disruptions_status_idx ON public.disruptions (status, created_at DESC);

CREATE TABLE public.scenarios (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  label text NOT NULL,
  input jsonb NOT NULL DEFAULT '{}'::jsonb,
  result jsonb NOT NULL DEFAULT '{}'::jsonb,
  applied boolean NOT NULL DEFAULT false,
  applied_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX scenarios_created_idx ON public.scenarios (created_at DESC);

GRANT SELECT, INSERT, UPDATE, DELETE ON public.trip_assignments TO anon, authenticated;
GRANT ALL ON public.trip_assignments TO service_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.disruptions TO anon, authenticated;
GRANT ALL ON public.disruptions TO service_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.scenarios TO anon, authenticated;
GRANT ALL ON public.scenarios TO service_role;

ALTER TABLE public.trip_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.disruptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.scenarios ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Assignments are readable" ON public.trip_assignments FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Assignments can be written" ON public.trip_assignments FOR INSERT TO anon, authenticated WITH CHECK (true);
CREATE POLICY "Assignments can be updated" ON public.trip_assignments FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Assignments can be cleared" ON public.trip_assignments FOR DELETE TO anon, authenticated USING (true);

CREATE POLICY "Disruptions are readable" ON public.disruptions FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Disruptions can be raised" ON public.disruptions FOR INSERT TO anon, authenticated WITH CHECK (true);
CREATE POLICY "Disruptions can be updated" ON public.disruptions FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Disruptions can be deleted" ON public.disruptions FOR DELETE TO anon, authenticated USING (true);

CREATE POLICY "Scenarios are readable" ON public.scenarios FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Scenarios can be created" ON public.scenarios FOR INSERT TO anon, authenticated WITH CHECK (true);
CREATE POLICY "Scenarios can be updated" ON public.scenarios FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Scenarios can be deleted" ON public.scenarios FOR DELETE TO anon, authenticated USING (true);

CREATE TRIGGER trip_assignments_set_updated_at BEFORE UPDATE ON public.trip_assignments
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER disruptions_set_updated_at BEFORE UPDATE ON public.disruptions
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER scenarios_set_updated_at BEFORE UPDATE ON public.scenarios
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();