Backbone = require 'backbone'

module.exports = class OnboardingScenesView extends Backbone.View
  className: 'OnboardingScenes'

  initialize: ({ @state, @user, @views }) ->
    @listenTo @state, 'change:scene', @render

  instantiate: ->
    View = @views[@state.get 'scene']
    @view = new View state: @state, user: @user

  render: ->
    @view?.remove()
    @view = @instantiate()

    @$el.html @view.render().$el

    this

  remove: ->
    @view.remove()
    super
