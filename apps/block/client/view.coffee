{ extend, invoke } = require 'underscore'
LegacyBlockView = require './legacy_view.coffee'
InlineConnectIntegrationView = require '../../../components/connect/integration/inline/view.coffee'
initShare = require '../components/share/index.coffee'

{ mountWithApolloProvider } = require '../../../react/apollo/index.js'
{ default: MuteButton } = require '../../../react/components/MuteButton'


module.exports = class BlockView extends LegacyBlockView
  subViews: []

  events: extend {}, LegacyBlockView::events,
    'click .js-connect': 'connect'

  connect: (e) ->
    e.preventDefault()

    $target = $(e.currentTarget)

    view = new InlineConnectIntegrationView model: @model
    view.once 'remove', -> $target.show()

    $target
      .hide()
      .after view.render().$el

    @subViews.push view

  postRender: ->
    super

    view = initShare
      $el: @$('.js-block-share')
      block: @model

    props = { id: @model.id, type: 'BLOCK' }
    mountNode = @$('.js-block-mute')
    mountWithApolloProvider(MuteButton, props, mountNode)

    @subViews.push view

  remove: ->
    invoke @subViews, 'remove'
    super

