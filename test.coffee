# coffee -wc *.coffee
# node-dev test.js

clog = (s) -> console.log s
clog "============= test.coffee ================="



server = require "./server.js"


# manager = require "./streamManager.js"




# moment = require "moment"
# id = moment().unix().toString()
# console.log id
# console.log  "ellegarden" + id

# newID = "s" + id

# # id = moment().unix()
# # console.log id

# # console.log id + 1

# arry = []
# arry['aa'] = {"a":"aa"}
# console.log arry
# console.log arry['aa']

# console.log "aaaaaaaaaaaaaaaaaaaaa"
# arry[newID] = {'aef':'iajefj'}
# console.log arry





# arr = new Array("4", "11", "2", "10", "3", "1")
# clog arr
# removed = arr.splice 0
# clog arr
# clog removed



# Stream = require "./stream.js"

# getloop = (stream)->
# 	setTimeout (=>
# 		newTracks = stream.popTracks(10)
# 		getloop stream
# 	), stream.firstRequestDelay + (10000 * Math.random())

# stream = new Stream "ELLEGARDEN"
# getloop stream



# setTimeout =>
# 	stream.stop()
# 	setTimeout =>
# 		stream = null
# 	,1000
# , 1000 * 40

# stream2 = new Stream "A-bee"
# getloop stream2

# stream3 = new Stream "岩崎愛"
# getloop stream3

# stream4 = new Stream "the band apart"
# getloop stream4

# stream5 = new Stream "AKB48"
# getloop stream5

# stream6 = new Stream "嵐"
# getloop stream6

# stream7 = new Stream "toe"
# getloop stream7









# fs = require("fs")
# youtubedl = require("youtube-dl")

# downloadVideo = (videoId)->
# 	# Optional arguments passed to youtube-dl.
# 	video = youtubedl("http://www.youtube.com/watch?v=#{videoId}", ["--max-quality=18"],
	  
# 	  # Additional options can be given for calling `child_process.execFile()`.
# 	  cwd: __dirname
# 	)

# 	# Will be called when the download starts.
# 	video.on "info", (info) ->
# 	  console.log "Download started"
# 	  console.log "filename: " + info.filename
# 	  console.log "size: " + info.size
# 	  return

# 	video.pipe fs.createWriteStream("#{videoId}.mp4")

# downloadVideo "Pv2O5el79hA"#ellegarden supernova
# downloadVideo "UjZqcDYbvAE"#one ok rock mighty









# req = require './request.js'


# req.searchVideo "ELLEGARDEN I hate it", 4, (videos)->
# 	for video in videos
# 		clog video.snippet.title
# 		clog video.id.videoId


# req.searchArtist "ELLEGARDEN", (artists) ->
# 	clog artist.name for artist in artists

# req.getSimilarArtist "ELLEGARDEN","923158cf-9d21-4bce-8040-41e7a497c1c9", (artists) ->
# 	clog artist.name for artist in artists

# req.getTopTrack "ELLEGARDEN","923158cf-9d21-4bce-8040-41e7a497c1c9", (tracks) ->
# 	clog track.name for track in tracks