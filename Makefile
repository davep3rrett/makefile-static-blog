PATH := node_modules/.bin:$(PATH)

MD_FILES := $(wildcard ./src/posts/*.md)
COMPILED_MD_PARTIALS := $(patsubst ./src/posts/%.md,./tmp/%.html.part,$(MD_FILES))
FINISHED_POSTS := $(patsubst ./tmp/%.html.part,./dist/posts/%.html, $(COMPILED_MD_PARTIALS))

all: ./dist/index.html ./dist/main.min.css

./dist/index.html: $(FINISHED_POSTS)
	node ./build/ejs-index-helper.js src/posts > ./dist/index.html

./dist/main.min.css: ./tmp/main.css
	csso $< > $@

./tmp/main.css: ./src/styles/main.scss
	sass --sourcemap=none $< $@

./dist/posts/%.html: ./tmp/%.html.part
	mkdir -p dist/posts
	node ./build/ejs-helper.js ./src/templates/post.ejs '{"pathPrefix": "../", "compiledMarkdownFile": "$(shell pwd)/$(value <)"}' > $@

./tmp/%.html.part: ./src/posts/%.md ./tmp/%.frontmatter
	mkdir -p tmp
	node ./build/marked-helper.js  $< > $@

./tmp/%.frontmatter: ./src/posts/%.md
	mkdir -p tmp
	node ./build/gray-matter-helper.js $< > $@

clean:
	rm -rf tmp dist

