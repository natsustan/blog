# Edward Zhang's Blog

Personal blog built with [Hugo](https://gohugo.io/) and
[PaperMod](https://github.com/adityatelange/hugo-PaperMod), deployed as static
assets on Cloudflare Workers.

## Local development

Initialize the theme after cloning:

```sh
git submodule update --init --recursive
```

Install Hugo `0.164.0` or newer, then start the development server:

```sh
hugo server --buildDrafts
```

Create a post:

```sh
hugo new content posts/my-post.md
```

Set `draft: false` when the post is ready to publish.

## Production build

```sh
./build.sh
```

The generated site is written to `public/`. This directory is intentionally
ignored because Cloudflare rebuilds it for every deployment.

## Cloudflare Workers deployment

Create a Workers project from this GitHub repository and use:

```text
Production branch: main
Build command:      chmod a+x build.sh && ./build.sh
Deploy command:     npx wrangler@4.115.0 deploy
```

After the first successful deployment, add `spikezhang.me` as a custom domain
in the Worker's settings.
