request = require 'request-promise'
http = require 'http'
fs = require 'fs'

URL = 'http://en.wikipedia.org/w/index.php?title='

# parts
tokenize = require './tokenize'
constructpage = require './constructpage'
htmlize  = require './htmlize'
pdfize   = require './pdfize'

send = (res) ->
  (data) ->
    if data.pipe?
      data.pipe(res)
    else
      res.end(data)

save = (file) ->
  (data) ->
    if data.pipe?
      data.pipe(fs.createWriteStream file)
    else
      fs.writeFile(file, data)


http.createServer (req, res) ->
  match = req.url.match(/Research_on_(.+)\.pdf/)
  if not match?
    res.end 'Nope, sorry!'
    return
  name = match[1]

  request(URL + name)
  .then(tokenize)
  .then(constructpage)
  .then(htmlize)
  .then(pdfize)
  .then(send res)
  .catch (err) ->
    console.log err.stack
    res.end 'Sorry!'

.listen 8083
