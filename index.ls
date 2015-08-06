# reads tapson in, shows all pending tests and outcomes

require! <[ highland blessed ttys ]>
{ reverse } = require \prelude-ls

screen = blessed.screen smart-CSR : yes input : ttys.stdin

screen.key <[ escape q C-c ]> (ch, key) ->
  process.exit 0

list = blessed.log do
  invert-selected : false
  keys : true
  vi : true
  top : 0
  left : 0
  width : \100%
  height : \100%
  scrollable : true
  tags : true

screen.append list

list.on \mouse (button) ->
  switch button.action
  | \wheeldown => list.scroll 1 ; screen.render!
  | \wheelup => list.scroll -1 ; screen.render!

list.focus!

screen.render!

i = 0
id-to-line = {}

show-plan = ({id, expected}) ->
  expected = if expected then blessed.escape expected
             else blessed.parse-tags "{grey-fg}unspecified{/}"
  list.add expected
  id-to-line[id] = i
  ++i
  screen.render!

show-result = ({id, ok, actual}) ->
  colour = if ok then \green else \red
  actual-with-tags =
    if actual   then "{#{colour}-fg}" + blessed.escape actual + "{/#{colour}-fg}"
    else if ok  then "{#007700-fg}ok{/}"
    else             "{#770000-fg}fail{/}"


  actual = blessed.parse-tags actual-with-tags
  line = id-to-line[id]

  [ first-line, ...other-lines ] = actual .split "\n"
  list.set-line do
    line
     (list.get-line line) + ": " + first-line

  if other-lines.length
    for line-text in reverse other-lines
      list.insert-line line + 1, line-text
      ++i
  screen.render!

# stdin is tapson lines
highland process.stdin .split! .each ->
  return if it is ""
  obj = JSON.parse it
  { ok, id, expected, actual } = obj

  if ok? then show-result obj
  else show-plan obj
