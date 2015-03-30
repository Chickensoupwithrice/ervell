Base = require "./base.coffee"
sd = require("sharify").data

module.exports = class Storage extends Base

  getItem: (key) ->
    JSON.parse localStorage.getItem(key)

  setItem: (key, value) ->
    console.log 'typeof value is Array', typeof value is Array
    value = JSON.stringify(value) if typeof value is Array
    localStorage.setItem(key, value)
    @set key, value

  removeItem: (key) ->
    localStorage.removeItem(key)
    @unset key

  clear: ->
    localStorage.clear()
