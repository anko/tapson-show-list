# reads tapson in, shows all pending tests and outcomes

require! <[ highland blessed ttys ]>

screen = blessed.screen smart-CSR : yes input : ttys.stdin

screen.key <[ escape q C-c ]> (ch, key) ->
  process.exit 0

list = blessed.box do
  mouse : yes
  keys : true
  vi : true
  top : 0
  left : 0
  width : \100%
  height : \100%
  always-scroll : true
  scrollable : true
  style :
    fg : \lightblue

screen.append list

list.focus!

screen.render!

# stdin is tapson lines
highland process.stdin .split! .each ->
  list.push-line it
  screen.render!
