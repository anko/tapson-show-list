# reads tapson in, shows all pending tests and outcomes

require! <[ highland blessed ttys uuid ]>
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

pending = {}

show-plan = ({id, expected}) ->
  pending[id] = true
  expected = if expected then blessed.parse-tags "{yellow-fg}#{blessed.escape expected}{/}"
             else blessed.parse-tags "{grey-fg}unspecified{/}"
  list.add expected
  id-to-line[id] = i
  ++i
  screen.render!

show-result = ({id, ok, actual}) ->
  pending[id] = false
  colour = if ok then \green else \red
  actual-with-tags =
    if actual   then "{#{colour}-fg}" + blessed.escape actual + "{/}"
    else if ok  then "{#007700-fg}ok{/}"   # dark green 'ok'
    else             "{#770000-fg}fail{/}" # dark red 'fail'


  actual = blessed.parse-tags actual-with-tags
  line = id-to-line[id]

  expected-text = (list.get-line line)
                  |> -> "{#{colour}-fg}#{it |> blessed.escape |> blessed.strip-tags}{/}"

  [ first-line, ...other-lines ] = actual .split "\n"
  list.set-line do
    line
      expected-text + ": " + first-line

  if other-lines.length
    for line-text in reverse other-lines
      list.insert-line line + 1, line-text
      ++i

  for id, that-line of id-to-line
    if that-line > line
      id-to-line[id] += other-lines.length

  screen.render!

# stdin is tapson lines
highland process.stdin
  .split!
  .each ->
    return if it is ""
    obj = JSON.parse it
    { ok, id, expected, actual } = obj

    if id?
      if ok? then show-result obj
      else show-plan obj
    else # must be an immediate test then
         # (one that has both the plan and result ready at the same time)
      obj.id = uuid!
      show-plan obj
      show-result obj
  .done ->
    for id, still-waiting of pending
      if still-waiting
        show-result { id, ok : false }
