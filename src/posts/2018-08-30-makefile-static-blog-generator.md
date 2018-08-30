## A Makefile-Based Static Site Generator

After I wrote [the last post](2018-08-16-c-hashtable-vim-preamble.html), I started feeling dissatisfied with my current static blog setup. Jekyll is a super cool project, no hate! But I started getting that itchy feeling I sometimes get as a result of not having made the thing I'm working on completely from scratch &#x1F643;

So - of course - I decided to roll my own static site generator. In keeping with my recent Unix greybeard urges, I decided to use [GNU Make](https://www.gnu.org/software/make/) as the taskrunner / build system. I figured that finally learning Make in earnest (I did at least have one professor at Brooklyn College a while back who required everyone taking his course to write a very basic Makefile) would tie in nicely with my efforts to become a C hacker. And after all, aren't Grunt, Gulp, and Webpack really just NodeJS land's hasty reinventions of Make? Make has been around for something like 40 years!

There's a lot I could cover in this post, but at the same time I'm not going to bore you with a Make 101 tutorial. The big takeaway, the big mind-blower for me, regarding Make, was the declarative style.

_Declarative, not imperative_.

That means instead of laying out the build steps one by one in your Makefile, you essentially tell Make what you ultimately want to end up with, give it some hints about how to build the intermediate dependencies of the end result, and Make just kind of like...does it. Crazy.

Of course, that revelation isn't super useful in a vaccuum. I needed to give Make some stuff to do. I needed to pick out the other building blocks of my project.

I decided I would make use of libraries from `npm` / the Node ecosystem, since it's something I'm already familiar & comfortable working with.

I enjoyed the ability to write my blog posts in Markdown, which Jekyll supported out of the box. So I needed to grab a Markdown compiler. At first, I went with [markdown](https://www.npmjs.com/package/markdown) - seemed like the obvious canonical choice, etc. But I soon realized that library doesn't support Github-flavored Markdown (GFM), so I switched to [marked](https://www.npmjs.com/package/marked), which does support it.

For templating, I decided I would go with `ejs`. I had never used it before, but it seemed like it would stay out of my way, which is something i *REALLY* value in a templating language. I've used Jade/Pug and completely hated it (whitespace is significant and mixed spaces & tabs throws an error?! You're not Python, calm down), and in PHP land, I've spent a good amount of time seething with anger towards Twig. Anyway, EJS seemed chill, and so far it hasn't proven me wrong. Although the documentation on ejs.co kind of sucks, not nearly detailed enough. I had to trawl through the source code a couple times to get my questions answered (like am I allowed to pass a `data` object as the 2nd param to an include() directive? Just tell me!!!)

I needed to write wrapper scripts around the `ejs` and `marked` libraries to be able to use them from the shell. I tried to make these helper scripts as 'dumb' / Unix-y as possible (only do one thing, write to the stdout, yadda yadda). I wanted Make to ultimately be running the show, so I didn't want to relinquish too much control to NodeJS.

I designed my wrapper script for `ejs` to take two arguments: the filename of the template to compile, and then a JSON string containing any data that needed to be passed into the template. A somewhat brittle solution, as it depends on valid, well-formed JSON to be typed into the Makefile, but whatever, it works for now.

It was also sort of funny running into little challenges presented by things that are usually implemented for you in off-the-shelf frameworks, like needing to account for the relative path when linking to the index page or to the stylesheet in the `<head>` tag (since the posts live in a subdirectory underneath where `index.html` lives). This challenge was actually the impetus for me to develop the aforementioned generalized wrapper script for `ejs` where you can compile an arbitrary template while passing in an object containing arbitrary data.

### Assorted takeaways from writing my first real Makefile

 - This line at the top of your Makefile allows you to invoke CLIs / executables from `node_modules`:
 ```
 PATH := node_modules/.bin:$(PATH)
 ```
 - `%`, `$<`, and `$@` are really powerful! Read about pattern rules and automatic variables!
 - Each line of a recipe is executed in a separate shell. So `cd`-ing into some directory on one line won't help you on the next line (there are workarounds of course).
 - If you're invoking some executable on your system (`node` in my case), remember that that executable does not necessarily have the same innate concept of the current working directory that Make does while it's building your targets and following your recipes! This sounds obvious but it bit me a couple times.
