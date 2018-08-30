# makefile-static-blog

This repo will house my own blog as it grows and evolves.

Once I have things set up the way I want them, I will extract some kind of starter template / scaffolding from this repo without all the 'Dave' branding :) so other users can build blogs based on this setup.

## Requirements

Make sure to have these installed on your system:

 - GNU Make
 - NodeJS
 - Ruby
 - Sass

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
