_ = require 'underscore'
sd = require("sharify").data
mediator = require '../../../lib/mediator.coffee'
analytics = require '../../../lib/analytics.coffee'
DropdownView = require '../../dropdown/client/dropdown_view.coffee'

template = -> require('../templates/index.jade') arguments...

module.exports = class UserMenuView extends DropdownView
  glyphs:
    grid: 'grid-three-up'
    list: 'list'

  events:
    'click .view-menu__dropdown__option' : 'toggleMode'

  initialize: ->
    @desktopEvents = _.extend @desktopEvents, @events
    super

  toggleMode: (e) ->
    mode = $(e.currentTarget).data 'mode'
    glyph = $(e.currentTarget).data 'glyph'
    @model.set 'view_mode', mode
    @$('.view-menu__selected').attr 'data-glyph', glyph
    @$el.removeClass 'dropdown--is_active'