# 攒小米 · 日常记录

一个只做一件事的小网站：把日常的想法写下来，按主题收好，以后方便回看。
纯文字、无广告、无多余功能，主题色是安静的绿色，支持夜间模式。

部署方式：网页放在 GitHub Pages（免费），记录存在 Supabase（免费），
在任何一台电脑打开同一个网址、登录同一个账号，看到的都是同一份记录。

## 文件说明

| 文件 | 作用 |
| --- | --- |
| `index.html` | 整个网站，所有功能都在里面 |
| `supabase-schema.sql` | 云端数据库初始化脚本，跑一次即可 |
| `brand-rice-ear.png` | 品牌小图（已经内嵌进网页，留着备用） |

---

## 上线步骤（大约 20 分钟，只需做一次）

### 第一步：建云端数据库（Supabase）

1. 打开 [supabase.com](https://supabase.com) 注册，可以用 GitHub 账号直接登录。
2. 点 **New project**：名字随便起（例如 `zanxiaomi`），
   **Region 选 Singapore 或 Tokyo**（离国内近，速度快），数据库密码自己设一个并记下来。
3. 等 1~2 分钟，项目创建完成。
4. 左侧 **SQL Editor** → **New query** → 把 `supabase-schema.sql` 的内容整段粘贴进去 → 点 **Run**。
   看到 Success 就说明表建好了。
5. 左侧 **Authentication → Providers → Email**：把 **Confirm email** 关掉。
   关掉之后注册完立刻就能用，不用去邮箱点确认链接。
6. 左侧 **Project Settings → API**：复制两个值备用
   - **Project URL**（形如 `https://xxxxxxxx.supabase.co`）
   - **anon public / Publishable key**
     （新版控制台叫 Publishable key，形如 `sb_publishable_...`；
     旧版叫 anon public，是 `eyJ` 开头的一长串。两个作用一样，填哪个都能用。）

### 第二步：把这两个值填进网页

用记事本或任何编辑器打开 `index.html`，找到最前面这几行：

```js
      var CLOUD_CONFIG = {
        url: "",
        anonKey: ""
      };
```

把两个空引号填上刚才复制的值：

```js
      var CLOUD_CONFIG = {
        url: "https://xxxxxxxx.supabase.co",
        anonKey: "eyJhbGciOiJIUzI1NiIs..."
      };
```

保存即可。填好之后右上角才会出现「登录」按钮。

> anon key 是**公开密钥**，放在网页源码里是安全的：数据库开了行级安全，
> 别人即使拿到这个 key，也只能看到自己账号的数据，看不到你的。
> 真正需要保密的是 service_role key，那个**不要**填进来。

### 第三步：放到 GitHub 上

**方式 A：网页操作（不用装任何东西）**

1. 打开 [github.com](https://github.com) → 右上角 **+** → **New repository**。
2. 名字例如 `zanxiaomi`，选 **Public**，点 **Create repository**。
3. 在仓库页面点 **Add file → Upload files**，把 `index.html`（连同 `README.md`、
   `supabase-schema.sql`）拖进去，点 **Commit changes**。
4. 仓库 **Settings → Pages**：Source 选 **Deploy from a branch**，
   Branch 选 **main**、目录选 **/(root)**，点 **Save**。
5. 等 1 分钟左右，你的网址就是：`https://你的用户名.github.io/zanxiaomi/`

**方式 B：命令行**

本地仓库和第一次提交已经准备好了，只要接上远程仓库推上去：

```bash
cd outputs
git remote add origin https://github.com/你的用户名/zanxiaomi.git
git push -u origin main
```

### 第四步：第一次登录

打开网址 → 右上角点「登录」→ 填邮箱和密码 → 点「注册」创建账号。
按钮变成「已同步」就成功了。

---

## 日常怎么用

- **换电脑**：打开同一个网址 → 登录 → 记录会自动从云端拉下来。
- **写入或修改**：点保存后立刻上传云端，另一台电脑上的页面会自己更新。
- **右上角按钮**：显示 `已同步` / `同步中…` / `同步失败`，
  失败会自动重试，也可以直接再点一次保存。
- **断网时**：网页还能打开，看到的是上次同步下来的内容；
  改动会先存在本机，联网后自动补传。
- **退出登录**：点右上角那个按钮。

## 数据存在哪

- **云端**：你自己的 Supabase 项目里，只有你的账号能读写。
- **本机**：浏览器里留了一份缓存，方便断网时也能打开，也能在没登录时先写着。

第一次在旧电脑上登录时，如果云端还是空的，本机已有的记录会被自动上传上去。

## 以后想加的功能

下载导出（Markdown / JSON）、图片附件、更丰富的排版 —— 现在的编辑窗口
已经留好了空间，加这些不用重做界面。

## 常见问题

- **打开只有「登录」按钮，看不到记录**：登录之后才会从云端拉取，登录完就有了。
- **注册后提示去邮箱确认**：说明第一步第 5 条没关掉 Confirm email，去邮箱点一下链接即可。
- **免费项目被暂停**：Supabase 免费版长期（约一周）没有访问会自动暂停，
  去控制台点一下 Restore 就能继续用，数据不会丢。
- **想改密码**：Supabase 控制台 Authentication → Users 里可以重置。
