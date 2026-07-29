# Edward Zhang's Blog

Personal blog built with [Hugo](https://gohugo.io/) and
[PaperMod](https://github.com/adityatelange/hugo-PaperMod), deployed as static
assets on Cloudflare Workers.

## Local development

Initialize the theme after cloning:

```sh
git submodule update --init --recursive
```

Install the pinned Hugo version with [mise](https://mise.jdx.dev/), then start
the development server:

```sh
mise install
mise exec -- hugo server --buildDrafts
```

The local preview is available at <http://localhost:1313/> and includes draft
posts.

## Publish a post

1. Create a page bundle for the post:

```sh
mise exec -- hugo new content posts/my-post/index.md
```

2. Write the article in `content/posts/my-post/index.md`. Put any images next
   to `index.md` and reference them with relative paths.

3. Preview the draft locally:

```sh
mise exec -- hugo server --buildDrafts
```

4. Set `draft: false` in the post front matter, then verify the production
   build:

```sh
./build.sh
```

5. Commit the post and push it to `main`:

```sh
git add content/posts/my-post
git commit -m "Publish my post"
git push origin main
```

Cloudflare automatically builds and deploys every push to `main`. Once the
deployment succeeds, the post is live at <https://spikezhang.me/posts/my-post/>.

## Publish site changes

Changes to `hugo.yaml`, files in `static/`, or theme overrides in the project
root are published through the same pipeline:

```sh
mise exec -- hugo server --buildDrafts
./build.sh
git add hugo.yaml
git commit -m "Update site theme"
git push origin main
```

Only add the paths that were actually changed. Every push to `main` triggers a
new Cloudflare deployment.

### Customize PaperMod

Avoid editing files directly inside `themes/PaperMod`. It is a Git submodule
pointing to the upstream PaperMod repository, so uncommitted local edits are
not included when Cloudflare clones this blog.

Instead, copy the file to customize from `themes/PaperMod` into the matching
path at the project root, then edit the copy. Hugo gives project files priority
over theme files. For example:

```text
themes/PaperMod/layouts/partials/header.html -> layouts/partials/header.html
themes/PaperMod/assets/css/common/header.css -> assets/css/common/header.css
```

Commit and push these root-level overrides like any other site change.

### Update PaperMod

To publish a newer upstream PaperMod version, update the submodule pointer,
verify the site, then commit the pointer in this repository:

```sh
git submodule update --remote themes/PaperMod
./build.sh
git add themes/PaperMod
git commit -m "Update PaperMod"
git push origin main
```

## Production build

```sh
./build.sh
```

The generated site is written to `public/`. This directory is intentionally
ignored because Cloudflare rebuilds it for every deployment.

## Manual deployment

To deploy the current working tree without pushing a commit, authenticate once
and deploy with Wrangler:

```sh
npx wrangler@4.115.0 login
./build.sh
npx wrangler@4.115.0 deploy
```

## Cloudflare Workers setup

For the initial setup, create a Workers project from this GitHub repository and
use:

```text
Production branch: main
Build command:      chmod a+x build.sh && ./build.sh
Deploy command:     npx wrangler@4.115.0 deploy
```

After the first successful deployment, add `spikezhang.me` as a custom domain
in the Worker's settings.
