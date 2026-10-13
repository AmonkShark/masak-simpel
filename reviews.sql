-- ===== Masak Simpel: Rating, komentar & foto hasil masakan =====
create table if not exists public.reviews (
  id bigserial primary key,
  recipe_key text not null check (char_length(recipe_key) between 1 and 80),
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  author text not null check (char_length(author) between 1 and 40),
  stars int not null check (stars between 1 and 5),
  body text check (body is null or char_length(body) <= 500),
  photo text check (photo is null or (char_length(photo) <= 300000 and photo like 'data:image/jpeg;base64,%')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (recipe_key, user_id)
);
create index if not exists reviews_key_idx on public.reviews (recipe_key, created_at desc);

create or replace function public.limit_reviews() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if (select count(*) from reviews where user_id = new.user_id and created_at > now() - interval '1 day') >= 20 then
    raise exception 'Batas 20 ulasan per hari tercapai. Coba lagi besok.';
  end if;
  return new;
end $$;
drop trigger if exists reviews_limit on public.reviews;
create trigger reviews_limit before insert on public.reviews
for each row execute function public.limit_reviews();

drop trigger if exists reviews_touch on public.reviews;
create trigger reviews_touch before update on public.reviews
for each row execute function public.touch_updated();

alter table public.reviews enable row level security;
revoke all on public.reviews from anon, authenticated;
grant select on public.reviews to anon, authenticated;
grant insert (recipe_key, author, stars, body, photo) on public.reviews to authenticated;
grant update (author, stars, body, photo) on public.reviews to authenticated;
grant delete on public.reviews to authenticated;
grant usage, select on sequence public.reviews_id_seq to authenticated;

drop policy if exists "lihat ulasan" on public.reviews;
create policy "lihat ulasan" on public.reviews for select using (true);
drop policy if exists "tulis ulasan" on public.reviews;
create policy "tulis ulasan" on public.reviews for insert to authenticated
  with check (user_id = auth.uid() and coalesce((auth.jwt()->>'is_anonymous')::boolean, false) = false);
drop policy if exists "ubah ulasan" on public.reviews;
create policy "ubah ulasan" on public.reviews for update to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());
drop policy if exists "hapus ulasan" on public.reviews;
create policy "hapus ulasan" on public.reviews for delete to authenticated
  using (user_id = auth.uid() or auth.jwt()->>'email' = 'amonkpubg@gmail.com');
