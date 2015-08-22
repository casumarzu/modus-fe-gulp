$ = 'jquery'
_ = require 'underscore'
React = require 'react'

Router = require 'react-router'
DefaultRoute = Router.DefaultRoute
Link = Router.Link
Route = Router.Route
RouteHandler = Router.RouteHandler



Header = React.createClass
  render: ->
    <header>
      <ul>
        <li><Link to="app">Dashboard</Link></li>
        <li><Link to="inbox">Inbox</Link></li>
        <li><Link to="calendar">Calendar</Link></li>
      </ul>
    </header>


DashboardRoute = React.createClass
  render: ->
    <div>
      <Header/>
      <Dashboard/>
    </div>

Inbox = React.createClass
  render: ->
    <div>
      <h1>Inbox</h1>
    </div>

InboxRoute = React.createClass
  render: ->
    <div>
      <Header/>
      <Inbox/>
    </div>

Calendar = React.createClass
  getInitialState: ->
    searchString: ""

  handleChange: (e) ->
    @setState searchString: e.target.value

  render: ->
    e = 'asdfasdf'
    <div>
      <h1>Calendar</h1>
      <input type="text" value={@state.searchString} onChange={@handleChange} placeholder="Type here" />
      <ul>
        {
          <li>
            <a target="_blank">{e}</a>
          </li>
        }
      </ul>
    </div>

CalendarRoute = React.createClass
  render: ->
    <div>
      <Header/>
      <Calendar/>
    </div>

App = React.createClass
  render: ->
    <div>
      <Header/>
      <RouteHandler/>
    </div>

Dashboard = React.createClass
  render: ->
    <div>
      <h1>Hello its Dashboard</h1>
    </div>


routes = (
  <Route name="app" path="/" handler={App}>
    <Route name="inbox" handler={Inbox}/>
    <Route name="calendar" handler={Calendar}/>
    <DefaultRoute handler={Dashboard}/>
  </Route>
)

Router.run routes, (Handler)->
  React.render <Handler/>, document.body

