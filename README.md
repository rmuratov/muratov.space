# muratov.space

muratov.space website sources. Built with Hugo static website generator.

## Development

This site uses a custom theme located in `themes/muratov.space`. The theme is build with tailwindcss, so it first needed to run building css:

```shell
cd themes/muratov.space
npm ci
npm run tw
```

And then starting hugo (inside root directory):

```shell
make
```

> The theme is not self-sufficient, a lot of content defined inside the theme. Someday I may extract it.