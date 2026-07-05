# kungal-dl

> The identity page of **imoe.uk** — the file-delivery domain of the KUN Galgame community.
>
> **imoe.uk** —— 鲲 Galgame 社区文件分发域的身份说明页。

Live at **[imoe.uk](https://imoe.uk)** and at the root of **[dl.imoe.uk](https://dl.imoe.uk)**.

## What this is

`imoe.uk` serves exactly one thing: community-uploaded game patch archives
(`.zip` / `.rar` / `.7z`), delivered as direct `Content-Disposition: attachment`
downloads for the KUN Galgame community sites. The domain hosts no other web
content, which makes it look anonymous to reputation systems. This repository
is the single static page that fixes that: it states plainly what the domain
is, who operates it, what it serves, and how to report a file.

The page is a single self-contained `index.html` — no framework, no build step,
no external requests (fonts, scripts and styles are all inline), English by
default with a Simplified Chinese toggle, light/dark via
`prefers-color-scheme`. A strict `Content-Security-Policy` in
[`nginx.conf`](./nginx.conf) enforces the zero-third-party claim, and
[`/.well-known/security.txt`](./.well-known/security.txt) publishes
machine-readable abuse contacts (RFC 9116).

## About KUN Galgame · 关于鲲 Galgame

KUN Galgame (Kun Visual Novel) is a free, open-source, non-commercial
community for visual-novel (galgame) fans. Everything we run is developed in
the open.

鲲 Galgame 是一个免费、开源、非商业的 Galgame 爱好者社区,所有站点均公开开发。

**Sites · 站点**

| Site | What it is |
|---|---|
| [www.kungal.com](https://www.kungal.com) | KUN Visual Novel forum · 鲲 Galgame 论坛 |
| [www.moyu.moe](https://www.moyu.moe) | Galgame patch resources · 鲲 Galgame 补丁站 |
| [dl.imoe.uk](https://dl.imoe.uk) | File delivery for the sites above · 文件分发域(本仓库) |

**Open-source repositories · 开源仓库**

| Repository | Description |
|---|---|
| [KunMoe/kun-galgame-forum](https://github.com/KunMoe/kun-galgame-forum) | The forum — Nuxt 4 + Go Fiber + PostgreSQL · 论坛主站 |
| [KunMoe/kun-galgame-patch](https://github.com/KunMoe/kun-galgame-patch) | The patch-resource site · 补丁资源站 |
| [kungal/kun-ui](https://github.com/kungal/kun-ui) | Headless UI library for ACGN websites · UI 组件库 |
| [kungal/kun-editor](https://github.com/kungal/kun-editor) | Milkdown-based Markdown editor · Markdown 编辑器 |
| [kungal/kungal-link-shortener](https://github.com/kungal/kungal-link-shortener) | Short-link service · 短链服务 |
| [kungal/kungal-link-live-checker](https://github.com/kungal/kungal-link-live-checker) | Share-link liveness checker · 网盘链接存活校验 |
| [KunMoe/kun-galgame-stickers](https://github.com/KunMoe/kun-galgame-stickers) | Community sticker set · 社区表情包 |
| [kungal/kungal-dl](https://github.com/kungal/kungal-dl) | This page · 本仓库 |

**Community · 社区群组**

- Telegram: [t.me/kungalgame](https://t.me/kungalgame)

## Report a file · 举报文件

If a file distributed through `dl.imoe.uk` looks harmful or infringing, open an
[issue](https://github.com/kungal/kungal-dl/issues) or contact the moderators in
the [Telegram group](https://t.me/kungalgame). Flagged files are taken down
promptly — every upload is tied to an authenticated community account.

如发现经 `dl.imoe.uk` 分发的文件涉嫌有害或侵权,请提交 issue 或在 Telegram
群组联系管理员,我们会及时下架。所有上传均绑定社区认证账号,可追溯。

## Development

```bash
# it is one HTML file — any static server works
python3 -m http.server 8080
# open http://localhost:8080
```

## Deployment

Built as a tiny nginx image ([`Dockerfile`](./Dockerfile)), deployed with
Dokploy:

1. Create a Dokploy application from this repository (build type: Dockerfile),
   container port `80`.
2. Attach the domains `imoe.uk` and `dl.imoe.uk`.
3. `dl.imoe.uk` also runs the Cloudflare Worker that fronts the file bucket.
   Keep the Worker on the file paths only — either narrow its routes to
   `dl.imoe.uk/<site>/*` patterns, or make it `fetch(request)` through to the
   origin for any path that is not a file download — so `/`, `/favicon.svg`,
   `/robots.txt` and `/.well-known/*` fall through to this page.
