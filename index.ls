# reads tapson in, shows all pending tests and outcomes

require! <[ highland blessed ttys ]>

screen = blessed.screen smart-CSR : yes input : ttys.stdin

screen.key <[ escape q C-c ]> (ch, key) ->
  process.exit 0

list = blessed.list do
  interactive : false
  #invert-selected : false
  #mouse : yes
  #keys : true
  #vi : true
  top : 0
  left : 0
  width : \100%
  height : \100%
  scrollable : true
  scrollbar: true
  style :
    fg : \lightblue

screen.enable-input!
screen.on \keypress (ch, key) ->
  switch
  | key.name in <[ up   k ]> => list.scroll -1 ; screen.render!
  | key.name in <[ down j ]> => list.scroll  1 ; screen.render!
screen.on \mouse ({ action }) ->
  switch action
  | \wheeldown => list.scroll(-1); screen.render!
  | \wheeldown => list.scroll( 1); screen.render!

set-timeout do
  ->
    list.scroll 10
    screen.render!
  1000

screen.append list

list.focus!

screen.render!

# stdin is tapson lines
highland process.stdin .split! .each ->
  list.push-item it
  screen.render!
