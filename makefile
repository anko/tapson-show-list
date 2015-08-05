export PATH := node_modules/.bin:$(PATH)

index.js: index.ls
	echo "#!/usr/bin/env node" > $@
	lsc -cp $< >> $@
	chmod +x $@

clean:
	rm -f index.js

run: index.js
	~/code/eslisp/test.ls | ./$<

.PHONY: clean
