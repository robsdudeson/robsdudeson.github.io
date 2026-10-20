# robsdudeson.github.io

The source for [robsdudeson.github.io](https://robsdudeson.github.io), built with
[Jekyll](https://jekyllrb.com/) and deployed by GitHub Pages.

## Write a post

Add a Markdown file to `_posts/` using the name `YYYY-MM-DD-slug.md`. Include
Jekyll front matter:

```yaml
---
layout: post
title: A clear title
date: 2026-10-20
tags: example
published: true
---
```

## Develop locally

[Nix](https://nixos.org/download/) provides the Ruby and Bundler toolchain:

```sh
nix develop --command ./bin/verify
nix develop --command bundle exec jekyll serve
```

The first command installs missing Ruby dependencies and builds the site. The
second starts a local preview server.

See [`AGENTS.md`](AGENTS.md) for contributor and coding-agent guidance.
