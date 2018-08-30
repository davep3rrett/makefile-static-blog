PATH := node_modules/.bin:$(PATH)

MD_FILES := $(wildcard ./src/posts/*.md)
COMPILED_MD_PARTIALS := $(patsubst ./src/posts/%.md,./tmp/%.html.part,$(MD_FILES))
FINISHED_POSTS := $(patsubst ./tmp/%.html.part,./dist/posts/%.html, $(COMPILED_MD_PARTIALS))

all: ./dist/index.html ./dist/main.css

./dist/index.html: $(FINISHED_POSTS)
	node ./build/ejs-index-helper.js dist/posts > ./dist/index.html

./dist/main.css: ./src/styles/main.scss
	sass $< $@

$(FINISHED_POSTS): $(COMPILED_MD_PARTIALS)
	mkdir -p dist/posts
	node ./build/ejs-helper.js ./src/templates/post.ejs '{"relativeCssPathPrefix": "../", "compiledMarkdownFile": "$(shell pwd)/$(value <)"}' > $@

$(COMPILED_MD_PARTIALS): $(MD_FILES)
	mkdir -p tmp
	node ./build/marked-helper.js $< > $@

clean:
	rm -rf tmp dist

