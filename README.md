# iamarshad.me

> The personal site of [Arshad Kazmi](https://iamarshad.me) — indie hacker shipping the `i*.today` SaaS suite, bug bounty hunter as **[@codermak](https://hackerone.com/codermak)**, and software engineer at [Smartly.io](https://smartly.io). Based in Berlin 🇩🇪.

**Live:** [https://iamarshad.me](https://iamarshad.me)

[![X](https://img.shields.io/badge/-@arshadkazmi42-000000?style=for-the-badge&logo=x&logoColor=white)](https://twitter.com/arshadkazmi42)
[![GitHub followers](https://img.shields.io/github/followers/arshadkazmi42?label=GitHub&style=for-the-badge&logo=github&color=181717)](https://github.com/arshadkazmi42)
[![LinkedIn](https://img.shields.io/badge/-LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/arshadkazmi42)

---

## What's in the site

A single-page personal portfolio:

1. **Hero** — name, avatar (live from GitHub), tagline with an animated gradient
2. **Marquee** — fun stats strip (apps shipped, public repos, followers, stars — all live)
3. **Now** — a three-row cinematic timeline: *Indie · Hunting · Day job*
4. **Shipping** — 3-column grid showcasing the 9 `i*.today` SaaS products with per-app brand colors
5. **Bug Bounty** — profile cards for HackerOne / Bugcrowd / Intigriti / YesWeHack (real SVG logos)
6. **Open Source** — 9 hand-picked repos with live star counts and per-language accents
7. **Story** — a long-form personal note
8. **Floating pill nav + footer**

Every "number" you see on the site is fetched live from the GitHub API at page load — no hardcoded counts to maintain.

## Stack

- **Ruby on Rails 7.0** — single-page server-rendered
- **Tailwind CSS** via `tailwindcss-rails` (build-time, no Node toolchain)
- **Hotwire** (Turbo) — for fast page transitions
- **SQLite** — required by Rails to boot, but the site has no DB queries
- **Lexend** + **JetBrains Mono** (Google Fonts)
- **Cloudflare Tunnel** — deploys the local Rails app to `iamarshad.me` over a named tunnel

The whole portfolio lives in **one ERB template** (`app/views/landing/index.html.erb`, ~870 lines including all styles). The CSS is inline rather than utility-class soup — easier to evolve a personal site that doesn't share design tokens with anything else, and sidesteps Tailwind's JIT issues with dynamically-interpolated colors (each product card carries its brand color as a CSS custom property).

## Run locally

```bash
bundle install
bin/rails db:create               # SQLite file Rails needs to boot
bin/rails tailwindcss:build       # build Tailwind once
bin/rails server -p 3109          # serves on http://localhost:3109
```

If you change Tailwind classes, re-run `bin/rails tailwindcss:build`. `bin/dev` (which starts a Tailwind watcher) is broken on some setups because `tailwindcss-ruby` 4.3.0's `-w` flag exits immediately — manual builds work fine.

## Deploy

This site is served via a **Cloudflare Named Tunnel** — no public IP needed, no inbound ports opened. The setup, once:

```bash
# 1. one-time browser auth
cloudflared tunnel login

# 2. create the tunnel
cloudflared tunnel create iamarshad-me

# 3. route the apex domain to it (auto-creates the CNAME)
cloudflared tunnel route dns iamarshad-me iamarshad.me

# 4. config at ~/.cloudflared/config.yml:
#    tunnel: <id>
#    credentials-file: ~/.cloudflared/<id>.json
#    ingress:
#      - hostname: iamarshad.me
#        service: http://localhost:3109
#      - service: http_status:404

# 5. run (use http2; the default QUIC errored out for me)
cloudflared tunnel --config ~/.cloudflared/config.yml --protocol http2 run iamarshad-me
```

`Dockerfile` builds a production image if you'd rather run it on a regular host:

```bash
docker build -t iamarshad-me .
docker run -p 3000:3000 -e SECRET_KEY_BASE=$(openssl rand -hex 64) iamarshad-me
```

## File map

```
app/views/landing/index.html.erb       ← The whole portfolio (all sections, all styles, all data)
app/views/layouts/application.html.erb ← HTML shell + meta / OG / Twitter / canonical
app/controllers/landing_controller.rb  ← Empty controller
config/routes.rb                       ← root → landing#index
config/environments/development.rb     ← config.hosts whitelists APP_HOST + trycloudflare
.env                                   ← APP_HOST=iamarshad.me  (gitignored)
```

## License

This is my personal site — please don't republish it verbatim with your own name swapped in.
Feel free to take inspiration from the design and Rails patterns.

---

Built solo in Berlin · [@arshadkazmi42](https://twitter.com/arshadkazmi42)
