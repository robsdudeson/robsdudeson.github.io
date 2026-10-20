---
title: "feat: add homepage and blog archive"
type: feat
status: complete
date: 2026-10-20
---

# Add a Homepage and Blog Archive

## Overview

Turn `/` from a paginated post feed into a stable personal homepage. It will
introduce the author, show a configurable number of the newest published posts
(default three), and link readers to a dedicated `/blog/` archive containing all
published posts.

---

## Problem Frame

The current `index.html` is only a paginated list of posts. That makes the site
feel like a blog archive rather than a homepage and leaves no clear place for a
short personal introduction. Readers also lack a stable, explicit route for
browsing all writing.

---

## Requirements Trace

- R1. `/` presents a short personal introduction before writing.
- R2. `/` lists the newest published posts, with a configurable count that
  defaults to three.
- R3. Each recent-post entry links to its existing post URL.
- R4. `/` links clearly to a dedicated blog archive.
- R5. `/blog/` lists all published posts, newest first, without changing any
  existing post permalink.
- R6. The design remains consistent with the Midnight remote theme and works at
  small screen widths.

---

## Scope Boundaries

- Do not redesign the Midnight theme's shared header or restore a local default
  layout just to add site navigation.
- Do not change existing post filenames, front matter, or permalinks.
- Do not add a CMS, client-side framework, search, tags index, or client-side
  pagination.
- Do not add pagination to `/blog/` in this iteration; the site has few posts
  and Jekyll's bundled `jekyll-paginate` only paginates the root index.

---

## Context & Research

### Relevant Code and Patterns

- `index.html` currently loops over `paginator.posts` and uses the established
  post link expression based on `post.url` and `site.baseurl`.
- `_posts/` contains published posts; Jekyll's default `site.posts` collection
  excludes drafts and orders posts newest first.
- `_layouts/post.html` supplies a simple semantic article layout; Midnight owns
  the default header and global visual language.
- `_config.yml` currently enables `jekyll-paginate` and sets `paginate: 3`.
- `assets/css/style.scss` imports the remote theme and is the established seam
  for restrained local styles.

### Key Constraint

The current pagination configuration cannot simply move to `/blog/`: the
bundled `jekyll-paginate` plugin only paginates the root index. The archive
should therefore use `site.posts` directly and remove inactive pagination
configuration rather than retaining misleading settings.

---

## Visual and Content Direction

- **Visual thesis:** Keep Midnight's dark, compact, repository-adjacent feel;
  make the homepage read as a short personal note followed by writing, not as a
  dashboard or card grid.
- **Content order:** personal introduction, recent writing heading and list,
  clear “all posts” link.
- **Interaction plan:** use ordinary text links and visible keyboard focus from
  the theme; add no new motion or JavaScript.

---

## Key Technical Decisions

- **Use `_config.yml` for homepage copy and post count:** configuration makes
  the introduction and `recent_posts_count` easy to edit without touching
  Liquid markup. Set the initial count to `3`.
- **Use `site.posts` for both lists:** it includes only publishable posts and
  preserves Jekyll's chronological ordering.
- **Use a root-level `blog.html` with permalink `/blog/`:** it creates a stable
  archive route without needing a new collection or a custom layout.
- **Remove `jekyll-paginate`:** it is no longer needed once root is a homepage;
  keeping it would imply pagination that the archive does not provide.
- **Add only small local CSS if the theme's defaults need it:** semantic HTML
  and Midnight typography should carry the page first.

---

## Open Questions

### Resolved During Planning

- **What leads the homepage?** A short personal introduction.
- **How many recent posts appear by default?** Three, controlled by site
  configuration.
- **Where does the full archive live?** `/blog/`.

### Deferred to Implementation

- **Final introduction wording:** add it as editable configuration and use the
  chosen copy at implementation time; it should stay to one or two sentences.
- **Whether local CSS is needed:** decide after viewing the semantic markup with
  Midnight's default styles; do not add CSS merely for decoration.

---

## Implementation Units

- [x] U1. **Define homepage and archive configuration**

**Goal:** Add clear, editable site settings for the personal introduction and
recent-post count, while removing obsolete pagination settings.

**Requirements:** R1, R2, R5

**Dependencies:** None

**Files:**
- Modify: `_config.yml`

**Approach:** Add a small homepage configuration group for heading and intro
copy and a numeric `recent_posts_count` with an initial value of `3`. Remove
the `jekyll-paginate` plugin and its pagination settings because the archive
will not use it. Preserve existing site metadata, base URL, theme, and post
configuration.

**Patterns to follow:** Existing top-level site metadata in `_config.yml`.

**Test scenarios:**
- Happy path: the configured count limits the homepage list to the newest three
  published posts.
- Edge case: changing the count to one or a number greater than the available
  posts renders the available published posts without an error.

**Verification:** The Jekyll build reads the configuration, the homepage shows
its configured intro, and no pagination plugin warning or unused pagination
configuration remains.

---

- [x] U2. **Build the homepage recent-writing section**

**Goal:** Replace the root post archive with a personal introduction, recent
published posts, and an archive link.

**Requirements:** R1, R2, R3, R4, R6

**Dependencies:** U1

**Files:**
- Modify: `index.html`
- Modify: `assets/css/style.scss` only if visual verification shows a concrete
  hierarchy or spacing issue

**Approach:** Keep the existing default layout. Render the configured heading
and introduction, then iterate over `site.posts` with the configured limit.
Reuse the existing URL, date, and excerpt conventions for each entry. Add a
plain link to `/blog/`, with copy that makes the destination clear. Use
semantic `main`, `section`, headings, and list markup where compatible with the
current page template.

**Patterns to follow:** Post links and excerpts in the current `index.html`; the
remote-theme import in `assets/css/style.scss`.

**Test scenarios:**
- Happy path: the three newest published posts appear in newest-first order,
  each with its title, date, excerpt, and working link.
- Edge case: a site with fewer than three published posts renders only those
  posts and still shows the archive link.
- Edge case: draft posts created by `bin/new-post` do not appear.
- Integration: the all-posts link resolves with the configured `baseurl` and
  reaches the archive page on the built site.

**Verification:** The root page is legible with Midnight styles, communicates
who the site belongs to before the post list, and has no broken links or layout
regressions at desktop and narrow viewport widths.

---

- [x] U3. **Add the all-posts archive**

**Goal:** Give readers a stable page for browsing the complete published post
list.

**Requirements:** R3, R5, R6

**Dependencies:** U1

**Files:**
- Create: `blog.html`
- Modify: `assets/css/style.scss` only if U2 establishes a necessary shared list
  style

**Approach:** Create a layout-backed page with permalink `/blog/`. Iterate over
`site.posts` without a limit, using the same title, date, excerpt, and URL
format as the homepage. Include a clear text link back to the homepage. Do not
introduce pagination or duplicate post content.

**Patterns to follow:** The current post-list markup in `index.html` and the
post URL expression used there.

**Test scenarios:**
- Happy path: every published post appears once, newest first, with a working
  link.
- Edge case: the archive omits drafts and handles posts with an explicit
  permalink.
- Integration: the homepage archive link renders `/blog/` and the generated
  archive links resolve to the existing post URLs.

**Verification:** The strict Jekyll build produces `blog/index.html` (or the
configured equivalent), and the current Blu-ray post and both older posts are
reachable from the archive.

---

- [x] U4. **Update contributor guidance and verify generated routes**

**Goal:** Keep the site's documentation and validation aligned with the new
information architecture.

**Requirements:** R2, R4, R5

**Dependencies:** U2, U3

**Files:**
- Modify: `README.md`
- Modify: `AGENTS.md`

**Approach:** Briefly document the homepage/archive split, the configurable
recent-post count, and the need to validate both root and archive routes after
post or layout changes. Keep the existing Nix verification command as the
single build contract.

**Patterns to follow:** Current development and deployment sections in
`README.md`; site-editing guidance in `AGENTS.md`.

**Test expectation:** none -- documentation-only changes; route checks are
covered by U2 and U3.

**Verification:** A contributor can locate the post count setting, understand
where posts appear, and run the documented build successfully.

---

## System-Wide Impact

- **Content flow:** new published posts will automatically appear in the
  homepage subset and full archive; drafts remain hidden.
- **URLs:** post URLs remain unchanged; `/` changes purpose and `/blog/` is new.
- **Theme ownership:** Midnight's global layout remains remote-theme owned;
  local changes stay in content templates and, only when needed, stylesheet
  overrides.
- **Deployment:** the existing Pages workflow builds the changed templates and
  deploys only generated `_site` output.

---

## Risks & Dependencies

| Risk | Mitigation |
| --- | --- |
| Accidentally reintroducing unsupported archive pagination | Use `site.posts` directly and remove `jekyll-paginate` settings. |
| Draft content appearing publicly | Depend on Jekyll's `site.posts` behavior and verify a generated draft stays absent. |
| Breaking post links during the template split | Reuse the current `post.url` expression and test the explicit Blu-ray permalink. |
| Local styles fighting the Midnight theme | Start with theme defaults; add minimal, scoped CSS only after visual review. |
| Homepage copy becomes hard-coded and hard to update | Keep heading and intro in `_config.yml`. |

---

## Documentation / Operational Notes

- After implementation, run `nix develop --command ./bin/verify`.
- Visually inspect `/` and `/blog/` in the local preview before publishing.
- Confirm the Pages workflow deploys the generated routes after merge.

---

## Sources & References

- Related code: `index.html`, `_config.yml`, `_layouts/post.html`,
  `assets/css/style.scss`, `bin/new-post`
- Related guidance: `AGENTS.md`, `README.md`
- Theme: https://github.com/pages-themes/midnight
