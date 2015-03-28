
{TEXT, HEADING, QOUTE, REFS, SUBHEADING, TITLE} = require './tokens.coffee'
{List, Map} = require 'immutable'

module.exports = (tokens) ->
  page = tokens.reduce (page, element) ->
    type = element.get 'type'
    if type is HEADING
      return page.updateIn ['sections'], (xs) ->
        xs.push Map {
          title: element.get 'value'
          paragraphs: List []
        }

    if List.of(TEXT, QOUTE, SUBHEADING).contains type
      page.updateIn ['sections', -1, 'paragraphs'], (xs) ->
        xs.push element

    else if type is REFS
      page.set 'refs', element.get('items')

    else if type is TITLE
      page.set 'title', element.get('value')

    else
      console.log "Unused token #{type}."
      page

  , Map {
    title: 'Research paper'
    sections: List [
      Map(title: 'Introduction', paragraphs: List [])
    ]
  }

  page.update 'sections', (sections) ->
    sections.filter (section) ->
      section.get('paragraphs').size isnt 0
