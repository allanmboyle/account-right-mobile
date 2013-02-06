regex_escape = (string) ->
  string.replace(new RegExp('[.\\\\+*?\\[\\^\\]$(){}=!<>|:\\-]', 'g'), '\\$&')

window.regex_escape = regex_escape
