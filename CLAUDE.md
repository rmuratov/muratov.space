# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

**Development** (two terminals required):

```shell
# Terminal 1 — build and watch Tailwind CSS
cd themes/muratov.space && npm ci && npm run tw

# Terminal 2 — start Hugo dev server with drafts
make
```

**One-off CSS build:**
```shell
cd themes/muratov.space && npx tailwindcss -i ./tailwind.css -o ./static/css/tailwind.css --minify
```

**Format code:**
```shell
# From project root or theme directory
npx prettier --write .
```

## Architecture

Hugo static site with a custom theme (`themes/muratov.space/`). The theme is tightly coupled with the site — it is not a standalone reusable theme.

- **`content/`** — Markdown content (blog posts, homepage). Blog posts live in `content/blog/`.
- **`themes/muratov.space/layouts/`** — Go templates. `_default/` for base templates, `blog/` for blog pages, `partials/` for reusable components.
- **`themes/muratov.space/tailwind.css`** — Tailwind entry point, compiled to `themes/muratov.space/static/css/tailwind.css`.
- **`public/`** — Hugo build output, not committed.

Hugo config is in `hugo.toml`. Key settings: dark mode via Tailwind `class` strategy, Dracula syntax highlighting, git-based lastmod dates, taxonomies disabled.

Deployment is via GitHub Actions (`.github/workflows/hugo.yaml`) to GitHub Pages on push to `main`.
