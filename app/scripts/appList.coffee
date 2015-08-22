$ = 'jquery'
_ = require 'underscore'
React = require 'react'




# window.addEventListener 'load', ->
#   console.log 1

# divs = document.querySelectorAll 'div'
# _.each divs, (e)->
#   e.style.transition = 'all 2s'
#   e.style.transform = 'scale(1)'

# for index in [0...10]
#   promise = do (index) ->
#     async = $.Deferred()

#     setTimeout ->
#       console.log index
#       async.resolve()
#     , 1000

#     async.promise()

libraries = [
  name: "Backbone.js"
  url: "http://documentcloud.github.io/backbone/"
,
  name: "AngularJS"
  url: "https://angularjs.org/"
,
  name: "jQuery"
  url: "http://jquery.com/"
,
  name: "Prototype"
  url: "http://www.prototypejs.org/"
,
  name: "React"
  url: "http://facebook.github.io/react/"
,
  name: "Ember"
  url: "http://emberjs.com/"
,
  name: "Knockout.js"
  url: "http://knockoutjs.com/"
,
  name: "Dojo"
  url: "http://dojotoolkit.org/"
,
  name: "Mootools"
  url: "http://mootools.net/"
,
  name: "Underscore"
  url: "http://documentcloud.github.io/underscore/"
,
  name: "Lodash"
  url: "http://lodash.com/"
,
  name: "Moment"
  url: "http://momentjs.com/"
,
  name: "Express"
  url: "http://expressjs.com/"
,
  name: "Koa"
  url: "http://koajs.com/"
 ]

# Head = React.createClass
#   displayName: 'App'
#   render: ->
#     <div>
#       <p>Hello {@name}!</p>
#       {@description}
#     </div>

#   name: 'name'
#   description: 'asdfasd asd sd sda sda sdsdss dafs '

SearchExample = React.createClass
  getInitialState: ->
    searchString: ""

  handleChange: (e) ->
    @setState searchString: e.target.value

  render: ->
    libraries = @props.items
    searchString = @state.searchString.trim().toLowerCase()
    if searchString.length > 0
      libraries = libraries.filter (l) ->
        l.name.toLowerCase().match searchString
    <div>
      <input type="text" value={@state.searchString} onChange={@handleChange} placeholder="Type here" />
      <ul>
          {
            libraries.map (l)->
              <li>{l.name} <a target="_blank" href={l.url}>{l.url}</a></li>
          }
      </ul>
    </div>

# React.render <Head/>, document.getElementById 'app-head'
React.render <SearchExample items={ libraries } />, document.getElementById 'app-body'
# module.exports = App

