# robsdudeson.github.io

The source for [robsdudeson.github.io](https://robsdudeson.github.io), built with
[Jekyll](https://jekyllrb.com/) and deployed by GitHub Pages.

## Write a post

Create a draft post with:

```sh
nix develop --command ./bin/new-post "A clear title"
```

The generator creates `_posts/YYYY-MM-DD-HHmmss-slug.md`. The 24-hour timestamp
avoids same-day filename collisions. Published posts appear in the recent
writing section on `/` and in the full archive at `/blog/`. Pass `--published`
only when the post is ready for the public site:

```sh
nix develop --command ./bin/new-post --published "A clear title"
```

## Develop locally

[Nix](https://nixos.org/download/) provides the Ruby and Bundler toolchain:

```sh
nix develop --command ./bin/verify
nix develop --command bundle exec jekyll serve
```

The first command installs missing Ruby dependencies and builds the site. The
second starts a local preview server. Configure the homepage introduction and
recent-post count in `_config.yml` under `home`.

## Deployment

A push to `main` runs [the Pages workflow](.github/workflows/pages.yml). It
builds the site from `Gemfile.lock` and deploys only generated `_site` output to
GitHub Pages. Pull requests run the build but do not deploy.

See [`AGENTS.md`](AGENTS.md) for contributor and coding-agent guidance.
