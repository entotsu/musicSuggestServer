console.log "streamManager.coffee"

Stream = require "./stream.js"

streamList = []


startNewStream = (artistName, artistId, mode)->
	console.log "startNewStream"
	console.log artistName
	console.log artistId
	stream = new Stream artistName, artistId
	console.log stream.id
	streamList[stream.id] = stream
	console.log "streamList"
	console.log streamList
	json =
		stream_id: stream.id
		first_request_delay: stream.firstRequestDelay
	return json



getTracks = (id, limit)->
	console.log "getTracks"
	stream = streamList[id]

	unless stream
		return {"error":"stream #{id} is not found."}
	else
		tracks = stream.popTracks(limit)
		json = {tracks:tracks}
		return json


stopStream = (id)->
	console.log "stopStream"
	stream = streamList[id]

	unless stream
		return {"error":"stream #{id} is not found."}
	else
		stream.stop()
		delete streamList[id]
		console.log streamList
		json = {message:"stopped"}
		return json




module.exports =
	startNewStream : startNewStream
	getTracks : getTracks
	stopStream : stopStream
