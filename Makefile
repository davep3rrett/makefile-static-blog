PATH := node_modules/.bin:$(PATH)

MD_FILES := $(wildcard ./src/posts/*.md)
COMPILED_MD_PARTIALS := $(patsubst ./src/posts/%.md,./tmp/%.html.part,$(MD_FILES))
FINISHED_POSTS := $(patsubst ./tmp/%.html.part,./dist/posts/%.html, $(COMPILED_MD_PARTIALS))

all: $(FINISHED_POSTS)

./dist/posts/%.html: ./tmp/%.html.part ./tmp/header.html ./tmp/footer.html
	mkdir -p dist/posts
	cat ./tmp/header.html $< ./tmp/footer.html > $@

./tmp/%.html.part: ./src/posts/%.md
	mkdir -p tmp
	node ./build/marked-helper.js $< > $@

# The header and footer recipes are currently identical but I can envision them having different requirements in the future

./tmp/header.html: ./src/layout/header.ejs
	mkdir -p tmp
	ejs-cli $< > $@

./tmp/footer.html: ./src/layout/footer.ejs
	mkdir -p tmp
	ejs-cli $< > $@

