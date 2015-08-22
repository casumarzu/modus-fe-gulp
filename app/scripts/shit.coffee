$ = require 'jquery'
_ = require 'lodash'
class ShitClass
  constructor:->
    console.log 'Hello this is a shit class!'
    @console()

  console:->
    _.each [1..5], (e)->
      string = "Shit number - #{e}"
      console.log string
      $('body').append "<div class='shit-item'><div class='text-gradient-green'>#{string}</div></div>"

class AnotherShitClass extends ShitClass
  constructor:->
    super

module.exports = AnotherShitClass
