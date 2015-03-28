{spawn} = require 'child_process'
fs = require 'fs'

module.exports = (html) ->
  [command, args...] = "wkhtmltopdf --footer-html footer.html --header-html header.html --margin-top 20mm --margin-bottom 20mm --quiet - -".split ' '

  monster = spawn(command, args)
  monster.stdin.write("<!DOCTYPE html>")
  monster.stdin.end(html)
  monster.stdout
