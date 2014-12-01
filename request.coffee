log = (s) -> console.log s
log "request.coffee"


# LAST FM
LF_URL = "http://ws.audioscrobbler.com/2.0/?"
LF_KEY = "3119649624fae2e9531bc4639a08cba8"


req = require 'request'
qs = require 'querystring'





searchArtist = (artistName, callback) ->
	log "searchArtist"

	params =
		api_key : LF_KEY
		format : "json"
		method : "artist.search"
		limit : 10
		artist : artistName

	lastfmGet params, (body) ->
		callback body.results.artistmatches.artist


getSimilarArtist = (artistName, artistId, callback)->
	log "getSimilarArtist"

	params =
		api_key : LF_KEY
		format : "json"
		method : "artist.getsimilar"
		limit : 10
		mbid : artistId
		artist : artistName

	lastfmGet params, (body) ->
		callback body.similarartists.artist


getTopTrack = (artistName, artistId, callback) ->
	log "getTopTrack"

	params =
		api_key : LF_KEY
		format : "json"
		method : "artist.getTopTracks"
		limit : 100
		mbid : artistId
		artist : artistName

	lastfmGet params, (body) ->
		callback body.toptracks.track




# ------------------------------------------------------------

lastfmGet = (params, callback) ->
	options =
		url: LF_URL + qs.stringify params
		json: true
	get options, callback

get = (options, callback) ->
	console.log options.url
	req.get options, (error, response, body) ->
		if error
			log "error: " + response.statusCode
		else if response.statusCode is 200
			callback body

# ------------------------------------------------------------


module.exports =
	searchArtist : searchArtist
	getSimilarArtist : getSimilarArtist
	getTopTrack : getTopTrack