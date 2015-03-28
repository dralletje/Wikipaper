React = require 'react'


RefInText = React.createClass
  render: ->
    <sup>
      <a href={'#cite-' + @props.to}>[{@props.to}]</a>
    </sup>


parseText = (text) ->
  text.split(/(\[\d+\])/).map (text, i) ->
    match = text.match /\[(\d+)\]/
    if match?
      <RefInText to={match[1]} key={i} />
    else
      text

toComponents = (xs, Class) ->
  xs.map (x, i) ->
    <Class {...x} key={i} index={i} />

Paragraph = React.createClass
  render: ->
    <p>{parseText @props.text}</p>

Qoute = React.createClass
  render: ->
    pleaseDontBreak =
      pageBreakInside: 'avoid !important'
      paddingBottom: '20px'

    qoute =
      paddingLeft: '20px'
      borderLeft: '3px gray solid'

    <blockqoute style={pleaseDontBreak}>
      <p style={qoute}>{parseText @props.text}</p>
      <cite>{parseText @props.author}</cite>
    </blockqoute>

Subheading = React.createClass
  render: ->
    <h3>{parseText @props.value}</h3>

Reference = React.createClass
  render: ->
    <li>
      <a id={'cite-' + @props.index} href={@props.href}>{@props.text}</a>
    </li>

classes =
  QOUTE: Qoute
  TEXT:  Paragraph
  SUBHEADING: Subheading

toComponentsWithTypeAsClass = (xs) ->
  xs.map (x, i) ->
    Class = classes[x.type]
    if not Class?
      console.log x.type, classes
    <Class {...x} key={i} />


PageBreak = React.createClass
  render: ->
    style =
      pageBreakAfter: 'always'
    <div style={style} />


Section = React.createClass
  render: ->
    style =
      paddingTop: '30px'
    pleaseDontBreak =
      pageBreakInside: 'avoid'

    <div style={pleaseDontBreak}>
      <h2 style={style}>{@props.title}</h2>
      <hr />
      {@props.children}
    </div>

Page = React.createClass
  render: ->
    AUTHOR = "Jimmy Wales"
    UNIVERSITY = "Auburn University"

    coverStyle =
      paddingTop: '100px'
      textAlign: 'center'

    <html>
      <head>
        <link href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css" rel="stylesheet" />
      </head>
      <body>
        <div className="container">
          <div style={coverStyle}>
            <h1>Research on {@props.title}</h1>
            <b>{AUTHOR}, {UNIVERSITY}</b>
          </div>

          <PageBreak />

          {@props.sections.map (section, i) ->
            <Section key={i} title={section.title}>
              {toComponentsWithTypeAsClass section.paragraphs}
            </Section>
          }

          <PageBreak />

          <Section title="References">
            <ol>
              {toComponents @props.refs, Reference}
            </ol>
          </Section>
        </div>
      </body>
    </html>

module.exports = (page) ->
  React.renderToStaticMarkup <Page {...page.toJS()} />
