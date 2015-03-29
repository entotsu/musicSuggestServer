clog = (s) -> console.log s
clog "request.coffee"


# last.fm
LF_URL = "http://ws.audioscrobbler.com/2.0/?"
# LF_KEY = "3119649624fae2e9531bc4639a08cba8"
# LF_KEY = "83412cee9bc5e70bbe0b36b669ac165e"
LF_KEY = "9cdfb5f61ca81f6a17b4df1d82f18fbb"


# YouTube
YT_URL = "https://www.googleapis.com/youtube/v3/search/?"
YT_KEY = "AIzaSyArZbAYSmERlrJTgQggy8bZ_8xU7Y5z0G0"


req = require 'request'
qs = require 'querystring'



# --------------------- last fm ---------------------------------------




searchArtist = (artistName, callback) ->
	# clog "-------- searchArtist ----------"

	params =
		api_key : LF_KEY
		format : "json"
		method : "artist.search"
		limit : 10
		artist : artistName

	lastfmGet params, (body) ->
		callback body.results.artistmatches.artist


getSimilarArtist = (artistName, artistId, limit, callback)->
	# clog "-------- getSimilarArtist ----------"

	params =
		api_key : LF_KEY
		format : "json"
		method : "artist.getsimilar"
		limit : limit
		mbid : artistId
		artist : artistName

	lastfmGet params, (body) ->
		unless body.similarartists
			console.error "body.similarartists is undefined!"
			console.error body
		else unless body.similarartists.artist
			console.error "body.similarartists.artist is undefined!"
			console.error body
		else if body.similarartists["#text"]
			# console.error "similarartists is NOT FOUND!!! in last.fm"
			callback null
		else
			callback body.similarartists.artist



getTopTrack = (artistName, artistId, limit, callback) ->
	# clog "-------- getTopTrack ----------"

	params =
		api_key : LF_KEY
		format : "json"
		method : "artist.getTopTracks"
		limit : limit
		mbid : artistId
		artist : artistName

	lastfmGet params, (body) ->
		unless body.toptracks
			console.error "body.toptracks is undefined!"
			console.error body
		else unless body.toptracks.track
			console.error "body.toptracks.track is undefined!"
			console.error body
		else
			callback body.toptracks.track






# ------------------------- You Tube -----------------------------------



searchVideo = (keyword, limit, callback)->
	params =
		key : YT_KEY
		q : keyword
		maxResults : limit
		part : "snippet"
		type : "video"
		order : "relevance"
		regionCode : "JP"
		videoCategoryId : "10"

	youTubeGet params, (body) ->
		unless body.items
			console.error body
			console.error "video items is undefined!"
		else
			callback body.items


# ------------------------------------------------------------

lastfmGet = (params, callback) ->
	options =
		url: LF_URL + qs.stringify params
		json: true
	console.log options.url
	get options, callback


youTubeGet = (params, callback) ->
	options =
		url: YT_URL + qs.stringify params
		json: true
	get options, callback


get = (options, callback) ->
	# clog options.url
	# clog "↑ wait ..."
	req.get options, (error, response, body) ->
		if error
			clog "error: " + response
		else if response.statusCode is 200
			callback body

# ------------------------------------------------------------


module.exports =
	searchArtist : searchArtist
	getSimilarArtist : getSimilarArtist
	getTopTrack : getTopTrack
	searchVideo : searchVideo