require './rubyshark.rb'

session_init = Request.new
session_init.start_session

playlist_cleanup = Request.new
playlist_cleanup.get_user_playlists
request = playlist_cleanup.send_request["result"]["playlists"]
puts request
request.each do |playlist|
  playlist_id = playlist["PlaylistID"]
  puts playlist_id
  playlist_cleanup.delete_playlist(playlist_id)
  playlist_cleanup.send_request
end
        
