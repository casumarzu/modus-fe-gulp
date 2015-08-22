
$ = require 'jquery'
class ScalableBlock
  constructor: (@data)->
    @genSize()
    @genRestictions()
    @onResize()
    @changeSize()

  genSize:->
    if @data.el and $(@data.el)
      @$el = $(@data.el)
      @$wdt = @$el.width()
      @$hgt = @$el.height()

      @windowWidth = $(window).width()
      @windowHeight = $(window).height()

      @changeSize()

  changeSize:->
    if @$wdt > @windowWidth
      # @$el.width @windowWidth
      scale = @windowWidth / @$wdt
      @$el.attr 'style', @transformPolyfill(scale)
    else
      @$el.attr 'style', @transformPolyfill(1)

  transformPolyfill: (scale)->
    pos = 'top left'
    transform = "
      -webkit-transform: scale(#{scale});
          -ms-transform: scale(#{scale});
              transform: scale(#{scale});
      -webkit-transform-origin: #{pos};
          -ms-transform-origin: #{pos};
              transform-origin: #{pos};
    "

  genRestictions:->
    if @data.minWidth
      @minWidth = @data.minWidth
    if @data.minHeight
      @minHeight = @data.minHeight

  onResize:=>
    $(window).resize()
    $(window).on 'resize', (e)=>
      @windowWidth = $(window).width()
      @windowHeight = $(window).height()
      @changeSize()

module.exports = ScalableBlock


