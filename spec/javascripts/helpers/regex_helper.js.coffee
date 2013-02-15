regexEscape = (string) ->
  string.replace(new RegExp('[.\\\\+*?\\[\\^\\]$(){}=!<>|:\\-]', 'g'), '\\$&')

window.regexEscape = regexEscape
