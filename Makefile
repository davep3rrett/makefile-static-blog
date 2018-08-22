PATH := node_modules/.bin:$(PATH)

MD_FILES := $(wildcard ./src/posts/*.md)
COMPILED_MD_PARTIALS := $(patsubst ./src/posts/%.md,./tmp/%.html.part,$(MD_FILES))
FINISHED_POSTS := $(patsubst ./tmp/%.html.part,./dist/posts/%.html, $(COMPILED_MD_PARTIALS))

all: $(FINISHED_POSTS)

./dist/posts/%.html: ./tmp/%.html.part
	mkdir -p dist/posts
	cat $(ejs ./src/layout/head.ejs) $< $(ejs ./src/layout/footer.ejs) > $@

./tmp/%.html.part: ./src/posts/%.md
	mkdir -p tmp
	md2html $< > $@

