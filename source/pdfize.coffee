{spawn} = require 'child_process'
fs = require 'fs'

module.exports = (html) ->
  command = "wkhtmltopdf --footer-html footer.html --header-html header.html --margin-top 20mm --margin-bottom 20mm --quiet - -"

  monster = spawn('/bin/sh', ['-c', command + "| cat"])
  monster.stdin.write("<!DOCTYPE html>")
  monster.stdin.end(html)
  monster.stdout
