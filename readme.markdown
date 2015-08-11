# tapson-show-list

A [tapson][1] protocol test result renderer for the terminal.

Shows planned tests immediately in yellow, and turns them green or red when
they finish (along with the `actual` message in a darker green or red).

![demonstration](demo.gif)

Just pipe it tapson on stdin.

    yourTests | tapson-show-list

## License

[ISC][2].

[1]: https://github.com/anko/tapson
[2]: http://opensource.org/licenses/ISC
