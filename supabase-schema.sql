-- 攒小米 · 云端数据库初始化脚本
-- 用法：Supabase 控制台 → 左侧 SQL Editor → New query → 整段粘贴 → Run
-- 这个脚本可以重复运行，不会重复建表或报错。

-- 1. 记录表
create table if not exists public.entries (
  id text primary key,
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  title text not null default '',
  category text not null default 'life',
  entry_date text not null default '',
  content text not null default '',
  tags jsonb not null default '[]'::jsonb,
  favorite boolean not null default false,
  updated_at bigint not null default 0,
  created_at timestamptz not null default now()
);

-- 2. 「再想想」清单表
create table if not exists public.explorations (
  id text primary key,
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  text text not null default '',
  updated_at bigint not null default 0,
  created_at timestamptz not null default now()
);

create index if not exists entries_user_idx on public.entries (user_id, updated_at desc);
create index if not exists explorations_user_idx on public.explorations (user_id, updated_at desc);

-- 3. 打开行级安全：每个人只能读写自己的数据
alter table public.entries enable row level security;
alter table public.explorations enable row level security;

drop policy if exists "own entries" on public.entries;
create policy "own entries" on public.entries
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "own explorations" on public.explorations;
create policy "own explorations" on public.explorations
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- 4. 打开实时推送，这样一台电脑上的改动会立刻出现在另一台电脑上
alter table public.entries replica identity full;
alter table public.explorations replica identity full;

do $$
begin
  begin
    alter publication supabase_realtime add table public.entries;
  exception
    when duplicate_object then null;
  end;
  begin
    alter publication supabase_realtime add table public.explorations;
  exception
    when duplicate_object then null;
  end;
end $$;
