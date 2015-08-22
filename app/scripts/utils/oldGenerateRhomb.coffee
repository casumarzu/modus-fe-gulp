window.addEventListener 'load', ->
  rhomb = new PaintRhomb 'generateRhomb', '/images/image.png'

class PaintRhomb
  constructor: (@id, @image)->
    @canvas = new fabric.Canvas @id
    @paintPolygon @wdt, @hgt
    @loadPattern @image
    @addPolygon()

  paintPolygon: ()->
    @wdt = @canvas.width
    @hgt = @canvas.height
    @polygon = new fabric.Polygon([
      x: 0
      y: @hgt/2
    ,
      x: @wdt/2
      y: 0
    ,
      x: @wdt
      y: @hgt/2
    ,
      x: @wdt/2
      y: @hgt
     ],
      left: 0
      top: 0
      angle: 0
      selectable: false
    )

  loadPattern: (url)->
    fabric.util.loadImage url, (img) =>
      @polygon.fill = new fabric.Pattern
        source: img
      @canvas.renderAll()

  addPolygon: ->
    @canvas.add @polygon
