PATH := node_modules/.bin:$(PATH)

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

./tmp/main.css: ./src/styles/main.scss
	mkdir -p tmp
	sass --sourcemap=none $< $@

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

