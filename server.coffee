# print = (s)-> console.log s
# print "server.coffee"


PORT_NUMBER = 60064


http = require "http"
url = require "url"
manager = require "./streamManager.js"


ERROR = 
	"not_get" : "get only"
	"no_param" : "no param"
	"no_id" : "please set id"
	"invalid_method" : "invalid method"
	"no_artist_name" : "please enter artist name"






onAccess = (req, res) ->
	console.log "################# onAccess #################"
	console.log req.url
	if req.method isnt "GET"
		returnError res, ERROR['not_get']
	else
		p = url.parse(req.url, true).query
		unless p
			returnError res, ERROR['no_param']
		else
			console.log p
			switch p.method

				when "start"#  artist_name  artist_id

					unless p.artist_name
						returnError res, ERROR['no_artist_name']
					else
						writeJSON res, manager.startNewStream p.artist_name, p.artist_id, p.mode

				when "get"#    id
					unless p.id
						returnError res, ERROR['no_id']
					else
						writeJSON res, manager.getTracks p.id, p.limit

				when "stop"#    id
					unless p.id
						returnError res, ERROR['no_id']
					else
						writeJSON res, manager.stopStream p.id

				else
					returnError res, ERROR['invalid_method']



server = http.createServer(onAccess).listen(PORT_NUMBER)
console.log "server started"




writeJSON = (res, obj) ->
	res.writeHead 200,
		"Content-Type": "application/json"
	res.end JSON.stringify(obj)
	console.log "WROTE: "
	console.log obj
	return res

returnError = (res, message) ->
	writeJSON res,
		error_message: message



