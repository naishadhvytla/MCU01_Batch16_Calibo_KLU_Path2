-- ============================================================
--  Clarity — Supabase backend schema
--  Run this once in your Supabase project:
--  Dashboard -> SQL Editor -> New query -> paste all -> Run
-- ============================================================

-- ---------- PROFILES (one row per user) ----------
create table if not exists public.profiles (
  id          uuid primary key references auth.users on delete cascade,
  full_name   text,
  team        text,
  created_at  timestamptz not null default now()
);

alter table public.profiles enable row level security;

drop policy if exists "profiles are self-service" on public.profiles;
create policy "profiles are self-service"
  on public.profiles for all
  using  (auth.uid() = id)
  with check (auth.uid() = id);

-- ---------- ANALYSES (max 2 per user) ----------
create table if not exists public.analyses (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references auth.users on delete cascade,
  name          text not null,
  dataset_name  text,
  rows          integer,
  cols          integer,
  quality       integer,
  report        jsonb,             -- SSOT report model + profile summary + sample rows
  created_at    timestamptz not null default now()
);

alter table public.analyses enable row level security;

drop policy if exists "analyses are private" on public.analyses;
create policy "analyses are private"
  on public.analyses for all
  using  (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create index if not exists analyses_user_idx on public.analyses(user_id, created_at desc);

-- ---------- HARD LIMIT: 2 saved analyses per user ----------
-- Enforced in the database, so the cap holds even if the UI is bypassed.
create or replace function public.enforce_analysis_limit()
returns trigger
language plpgsql
as $$
begin
  if (select count(*) from public.analyses where user_id = new.user_id) >= 2 then
    raise exception 'ANALYSIS_LIMIT_REACHED'
      using hint = 'Delete an existing analysis before saving a new one.';
  end if;
  return new;
end;
$$;

drop trigger if exists trg_analysis_limit on public.analyses;
create trigger trg_analysis_limit
  before insert on public.analyses
  for each row execute function public.enforce_analysis_limit();

-- ---------- AUTO-CREATE PROFILE ON SIGNUP ----------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, team)
  values (new.id,
          coalesce(new.raw_user_meta_data->>'full_name',''),
          coalesce(new.raw_user_meta_data->>'team',''));
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ============================================================
--  STORAGE — full dataset files (added for "delete to free space")
-- ============================================================

-- column to link an analysis row to its stored file
alter table public.analyses add column if not exists storage_path text;

-- private bucket for user datasets
insert into storage.buckets (id, name, public)
values ('datasets','datasets', false)
on conflict (id) do nothing;

-- users may only touch files under their own folder:  {user_id}/{file}.csv
drop policy if exists "datasets read own"   on storage.objects;
drop policy if exists "datasets insert own" on storage.objects;
drop policy if exists "datasets delete own" on storage.objects;

create policy "datasets read own" on storage.objects for select
  using (bucket_id='datasets' and auth.uid()::text = (storage.foldername(name))[1]);
create policy "datasets insert own" on storage.objects for insert
  with check (bucket_id='datasets' and auth.uid()::text = (storage.foldername(name))[1]);
create policy "datasets delete own" on storage.objects for delete
  using (bucket_id='datasets' and auth.uid()::text = (storage.foldername(name))[1]);
