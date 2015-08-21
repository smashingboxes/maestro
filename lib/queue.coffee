class Queue
  data: [ ]

  show: ->
    @data

  pop: () ->
    @data.pop()

  length: ->
    @data.length

  push: (track) ->
    unless @data.length > 10
      @data.push(track)
    @data

module.exports = Queue
