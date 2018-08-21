PATH := node_modules/.bin:$(PATH)

markdown_files := $(wildcard src/posts/*.md)

posts: $(markdown_files)
	$(foreach post,$(markdown_files),md2html $(post) > $(post:.md=.html);)
