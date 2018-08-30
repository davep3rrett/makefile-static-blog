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
	# cat ./tmp/header.html $< ./tmp/footer.html > $@
	node ./build/ejs-helper.js ./src/templates/post.ejs '{"relativeCssPathPrefix": "../", "compiledMarkdownFile": "$(shell pwd)/$(value <)"}' > ./dist/posts/%.html

./tmp/%.html.part: ./src/posts/%.md
	mkdir -p tmp
	node ./build/marked-helper.js $< > $@

# The header and footer recipes are currently identical but I can envision them having different requirements in the future

#./tmp/header.html: ./src/layout/header.ejs
#	mkdir -p tmp
#	ejs-cli $< > $@
#
#./tmp/footer.html: ./src/layout/footer.ejs
#	mkdir -p tmp
#	ejs-cli $< > $@

clean:
	rm -rf tmp dist

