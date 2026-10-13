-- ===== Masak Simpel: statistik pengunjung =====
create table if not exists public.visits (
  device text not null check (char_length(device) between 8 and 40),
  day date not null default current_date,
  primary key (device, day)
);
alter table public.visits enable row level security;
revoke all on public.visits from anon, authenticated;
grant insert (device) on public.visits to anon, authenticated;
drop policy if exists "catat kunjungan" on public.visits;
create policy "catat kunjungan" on public.visits for insert to anon, authenticated
  with check (day = current_date);

create or replace function public.admin_stats() returns json
language plpgsql security definer set search_path = public, auth as $$
declare res json;
begin
  if coalesce(auth.jwt()->>'email','') <> 'amonkpubg@gmail.com' then
    raise exception 'Khusus admin';
  end if;
  select json_build_object(
    'hari_ini', (select count(*) from visits where day = current_date),
    'minggu',   (select count(distinct device) from visits where day > current_date - 7),
    'bulan',    (select count(distinct device) from visits where day > current_date - 30),
    'total_hp', (select count(distinct device) from visits),
    'google',   (select count(*) from auth.users where not is_anonymous),
    'google_baru_7', (select count(*) from auth.users where not is_anonymous and created_at > now() - interval '7 days'),
    'tanpa_login', (select count(*) from auth.users where is_anonymous),
    'resep',    (select count(*) from recipes),
    'resep_disembunyikan', (select count(*) from recipes where hidden),
    'ulasan',   (select count(*) from reviews),
    'suka',     (select count(*) from likes),
    'masukan_baru', (select count(*) from feedback where coalesce(status,'baru') = 'baru'),
    'harian', (select coalesce(json_agg(json_build_object('d', d::text, 'n', n) order by d), '[]'::json) from (
        select g::date d, (select count(*) from visits v where v.day = g::date) n
        from generate_series(current_date - 13, current_date, interval '1 day') g) x)
  ) into res;
  return res;
end $$;
revoke all on function public.admin_stats() from public, anon;
grant execute on function public.admin_stats() to authenticated;
