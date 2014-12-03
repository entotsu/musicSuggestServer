# coffee -wc *.coffee
# node-dev test.js

clog = (s) -> console.log s
clog "============= test.coffee ================="




Stream = require "./stream.js"

# stream = new Stream "ELLEGARDEN"
# stream.popTracks()



# stream2 = new Stream "A-bee"
# stream2.popTracks()

stream4 = new Stream "80kidz"
# stream3 = new Stream "岩崎愛"









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