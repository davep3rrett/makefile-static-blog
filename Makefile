# be able to directly call executables installed by npm
PATH := node_modules/.bin:$(PATH)

USE_SASS := 1

# make sure your stylesheet is named one of these
STYLESHEET_NAME := main.css
ifeq ($(USE_SASS), 1)
	STYLESHEET_NAME := main.scss
endif

MD_FILES := $(wildcard ./src/posts/*.md)
COMPILED_MD_PARTIALS := $(patsubst ./src/posts/%.md,./tmp/%.html.part,$(MD_FILES))
FINISHED_POSTS := $(patsubst ./tmp/%.html.part,./dist/posts/%.html, $(COMPILED_MD_PARTIALS))

all: ./dist/index.html ./dist/main.min.css ./dist/favicon.ico

./dist/index.html: $(FINISHED_POSTS)
	node ./build/ejs-index-helper.js src/posts > ./dist/index.html

./dist/main.min.css: ./tmp/main.css
	csso $< > $@

./dist/favicon.ico: ./src/favicon.ico
	mkdir -p dist
	cp ./src/favicon.ico ./dist/favicon.ico

./tmp/main.css: ./src/styles/$(STYLESHEET_NAME)
	mkdir -p tmp
ifeq ($(USE_SASS), 1)
	node ./build/node-sass-helper.js $< > $@
else
	cp $< $@
endif

./dist/posts/%.html: ./tmp/%.html.part
	mkdir -p dist/posts
	node ./build/ejs-helper.js ./src/templates/post.ejs '{"pathPrefix": "../", "compiledMarkdownFile": "$(shell pwd)/$(value <)"}' > $@

./tmp/%.html.part: ./tmp/%.md
	mkdir -p tmp
	node ./build/marked-helper.js  $< > $@

./tmp/%.md: ./src/posts/%.md
	mkdir -p tmp
	node ./build/strip-frontmatter.js $< > $@

clean:
	rm -rf tmp dist
