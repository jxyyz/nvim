; extends

; YAML is injected as a child of the jinja (`ansible`) root, so inside a quoted
; scalar both @string.yaml and the jinja tokens land on the same range at the
; default priority 100 — and the injected (child) YAML wins the tie, greying out
; `{{ ... }}` / `{% ... %}`. Bump the jinja captures above 100 so template code
; shows through the string. (YAML block scalars already do this via priority 99.)

([
  "{{" "{{-" "{{+" "+}}" "-}}" "}}"
  "{%" "{%-" "{%+" "+%}" "-%}" "%}"
] @keyword.directive
  (#set! priority 101))

((identifier) @variable
  (#set! priority 101))

((function_call
  (identifier) @function.call)
  (#set! priority 101))

([
  "if" "else" "elif" "endif"
] @keyword.conditional
  (#set! priority 101))

([
  "for" "in" "continue" "break" "endfor"
] @keyword.repeat
  (#set! priority 101))

([
  "block" "with" "filter" "macro" "set" "trans" "pluralize" "autoescape"
  "endtrans" "endblock" "endwith" "endfilter" "endmacro" "endcall" "endset" "endautoescape"
] @keyword
  (#set! priority 101))

([
  "include" "import" "from" "extends" "as"
] @keyword.import
  (#set! priority 101))

((string_literal) @string
  (#set! priority 101))

((number_literal) @number
  (#set! priority 101))

((float_literal) @number.float
  (#set! priority 101))

((boolean_literal) @boolean
  (#set! priority 101))

((null_literal) @constant
  (#set! priority 101))

((binary_operator) @operator
  (#set! priority 101))
