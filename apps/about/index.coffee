express = require 'express'

app = module.exports = express()

app.set 'views', "#{__dirname}/templates"
app.set 'view engine', 'jade'

app.get '/about', (_req, res) ->
  res.render 'index'
app.get '/tools', (_req, res) ->
  res.render 'tools'
app.get '/faqs', (_req, res) ->
  res.render 'faqs'
app.get '/terms', (_req, res) ->
  res.render 'terms'
app.get '/privacy', (_req, res) ->
  res.render 'privacy'
app.get '/pricing', (_req, res) ->
  res.render 'pricing'
