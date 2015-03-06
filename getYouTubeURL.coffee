



# -------------------------

req = require 'request'
qs = require 'querystring'


clog = (s) -> console.log s


getUrlFromId = (videoId, callback) ->

	getYoutubeInfo videoId, (videoInfo)->

		video = decodeQueryString(videoInfo)

		if !video || video.status == "fail" || !video.url_encoded_fmt_stream_map
			clog "FAILED TO GET VIDEO URL !"
			callback null
			return

		video.sources = decodeStreamMap(video.url_encoded_fmt_stream_map)

		lowest = null
		exact = null


		quality = "medium"
		type = "mp4"

		for source in video.sources

			# clog source.quality + " " + source.type

			if source.type.match type
				if source.quality.match quality
					exact = source
				else
					lowest = source

		videoInfo = null
		if exact
			videoInfo = exact
		else if lowest
			videoInfo = lowest
		else
			callback null
			return

		# clog "GET " + videoInfo.quality + " " + videoInfo.type 

		callback videoInfo.url
		return



getYoutubeInfo = (video_id, callback) ->

	params =
		video_id : video_id

	options =
		url: "http://www.youtube.com/get_video_info?" + qs.stringify params
		json: true

	get options, callback


get = (options, callback) ->
	req.get options, (error, response, body) ->
		if error
			console.error "error: " + response.statusCode
		else if response.statusCode is 200
			callback body


decodeQueryString = (queryString) ->
	r = {}
	keyValPairs = queryString.split("&")
	for keyValPair in keyValPairs
		key = decodeURIComponent(keyValPair.split("=")[0])
		val = decodeURIComponent(keyValPair.split("=")[1] || "")
		r[key] = val
	return r


decodeStreamMap = (url_encoded_fmt_stream_map) ->
	sources = {}
	for urlEncodedStream in url_encoded_fmt_stream_map.split(",")
		stream = decodeQueryString(urlEncodedStream)
		type    = stream.type.split(";")[0]
		quality = stream.quality.split(",")[0]
		stream.original_url = stream.url
		stream.url = "#{stream.url}&signature=#{stream.sig}"
		sources["#{type} #{quality}"] = stream




module.exports =
	getUrlFromId : getUrlFromId