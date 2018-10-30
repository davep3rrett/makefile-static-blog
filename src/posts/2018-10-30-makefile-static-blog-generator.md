---
title: A Makefile-based static site generator
date: 30 Oct 2018 00:17:00 EST
---
## A Makefile-Based Static Site Generator

After I wrote [the last post](2018-08-16-c-hashtable-vim-preamble.html), I started feeling dissatisfied with my current static blog setup. Jekyll is a cool project, but it has more features than I need / want. So naturally...I decided to roll my own static blog generator &#x1F643;

In keeping with my recent Unix greybeard urges, I decided to use [GNU Make](https://www.gnu.org/software/make/) as the taskrunner / build system. I've been wanting to get more familiar with writing Makefiles, plus I just felt like doing something a little more esoteric than Grunt/Gulp/Webpack/whatever.

I learned a lot about Make in the process, and there's a lot I could cover in this post, but I'm not going to bore you by attempting to write a Make tutorial. For me, the big takeaway - the big mind-blower for me - was the declarative style.

_~ Declarative, not imperative ~_

This means that rather than laying out the build steps one by one in your Makefile, you instead tell Make what you ultimately want to end up with, give it some hints about how to build the intermediate dependencies of the end result, and Make just...does it. Crazy.

### Dependencies / other software used

I decided I would make use of libraries from `npm` / the Node ecosystem, since it's something I'm already familiar & comfortable working with.

I enjoyed the ability to write my blog posts in Markdown, which Jekyll supported out of the box. So I needed to grab a Markdown compiler. I went with [marked](https://www.npmjs.com/package/marked), which supports Github-flavored Markdown.

For templates, I chose `ejs`. I value templating languages that stay out of your way and don't force too much cute new syntax on you.

To deal with metadata, I decided to keep Jekyll's solution and use YAML front matter. I chose [gray-matter](https://github.com/jonschlinkert/gray-matter) to deal with this.

I wanted Make to be doing most of the work, so I needed to write wrapper scripts around the aforementioned `npm` packages to be able to use them from the shell. I tried to make these helper scripts as 'dumb' / Unix-y as possible (only do one thing, write to the stdout, yadda yadda).

### Assorted takeaways from writing my first real Makefile

 - This line at the top of your Makefile allows you to invoke CLIs / executables from `node_modules`:
 ```
 PATH := node_modules/.bin:$(PATH)
 ```
 - `%`, `$<`, and `$@` are really powerful! Read about pattern rules and automatic variables!
 - Each line of a recipe is executed in a separate shell. So `cd`-ing into some directory on one line won't help you on the next line (there are workarounds of course).
 - If you're invoking some executable on your system (`node` in my case), remember that that executable does not necessarily have the same innate concept of the current working directory that Make does while it's building your targets and following your recipes! This sounds obvious but it bit me a couple times.

 ### Farewell / final remarks

 This was really fun to work on. There are tons of ways in which it could be better, more generalized, more parameterized, more configurable. But it works for now, and hopefully will live and evolve as I keep blogging. You can check out the code [here](https://github.com/davep3rrett/makefile-static-blog). Thanks - as always - for reading :)
