# tapson-show-list [![npm package](https://img.shields.io/npm/v/tapson-show-list.svg?style=flat-square)][1] [![npm dependencies](https://img.shields.io/david/anko/tapson-show-list.svg?style=flat-square)][2]

A [tapson][3] protocol test result renderer, for the terminal.

Shows planned tests immediately in yellow, and turns them green or red when
they finish (along with the `actual` message in a darker green or red).

![demonstration](demo.gif)

Just pipe it tapson on `stdin`.

    yourTests | tapson-show-list

If you want it to update whenever something changes, that's another tool's job.
On Linux, a shell script with `inotifywait` works great:

```sh
# Stores test process ID
PID=""

# Wait for changes to input files
inotifywait --quiet -m -e modify whatever-input-files |
while read file; do

    # Kill the old process
    if [ ! -z "$PID" ]; then
        kill "$PID"
    fi

    # Run process in background and save process id
    your-tests | tapson-show-list &
    PID=$!
done;
```

## License

[ISC][4].

[1]: https://www.npmjs.com/package/tapson-show-list
[2]: https://david-dm.org/anko/tapson-show-list
[3]: https://github.com/anko/tapson
[4]: http://opensource.org/licenses/ISC
