require.config
  paths:
    jquery: '../bower_components/jquery/jquery'
    lodash: '../bower_components/lodash/dist/lodash'
    typeahead: '../bower_components/typeahead.js/dist/typeahead'
    ace: '../bower_components/ace/build/src-noconflict/ace'
    aceTheme: '../bower_components/ace/build/src-noconflict/theme-dawn'
    aceJsMode: '../bower_components/ace/build/src-noconflict/mode-javascript'
    bootstrapAffix: '../bower_components/sass-bootstrap/js/affix'
    bootstrapAlert: '../bower_components/sass-bootstrap/js/alert'
    bootstrapButton: '../bower_components/sass-bootstrap/js/button'
    bootstrapCarousel: '../bower_components/sass-bootstrap/js/carousel'
    bootstrapCollapse: '../bower_components/sass-bootstrap/js/collapse'
    bootstrapModal: '../bower_components/sass-bootstrap/js/modal'
    bootstrapPopover: '../bower_components/sass-bootstrap/js/popover'
    bootstrapScrollspy: '../bower_components/sass-bootstrap/js/scrollspy'
    bootstrapTab: '../bower_components/sass-bootstrap/js/tab'
    bootstrapTooltip: '../bower_components/sass-bootstrap/js/tooltip'
    bootstrapTransition: '../bower_components/sass-bootstrap/js/transition'

  shim:
    ace:
      exports: 'ace'

    aceTheme:
      deps: ['ace']

    aceJsMode:
      deps: ['ace']

    typeahead:
      deps: ['jquery']
  
    bootstrapAffix:
      deps: ['jquery']

    bootstrapAlert:
      deps: ['jquery']

    bootstrapButton:
      deps: ['jquery']

    bootstrapCarousel:
      deps: ['jquery']

    bootstrapCollapse:
      deps: ['jquery']

    bootstrapModal:
      deps: ['jquery']

    bootstrapPopover:
      deps: ['jquery']

    bootstrapScrollspy:
      deps: ['jquery']

    bootstrapTab:
      deps: ['jquery']

    bootstrapTooltip:
      deps: ['jquery']

    bootstrapTransition:
      deps: ['jquery']

require ['jquery', 'lodash', 'ace', 'utils', 'fonts-list', 'font-weights', 'aceTheme', 'aceJsMode', 'typeahead',
         'bootstrapTab', 'bootstrapModal'], ($, _, ace, utils, fontsList, fontWeights) ->
  "use strict"

  updateCanvasSize = (canvasElement) ->
    canvasElement.width = $(canvasElement).width()

  canvas = $('canvas')[0]
  updateCanvasSize(canvas)
  $(window).on 'resize', _.partial(updateCanvasSize, canvas)

  ace.config.set 'workerPath', 'bower_components/ace'
  editor = ace.edit 'editor'
  editor.setTheme 'ace/theme/dawn'
  editor.session.setMode 'ace/mode/javascript'

  $(".nav-tabs a[href=#{window.location.hash}]").tab('show') if window.location.hash

  $('form').on 'submit', (event) ->
    event.preventDefault()

    fontOptions = {}
    fontOptions.fontFamily = $('#font-family').val() or 'sans-serif'
    if fontOptions.fontFamily.indexOf(' ') > -1
      fontOptions.fontFamily = "'#{fontOptions.fontFamily}'"
    fontOptions.fontSize = $('#font-size').val() or '10px'
    fontOptions.fontWeight = $('#font-weight').val()
    samplesNumber = parseInt($('#samples-number').val(), 10) or 1

    possibleStrings = switch $('.tab-pane.active').attr('id')
      when 'alphabet-mode' then $('#alphabet').val()
      when 'options-mode' then $('#options').val().split(/\s*,\s*/)
      when 'function-mode'
        try
          (new Function editor.getValue())()
        catch error
          console.log error
          $('.modal-error').find('.modal-body')
          .html("Please check function code. It's not valid.<br />#{error}")
          .end()
          .modal('show')
          ''

    widest = utils.findWidestString fontOptions, possibleStrings
    $('.result').text "Result width: #{widest.width * samplesNumber}px";
    context = canvas.getContext('2d');
    context.font = "#{fontOptions.fontWeight} #{fontOptions.fontSize} #{fontOptions.fontFamily}"
    context.clearRect 0, 0, canvas.width, canvas.height
    context.textBaseline = 'middle'
    context.fillText widest.string, (canvas.width - widest.width) / 2, 100

  $('#font-family').typeahead
    name: 'fonts'
    local: fontsList

  $('#font-weight').typeahead
    name: 'font-weights'
    local: fontWeights