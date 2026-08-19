# 部署与云同步设置

这个练习本是**单个 HTML 文件**，没有依赖，可以直接双击打开。
但要实现**多设备自动同步进度**，需要把它放到网页服务器上（浏览器沙箱里禁止联网）。

## 一、部署到 GitHub Pages（一次性，约 2 分钟）

仓库里已经有部署流程 `.github/workflows/pages.yml`，只需要开一个开关：

1. 打开仓库 → **Settings** → 左侧 **Pages**
2. **Source** 选 **GitHub Actions**
3. 回到 **Actions** 标签，找到 `Deploy practice book to Pages`，点 **Run workflow**

完成后网址是：`https://tech-messager.github.io/leo-vibe-starter/`

以后只要 `naplan-year3/interactive/index.html` 有改动并推送，就会自动重新部署。

## 二、开启云同步（一次性，约 5 分钟）

进度默认存在浏览器本地（localStorage），换设备就看不到。开启云同步后，
**任何设备、任何浏览器**打开都是同一份进度。

### 1. 注册 Supabase

打开 [supabase.com](https://supabase.com)，用邮箱免费注册（不需要信用卡）。
新建一个 project，名字随意，区域建议选 **Sydney**（离澳洲最近，最快）。

### 2. 建表

左侧菜单进 **SQL Editor**，粘贴下面这段，点 **Run**：

```sql
create table progress (
  code text primary key,
  data jsonb,
  updated_at timestamptz default now()
);
alter table progress enable row level security;
create policy anon_all on progress for all
  to anon using (true) with check (true);
```

### 3. 拿到网址和密钥

**Project Settings → API**，复制两样东西：

- **Project URL**（形如 `https://xxxx.supabase.co`）
- **anon public** 那一串密钥（很长，以 `eyJ` 开头）

### 4. 在应用里填上

打开部署好的网址 → **备份** 标签 → 云同步区域，
填入上面两项，再自己起一个**同步码**（例如 `chloe-8f3k2`，别人猜不到即可），
点「连接并开启」。

### 5. 其他设备

在第一台设备的备份页点「复制连接码」，把那串码发给自己；
在新设备上打开同一网址 → 备份 → 粘贴 → 「用连接码开启」。**只需粘一次。**

## 安全说明

- anon key 是设计成可以放在前端的，但配合 RLS 策略后，
  **知道网址+密钥+同步码的人可以读写这一行数据**。
- 同步码请起得随机一些，不要用 `chloe` 这种一猜就中的。
- 这里只存学习进度（做对几题、金币、装扮），不含任何个人身份信息。
- 如果不想用云同步，可以完全不配置，应用照常工作，用备份码手动搬运即可。

## 数据结构

云端只有一张表一行数据：

| 列 | 说明 |
|---|---|
| `code` | 同步码，主键 |
| `data` | 全部进度的 JSON |
| `updated_at` | 最后更新时间，用于判断哪一端更新 |

冲突处理：打开页面时比较两端时间戳，取较新的一份；
云端有内容而本机为空时，一律采用云端（防止空进度覆盖已有记录）。
