
clog = (s) -> console.log s
clog "stream.coffee"



req = require './request.js'
moment = require "moment"



#------------------------- TUNING -------------------------------

#最初に最速で一番近い50曲とる
FIRST_ARTIST_LIMIT = 10
FIRST_TRACK_LIMIT = 5

DELAY_OF_START_MAIN_LOOP = 5000

addTracksLoopInterval = (tracks_num)->
	delay = tracks_num * 1000 + 1000# TODO あとでもう少しちゃんと考える
	console.log "wait for adding top track " + delay + "msec"
	return delay


# TODO トラックの数に応じてリクエストの間隔をずらす	
addVideoLoopInterval = ()->
	return 5000


DEFAULT_LIMIT_OF_TOP_TRACK = 999

#----------------------------------------------------------------


NG_WORDS = [
	"歌ってみ"
	"うたってみ"
	"カラオケ"
	"カバー"
	"cover"
	"コピー"
	"copy"
	"ピッチ"
	"弾いてみ"
	"ｺﾋﾟｰ"
	"メドレー"
	"ﾒﾄﾞﾚｰ"
	"BGM"
	"作業用"
	]



class Stream


	constructor: (@artistName, @artistId)->
		self = @
		@uncheckedTracks = []
		@uncheckedVideos = []
		@playlist = []
		@similarArtists = []
		@id = moment().unix()

		self.startStream()

		@isStartAddTracksLoop = false
		@isStartAddVideosLoop = false

		# req.getSimilarArtist @artistName, @artistId, (artists)->
		# 	self.similarArtists = artists

		# 	clog artists

		# 	self.startStream()




#----------- public API --------------
	popTracks: ->
		clog "popTracks"
		#playlistの数が一定に満たない時はfastPlaylistからランダムに渡してく	


	stop: ->
		clog "stop stream"




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
		if @similarArtists.length is 0
			clog "similarArtists is end."
		else
			setTimeout @addTracksLoop, addTracksLoopInterval @uncheckedTracks.length
			@addTracks(DEFAULT_LIMIT_OF_TOP_TRACK)



	addVideoLoop: =>
		if @uncheckedTracks.length is 0#最初のとき
			setTimeout @addVideoLoop, 1000
		else	
			setTimeout @addVideoLoop, addVideoLoopInterval()
			@addVideo()





#---------------------------------------------------------------
	

	addArtists: (limit, callback)->
		clog "get similar artists #{limit} ..."
		req.getSimilarArtist @artistName, @artistId, limit, (artists)=>
			unless artists
				console.error "artists is undifined!"
				process.exit()#debug!
			else
				@similarArtists = artists
				clog "#{artists.length} artists is added!"
			if callback then callback()


	addTracks: (limit, callback)->
		clog "get top tracks #{limit} ..."
		similarArtist = randomPick @similarArtists
		req.getTopTrack similarArtist.name, similarArtist.mbid, limit, (tracks)=>
			#debug
			unless tracks
				console.error "tracks is undifined!"
				process.exit()#debug!
			else
				@uncheckedTracks = @uncheckedTracks.concat tracks
				clog "got #{tracks.length} uncheckedTracks"
				clog "current uncheckedTracks: " + @uncheckedTracks.length
				if callback then callback()


	addVideo: ->
			track = randomPick @uncheckedTracks
			clog "getVideo ... (" + track.artist.name + " / " + track.name + ")"

			#ここでYouTube検索をする。
			keyword = track.artist.name + " " + track.name
			#TODO 1でいのかな？　3くらいにしといて、キーワードチェックすべき？	
			req.searchVideo keyword, 1, (videos)=>
				video = videos[0]

				unless video
					console.error "video is undifined!!!!"
				else

					title = video.snippet.title
					id = video.id.videoId

					#タイトルでフィルタリング
					for ng_word in NG_WORDS
						if title.indexOf(ng_word) isnt -1
							clog "### BLOCK by NG WORD #{title} #{ng_word}"
							return false

					#できればここでplaytestをする → 終わったやつから足してく
					# @uncheckedVideos.push video

					#できればここでアーティスト情報を追加

					#ここで必要な情報だけのオブジェクトにする

					#いまはとりあえず playlistに足す

					clog " # # # added ! # # #   " + id + "   " + title
					@playlist.push video




#---------------------------------------------------------------
	


	playTest: ->
		clog "playTest"





# ------------------------- util ------------------------------

#なくなったらundefinedがかえってくる
randomPick = (ary)->
	randIndex = Math.floor ary.length * Math.random()
	return ary.splice(randIndex,1)[0]


module.exports = Stream



#-------------------------------------------------------------------------------------------------------------------------
`
var testArtists =
	[ { name: 'the HIATUS',
    mbid: '03a457ae-2307-4e7f-bc99-ae48316a214f',
    match: '1',
    url: 'www.last.fm/music/the+HIATUS',
    image: [ [Object], [Object], [Object], [Object], [Object] ],
    streamable: '0' },
  { name: 'ストレイテナー',
    mbid: '',
    match: '0.529075',
    url: 'www.last.fm/music/%E3%82%B9%E3%83%88%E3%83%AC%E3%82%A4%E3%83%86%E3%83%8A%E3%83%BC',
    image: [ [Object], [Object], [Object], [Object], [Object] ],
    streamable: '0' },
  { name: 'Nothing\'s Carved In Stone',
    mbid: '',
    match: '0.417177',
    url: 'www.last.fm/music/Nothing%27s+Carved+In+Stone',
    image: [ [Object], [Object], [Object], [Object], [Object] ],
    streamable: '0' },
  { name: '[Champagne]',
    mbid: '',
    match: '0.394879',
    url: 'www.last.fm/music/%5BChampagne%5D',
    image: [ [Object], [Object], [Object], [Object], [Object] ],
    streamable: '0' },
  { name: '10-FEET',
    mbid: 'e000f4d8-b722-4120-9b5d-0a13d6f39be3',
    match: '0.376297',
    url: 'www.last.fm/music/10-FEET',
    image: [ [Object], [Object], [Object], [Object], [Object] ],
    streamable: '0' },
  { name: 'ASIAN KUNG-FU GENERATION',
    mbid: '14e410f5-97f2-48ba-b1f7-a3a44cbea05c',
    match: '0.340997',
    url: 'www.last.fm/music/ASIAN+KUNG-FU+GENERATION',
    image: [ [Object], [Object], [Object], [Object], [Object] ],
    streamable: '0' },
  { name: 'MAN WITH A MISSION',
    mbid: 'd1c5a553-1fd0-43ca-a66a-da94c9f15570',
    match: '0.329277',
    url: 'www.last.fm/music/MAN+WITH+A+MISSION',
    image: [ [Object], [Object], [Object], [Object], [Object] ],
    streamable: '0' },
  { name: 'RADWIMPS',
    mbid: '6f500293-7396-4903-b4fd-118127d06f9e',
    match: '0.32335',
    url: 'www.last.fm/music/RADWIMPS',
    image: [ [Object], [Object], [Object], [Object], [Object] ],
    streamable: '0' },
  { name: 'ACIDMAN',
    mbid: '245462fb-c007-422a-9b89-88d285e890dd',
    match: '0.310989',
    url: 'www.last.fm/music/ACIDMAN',
    image: [ [Object], [Object], [Object], [Object], [Object] ],
    streamable: '0' },
  { name: 'locofrank',
    mbid: '09907717-b521-444d-847c-3c42c4c591ed',
    match: '0.305419',
    url: 'www.last.fm/music/locofrank',
    image: [ [Object], [Object], [Object], [Object], [Object] ],
    streamable: '0' } ]
`


