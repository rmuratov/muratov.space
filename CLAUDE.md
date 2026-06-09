# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

**Development** (two terminals required):

```shell
# Terminal 1 — build and watch Tailwind CSS
npm ci && npm run tw

# Terminal 2 — start Hugo dev server with drafts
make
```

**One-off CSS build:**
```shell
npx tailwindcss -i ./tailwind.css -o ./static/css/tailwind.css --minify
```

**Format code:**
```shell
npx prettier --write .
```

## Architecture

Hugo static site. No separate theme — layouts, styles, and static assets live directly in the project root.

- **`content/`** — Markdown content (blog posts, homepage). Blog posts live in `content/blog/`.
- **`layouts/`** — Go templates. `_default/` for base templates, `blog/` for blog pages, `partials/` for reusable components.
- **`tailwind.css`** — Tailwind entry point, compiled to `static/css/tailwind.css`.
- **`public/`** — Hugo build output, not committed.

Hugo config is in `hugo.toml`. Key settings: dark mode via Tailwind `class` strategy, Dracula syntax highlighting, git-based lastmod dates, taxonomies disabled.

Deployment is via Docker (see `Dockerfile`) with Caddy as web server.
