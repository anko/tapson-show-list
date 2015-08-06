export PATH := node_modules/.bin:$(PATH)

index.js: index.ls
	echo "#!/usr/bin/env node" > $@
	lsc -cp $< >> $@
	chmod +x $@

clean:
	rm -f index.js

test: index.js test-input.json
	./index.js < test-input.json

.PHONY: clean test
