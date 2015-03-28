
clog = (s) ->
	console.log s
clog "stream.coffee"



req = require './request.js'
moment = require "moment"

YTParser = require './getYouTubeURL.js'


#------------------------- TUNING -------------------------------

#アプリが最初にとりにくるまでの時間
FIRST_REQUEST_DELAY = 5000

#最初に最速で一番近い50曲とる
FIRST_ARTIST_LIMIT = 4
FIRST_TRACK_LIMIT = 2

DELAY_OF_START_MAIN_LOOP = 50

addTracksLoopInterval = (tracks_num)->
	delay = tracks_num * tracks_num + 200# TODO あとでもう少しちゃんと考える
	clog " ... + wait #{delay}msec"
	return delay


# TODO トラックの数に応じてリクエストの間隔をずらす	
addVideoLoopInterval = (playlist_length)->
	delay = playlist_length * playlist_length / 5 + 100
	clog " ... # wait #{delay}msec"
	return delay


DEFAULT_LIMIT_OF_TOP_TRACK = 25


#----------------------------------------------------------------


# "ｷﾞﾀｰ"
# "ギター"
# "GUITER"
# "Guiter"
# "guiter"
NG_WORDS = [
	"歌ってみ"
	"うたってみ"
	"カラオケ"
	"ｶﾗｵｹ"
	"カバー"
	"ｶﾊﾞｰ"
	"cover"
	"Cover"
	"COVER"
	"コピー"
	"ｺﾋﾟｰ"
	"copy"
	"Copy"
	"COPY"
	"ピッチ"
	"弾いてみ"
	"ひいてみ"
	"メドレー"
	"ﾒﾄﾞﾚｰ"
	"BGM"
	"作業用"
	"Trailer"
	"トレーラー"
	"寄せ集め"
	"集めてみた"
	"弾き語り"
	"弾きかたり"
	"ひきかたり"
	"Short ver"
	]



class Stream


	constructor: (@artistName, @artistId)->
		self = @
		@uncheckedTracks = []
		@uncheckedVideos = []
		@playlist = []
		@similarArtists = []
		@id = "s" + moment().unix().toString()

		@sendNum = 0

		@isStartAddTracksLoop = false
		@isStartAddVideosLoop = false

		self.startStream()

		@firstRequestDelay = FIRST_REQUEST_DELAY

		@tracksLoopTimer = null
		@videoLoopTimer = null

		@isExhaustedArtists = false
		@isStop = false
		@isError = false

		@timeoutTimer = null


#----------- public API --------------
	popTracks: (num)->
		sendTraks = null
		if !num or num <= 0
			sendTraks = @playlist.splice 0
		else#後ろから取るようにした。もしアーティスト情報付与するなら前からとってこう	
			sendTraks = @playlist.splice @playlist.length - num, num

		@sendNum += sendTraks.length

		clog "#{@id} s#{@sendNum} p#{@playlist.length} t#{@uncheckedTracks.length} -> pop #{sendTraks.length} tracks"
		return sendTraks




	stop: ->
		clog "stop stream"
		@isStop = true
		clearTimeout @tracksLoopTimer
		clearTimeout @videoLoopTimer



#--------- private method -----------
	startStream: ->
		clog "##### startStream #####"

		# @similarArtists = testArtists
		# @addTracksLoop()

		@generateFastPlaylist()
		setTimeout (=>
			@addArtists 999, =>
				@addTracksLoop()
				@addVideoLoop()
		),DELAY_OF_START_MAIN_LOOP



	generateFastPlaylist: ->
		al = FIRST_ARTIST_LIMIT
		tl = FIRST_TRACK_LIMIT
		@addArtists al, =>
			for i in [0...al]
				@addTracks tl, =>
					for j in [0...tl]
						@addVideo()



	addTracksLoop: =>
		unless @isStop
			if @similarArtists.length is 0
				clog "similarArtists is end."
				@isExhaustedArtists = true
			else
				@tracksLoopTimer = setTimeout @addTracksLoop, addTracksLoopInterval @uncheckedTracks.length
				@addTracks(DEFAULT_LIMIT_OF_TOP_TRACK)



	addVideoLoop: =>
		unless @isStop
			if @uncheckedTracks.length is 0#最初のとき
				unless @isExhaustedArtists#もう検索する余地がないか、終わりか
					setTimeout @addVideoLoop, 1000
			else
				@videoLoopTimer = setTimeout @addVideoLoop, addVideoLoopInterval @playlist.length
				@addVideo()





#---------------------------------------------------------------
	

	addArtists: (limit, callback)->
		# clog "get similar artists #{limit} ..."
		req.getSimilarArtist @artistName, @artistId, limit, (artists)=>
			unless artists				
				console.error "similarartists is NOT FOUND!!! in last.fm"
				@isError = true
			else
				# @similarArtists = artists
				for a in artists
					newArtist = {}
					newArtist.name = a.name
					newArtist.id = a.mbid
					clog newArtist.name + newArtist.id
					@similarArtists.push newArtist
				clog "+++++++++++++++++ #{@similarArtists.length} artists is added!"
			if callback then callback()


	addTracks: (limit, callback)->
		# clog "get top tracks #{limit} ..."
		artist = randomPick @similarArtists
		req.getTopTrack artist.name, artist.mbid, limit, (tracks)=>
			#debug
			unless tracks
				console.error "tracks is undifined!"
				process.exit()#debug!
			else

				newTrackList = []
				for t in tracks
					aTrack = {}
					aTrack.artist_name = t.artist.name
					aTrack.track_name = t.name
					aTrack.image_url = t.image[0]['#text'] if t.image and t.image[0]
					newTrackList.push aTrack

				@uncheckedTracks = @uncheckedTracks.concat newTrackList
				clog "#{@id} s#{@sendNum} p#{@playlist.length} t#{@uncheckedTracks.length}  + #{tracks.length} tracks +++++++++++++++++++"
				if callback then callback()


	addVideo: ->
			track = randomPick @uncheckedTracks
			if track

				keyword = track.artist_name + " " + track.track_name

				req.searchVideo keyword, 1, (videos)=>
					video = videos[0]

					unless video
						console.error "video is undifined!!!!"
					else
						title = video.snippet.title
						id = video.id.videoId



						#タイトルでフィルタリング
						if title.indexOf(track.artist_name) is -1
							return false
						#タイトルでフィルタリング
						if title.indexOf(track.track_name) is -1
							return false
						# NGワードでフィルタリング
						for ng_word in NG_WORDS
							if title.indexOf(ng_word) isnt -1
								clog "### BLOCK by NG WORD #{title} #{ng_word}"
								return false
						#できればここでplaytestをする → 終わったやつから足してく
						# @uncheckedVideos.push video
						YTParser.getUrlFromId id, (videoURL)=>
							if videoURL

								if videoURL isnt "undefined&signature=undefined"

									track.url = videoURL
									track.youtube_id = id
									#いまはとりあえず playlistに足す
									@playlist.push track
									clog "#{@id} s#{@sendNum} p#{@playlist.length} t#{@uncheckedTracks.length}  # added!　　" + id + "  " + title
									#やる？通信的に余裕があればやるか？
									#アーティストbioをここでリクエストして追加
									# setTimeout (=>
									#	appendBio(newTrack)
									# ), 1000

#---------------------------------------------------------------
	


	playTest: ->
		clog "playTest"





# ------------------------- util ------------------------------

#なくなったらundefinedがかえってくる
randomPick = (ary)->
	randIndex = Math.floor ary.length * Math.random()
	return ary.splice(randIndex,1)[0]


module.exports = Stream

