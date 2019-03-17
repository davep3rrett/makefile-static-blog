# makefile-static-blog

This repo will house my own blog as it grows and evolves.

Once I have things set up the way I want them, I will extract some kind of starter template / scaffolding from this repo without all the 'Dave' branding :) so other users can build blogs based on this setup.

## Requirements

Make sure to have these installed on your system:

 - GNU Make
 - NodeJS

## If you want to use Sass

The Makefile has a `USE_SASS` flag. Set it to `1` and call your main stylesheet `main.scss`. Otherwise to use regular CSS and skip the compilation step, set it to `0` (or anything else, or comment it out, or whatever) and call your main stylesheet `main.css`.

## Build the blog

First build:

```
npm i
make
```

Subsequent builds:

```
make clean && make
```

The generated site files will appear in `/dist`.
