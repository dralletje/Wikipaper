{List, Map} = require 'immutable'
{TEXT, HEADING, QOUTE, REFS, SUBHEADING, TITLE} = require './tokens.coffee'

cheerio = require 'cheerio'

module.exports = (html) ->
  $ = cheerio.load html
  children = List Array::slice.call $('#mw-content-text').children()

  children.map (el) ->
    $el = $ el

    if      $el.is 'p'
      type: TEXT
      text: $el.text()

    else if $el.is 'h2'
      type: HEADING
      value: $el.find('.mw-headline').text()

    else if $el.is 'h3'
      type: SUBHEADING
      value: $el.find('.mw-headline').text()

    else if $el.is 'blockquote'
      type: QOUTE
      text: $el.find('p').text()
      author: $el.find('div').text()?.match(/([a-zA-Z ]+)/)?[1]

    else if $el.is '.reflist'
      type: REFS
      items: Array::slice.call($el.find('li .reference-text')).map (x) ->
        $x = $ x

        href: $x.find('a').attr 'href'
        text: $x.text()

  .push
    type: TITLE
    value: $('#firstHeading').text()

  .filter (el) -> el?
  .map(Map)
