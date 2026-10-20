# Agent Guide

## Project

This is a Jekyll site deployed by GitHub Pages. Posts live in `_posts/`; layouts,
includes, configuration, and assets follow Jekyll's standard directory layout.

## Working on the site

- Do not edit `_site/`; Jekyll generates it.
- Create posts as `_posts/YYYY-MM-DD-slug.md` with YAML front matter.
- Keep post commands generic. Do not publish personal paths, device names, IP
  addresses, hostnames, account names, or credentials.
- Preserve the site's existing Jekyll and Markdown conventions unless the task
  explicitly changes the design.

## Development and verification

The Nix development shell provides Ruby and Bundler:

```sh
nix develop --command ./bin/verify
```

The verification command installs missing Bundler dependencies and builds the
site with strict front matter. Run it after changing posts, layouts,
configuration, or assets.

For a local preview:

```sh
nix develop --command bundle exec jekyll serve
```

## Git

- Inspect `git status` before editing and keep unrelated changes intact.
- Run `git diff --check` before committing.
- A push to `origin` publishes to the public GitHub Pages site. Scan outbound
  content for personal or sensitive details before pushing.
