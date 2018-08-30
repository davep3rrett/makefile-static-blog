PATH := node_modules/.bin:$(PATH)

MD_FILES := $(wildcard ./src/posts/*.md)
COMPILED_MD_PARTIALS := $(patsubst ./src/posts/%.md,./tmp/%.html.part,$(MD_FILES))
FINISHED_POSTS := $(patsubst ./tmp/%.html.part,./dist/posts/%.html, $(COMPILED_MD_PARTIALS))

all: ./dist/index.html ./dist/main.css

./dist/index.html: $(FINISHED_POSTS)
	node ./build/ejs-index-helper.js dist/posts > ./dist/index.html

./dist/main.css: ./src/styles/main.scss
	sass $< $@

./dist/posts/%.html: ./tmp/%.html.part
	mkdir -p dist/posts
	node ./build/ejs-helper.js ./src/templates/post.ejs '{"pathPrefix": "../", "compiledMarkdownFile": "$(shell pwd)/$(value <)"}' > $@

./tmp/%.html.part: ./src/posts/%.md
	mkdir -p tmp
	node ./build/marked-helper.js  $< > $@

clean:
	rm -rf tmp dist

