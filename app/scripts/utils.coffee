define ['jquery', 'lodash'], ($, _) ->
  findWidestString: (fontOptions, possibleStrings) ->
    defaultOptions =
      fontFamily: 'sans-serif'
      fontSize: '10px'
      fontWeight: 'normal'
    options = _.extend defaultOptions, fontOptions

    canvas = $('<canvas></canvas>')[0]
    context = canvas.getContext('2d')
    context.font = "#{options.fontWeight} #{options.fontSize} #{options.fontFamily}"

    _(possibleStrings).map (string) ->
      string: string
      width: context.measureText(string).width
    .max('width')
    .value()