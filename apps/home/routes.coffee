Promise = require 'bluebird-q'
{ shuffle, extend } = require 'underscore'
{ API_URL, HOMEPAGE_SPLASH, HOMEPAGE_EXPLORE_USER_IDS } = require('sharify').data
{ DEMO_USER_AUTH_TOKEN } = process.env
graphQL = require '../../lib/graphql'
cached = require '../../lib/cached'
ExploreBlocks = require '../../collections/explore_blocks'

@index = (_req, res, next) ->
  userIds = (HOMEPAGE_EXPLORE_USER_IDS or '').split(',').map (x) -> parseInt(x, 10)
  exploreBlocks = new ExploreBlocks
  extend exploreBlocks.options, user_ids: userIds

  Promise.all [
    # Cached for 1 hour
    (cached 'homepage:explore-blocks', 3600, -> exploreBlocks.fetch())

    # Caches for 24 hours
    (
      cached 'homepage:demo-blocks', 86400, ->
        graphQL
          token: DEMO_USER_AUTH_TOKEN
          query: """
            {
              channel(id: "are-na-connect-everything") {
                blocks(per: 100) {
                  ... blockThumb
                }
              }
            }

            #{require '../../components/block_v2/queries/block'}
          """
    ).catch (->) # Ignore query errors
  ]

  .spread (exploreBlocksResponse, demoResponse) ->
    locals = {}

    if demoResponse?
      { channel: { blocks } } = demoResponse
      res.locals.sd.DEMO_BLOCKS = demoBlocks = shuffle blocks
      extend locals, demoBlocks: demoBlocks

    if exploreBlocksResponse?
      # Re-initialize the collection with the possibly cached response to parse it
      exploreBlocks = new ExploreBlocks exploreBlocksResponse, parse: true
      res.locals.sd.EXPLORE_BLOCKS = exploreBlocks.toJSON()
      extend locals, blocks: exploreBlocks.models

    extend locals, splash: res.locals.sd.HOMEPAGE_SPLASH

    res.render 'index', locals

  .catch next
