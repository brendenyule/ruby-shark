require 'httparty'
require 'json'
API_KEY  = open('classified/api_key').read.chomp
SECRET   = open('classified/secret').read.chomp
USERNAME = open('classified/username').read.chomp
PASSWORD = open('classified/password').read.chomp

class Crypt
  @@secret = SECRET

  def initialize(payload)
    @payload = payload
  end

  def signature
    secret = @@secret
    #puts "http://api.grooveshark.com/ws3.php?sig={#{secret}}"
    #puts "payload: #{@payload}"
    data = @payload
    digest = OpenSSL::Digest::MD5.new
    hmac = OpenSSL::HMAC.hexdigest(digest, secret, data)
  end
end


class Request
  @@api_key = API_KEY
  @@header  = {:wsKey => @@api_key}
  @@country = 0

  def initialize
    @payload  = Hash.new
    @username = USERNAME
    @password = PASSWORD
  end

  def send_request
    url = "https://api.grooveshark.com/ws3.php?sig=#{@signature}"
    HTTParty.get(url, {:body => @jpayload})
  end

  def create_payload
    @payload[:header] = @@header
    @jpayload = @payload.to_json
    #puts "*********************************"
    #puts @jpayload
    #puts "*********************************"
  end

  def create_signature
    @signature = Crypt.new(@jpayload).signature
  end
 
  def start_session
    @payload[:method] = "startSession"
    create_payload
    create_signature
    @@header[:sessionID] = JSON.parse(send_request.body)["result"]["sessionID"]
    authenticate(@username, @password)
  end

  def initialize_country
    get_country
    send_request
  end

  def authenticate(login, password)
    @payload[:method]     ="authenticateEx"
    @payload[:parameters] = {:login    => login, 
                             :password => password}
    #puts "payloadpayloadpayloadpayloadpayloadpayloadpayload"
    #puts @payload
    create_payload
    create_signature
    send_request
  end

  def logout
    @payload[:method] = "logout"
    create_payload
    create_signature
  end

  def get_user_id_from_username(username)
    @payload[:method]     = "getUserIDFromUsername"
    @payload[:parameters] = { :username => username }
    create_payload
    create_signature
  end

  def get_user_info
    @payload[:method] = "getUserInfo"
    create_payload
    create_signature
  end

  def get_user_subscription_details
    @payload[:method] = "getUserSubscriptionDetails"
    create_payload
    create_signature
  end

  def get_user_favorite_songs(limit=10)
    @payload[:method]     = "getUserFavoriteSongs" 
    @payload[:parameters] = {:limit => limit}
    create_payload
    create_signature
  end

  def get_does_song_exist(song_id)
    @payload[:method]     = "getDoesSongExist"
    @payload[:parameters] = {:songID => song_id}
    create_payload
    create_signature
  end

  def get_song_search_results(query, country=nil, limit=10, offset=nil)
    @payload[:method]     = "getSongSearchResults"
    @payload[:parameters] = {:query   => query,
                             :country => @@country,
                             :limit   => limit,
                             :offset  => offset}
    create_payload
    create_signature
  end

  def get_songs_info(song_ids)
    @payload[:method]     = "getSongsInfo"
    @payload[:parameters] = {:songIDs => song_ids}
    create_payload
    create_signature
  end

  def add_user_favorite_song(song_id)
    @payload[:method]     = "addUserFavoriteSong"
    @payload[:parameters] = {:songID => song_id}
    create_payload
    create_signature
  end

  def remove_user_favorite_songs(song_ids)
    @payload[:method]     = "removeUserFavoriteSongs"
    @payload[:parameters] = {:songIDs => song_ids}
    create_payload
    create_signature
  end
   
  def get_popular_songs_today(limit=10)
    @payload[:method]     = "getPopularSongsToday" 
    @payload[:parameters] = {:limit => limit}
    create_payload
    create_signature
  end

  def get_popular_songs_month(limit=10)
    @payload[:method]     = "getPopularSongsMonth" 
    @payload[:parameters] = {:limit => limit}
    create_payload
    create_signature
  end

  def get_does_album_exist(album_id)
    @payload[:method]     = "getDoesAlbumExist"
    @payload[:parameters] = {:albumID => album_id}
    create_payload
    create_signature
  end

  def get_albums_info(album_ids)
    @payload[:method]     = "getAlbumsInfo"
    @payload[:parameters] = {:albumIDs => album_ids}
    create_payload
    create_signature
  end

  def get_album_search_results(query, limit=5)
    @payload[:method]     = "getAlbumSearchResults"
    @payload[:parameters] = {:query => query,
                             :limit => limit}
    create_payload
    create_signature
  end

  def get_album_songs(album_id, limit = nil)
    @payload[:method]     = "getAlbumSongs"
    @payload[:parameters] = {:albumID => album_id,
                             :limit   => limit}
    create_payload
    create_signature
  end

  def get_does_artist_exist(artist_id)
    @payload[:method]     = "getDoesArtistExist"
    @payload[:parameters] = {:artistID => artist_id}
    create_payload
    create_signature
  end

  def get_artists_info(artist_ids)
    @payload[:method]     = "getArtistsInfo"
    @payload[:parameters] = {:artistIDs => artist_ids}
    create_payload
    create_signature
  end

  def get_artist_search_results(query, limit=5)
    @payload[:method]     = "getArtistSearchResults"
    @payload[:parameters] = {:query => query,
                             :limit => limit}
    create_payload
    create_signature
  end

  def get_artist_albums(artist_id)
    @payload[:method]     = "getArtistAlbums"
    @payload[:parameters] = {:artistID => artist_id}
    create_payload
    create_signature
  end

  def get_artist_verified_albums(artist_id)
    @payload[:method]     = "getArtistVerifiedAlbums"
    @payload[:parameters] = {:artistID => artist_id}
    create_payload
    create_signature
  end

  def get_artist_popular_songs(artist_id)
    # Returns 100 results!
    @payload[:method]     = "getArtistPopularSongs"
    @payload[:parameters] = {:artistID => artist_id}
    create_payload
    create_signature
  end

  def get_playlist(playlist_id, limit = nil)
    @payload[:method]     = "getPlaylistSongs"
    @payload[:parameters] = {:playlistID => playlist_id, 
                             :limit      => limit}
    create_payload
    create_signature
  end

  def get_playlist_info(playlist_id)
    @payload[:method]     = "getPlaylistInfo"
    @payload[:parameters] = {:playlistID => playlist_id}
    create_payload
    create_signature
  end

  def get_playlist_search_results(query, limit=5)
    @payload[:method]     = "getPlaylistSearchResults"
    @payload[:parameters] = {:query => query,
                             :limit => limit}
    create_payload
    create_signature
  end

  def get_user_playlists(limit=10)
    @payload[:method]     = "getuserplaylists"
    @payload[:parameters] = {:limit => limit}
    create_payload
    create_signature
  end
  
  def create_playlist(playlist_name, song_ids)
    @payload[:method]     = "createPlaylist"
    @payload[:parameters] = {:name => playlist_name,
                             :songIDs => song_ids}
    create_payload
    create_signature
  end

  def delete_playlist(playlist_id)
    @payload[:method]     = "deletePlaylist"
    @payload[:parameters] = {:playlistID => playlist_id}
    create_payload
    create_signature
  end

  def undelete_playlist(playlist_id)
    @payload[:method]     = "undeletePlaylist"
    @payload[:parameters] = {:playlistID => playlist_id}
    create_payload
    create_signature
  end

  def set_playlist_songs(playlist_id, song_ids)
    @payload[:method]     = "setPlaylistSongs"
    @payload[:parameters] = {:playlistID => playlist_id,
                             :songIDs    => song_ids}
    create_payload
    create_signature
  end

  def subscribe_playlist(playlist_id)
    @payload[:method]     = "subscribePlaylist"
    @payload[:parameters] = {:playlistID => playlist_id}
    create_payload
    create_signature
  end

  def unsubscribe_playlist(playlist_id)
    @payload[:method]     = "unsubscribePlaylist"
    @payload[:parameters] = {:playlistID => playlist_id}
    create_payload
    create_signature
  end

  def rename_playlist(playlist_id, playlist_name)
    @payload[:method]     = "renamePlaylist"
    @payload[:parameters] = {:playlistID => playlist_id,
                             :name       => playlist_name}
    create_payload
    create_signature
  end

  def ping_service
    @payload[:method] = "pingService"
    create_payload
    create_signature
  end
 
  def get_country(ip = nil)
    @payload[:method]     = "getCountry"
    @payload[:parameters] = {:ip => ip}
    create_payload
    create_signature
  end

  def get_service_description
    @payload[:method] = "getServiceDescription"
    create_payload
    create_signature
  end
end

#Create a session_id for other methods to use
session_init = Request.new
puts session_init.start_session

#Simple hello_world test
test = Request.new
test.ping_service
request = test.send_request
request = JSON.parse(request.body)
#puts request
puts JSON.pretty_generate(request)

