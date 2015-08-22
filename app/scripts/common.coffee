
PaintRhomb = require './utils/generateRhomb.coffee'
ScalableBlock = require './utils/scalableBlock.coffee'

class Common
  constructor:->
    console.log 'common initialize'

  generateRhomb:->
    id = 'image-rhomb'
    image = '/images/dogs.gif'
    @rhomb = new PaintRhomb id, image

  generateScalableBlock: (data)->
    @scalableBlock = new ScalableBlock data

module.exports = Common
