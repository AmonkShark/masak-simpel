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
    'daftar_hari_ini', (select count(*) from auth.users where not is_anonymous and created_at::date = current_date),
    'login_hari_ini', (select count(*) from auth.users where not is_anonymous and last_sign_in_at::date = current_date),
    'login_7', (select count(*) from auth.users where not is_anonymous and last_sign_in_at > now() - interval '7 days'),
    'tanpa_login', (select count(*) from auth.users where is_anonymous),
    'resep',    (select count(*) from recipes),
    'resep_disembunyikan', (select count(*) from recipes where hidden),
    'ulasan',   (select count(*) from reviews),
    'suka',     (select count(*) from likes),
    'masukan_baru', (select count(*) from feedback where coalesce(status,'baru') = 'baru'),
    'harian', (select coalesce(json_agg(json_build_object('d', d::text, 'n', n, 'g', g) order by d), '[]'::json) from (
        select x::date d,
          (select count(*) from visits v where v.day = x::date) n,
          (select count(*) from auth.users u where not u.is_anonymous and u.created_at::date = x::date) g
        from generate_series(current_date - 13, current_date, interval '1 day') x) t),
    'terbaru', (select coalesce(json_agg(u), '[]'::json) from (
        select coalesce(raw_user_meta_data->>'full_name', raw_user_meta_data->>'name', split_part(email,'@',1)) as nama,
               email, created_at, last_sign_in_at
        from auth.users where not is_anonymous order by created_at desc limit 20) u)
  ) into res;
  return res;
end $$;
revoke all on function public.admin_stats() from public, anon;
grant execute on function public.admin_stats() to authenticated;
