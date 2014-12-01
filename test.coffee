# coffee -wc *.coffee
# node-dev test.js

log = (s) -> console.log s
log "============= test.coffee ================="


req = require './request.js'


# req.searchArtist "ELLEGARDEN", (artists) ->
# 	log artist.name for artist in artists

# req.getSimilarArtist "ELLEGARDEN","923158cf-9d21-4bce-8040-41e7a497c1c9", (artists) ->
# 	log artist.name for artist in artists

# req.getTopTrack "ELLEGARDEN","923158cf-9d21-4bce-8040-41e7a497c1c9", (tracks) ->
# 	log track.name for track in tracks