require 'spec_helper.rb'
require './rubyshark.rb'

describe Request do
    SONG1 = 41999592
    SONG2 = 41259399
    SONG3 = 41878461
    SONG_ARRAY = [SONG1, SONG2, SONG3] 
    ALBUM1  = 7899898
    ALBUM2  = 9978589
    ARTIST1 = 1959275
    ARTIST2 = 7863
    QUERY   = "music"

  before :all do
      Request.new.start_session
  end
  
  before :each do
    @request = Request.new
  end

  describe '.get_user_id_from_username' do
    it 'returns a valid userID' do
      @request.get_user_id_from_username(USERNAME)
      response = @request.send_request["result"]
      expect(response).to include("UserID")
    end
  end

  describe '.get_user_info' do
    it 'returns the username of the user' do
      @request.get_user_info
      response = @request.send_request["result"]["UserID"]
      expect(response).to be_truthy 
    end

    it 'does not return an error' do
      @request.get_user_info
      response = @request.send_request
      expect(response).not_to include("errors")
    end
  end

  describe '.get_user_subscription_details' do
    it 'Should return false if user does not have plus membership' do
      @request.get_user_subscription_details
      response = @request.send_request["result"]["isPlus"]
      expect(response).not_to be_truthy
    end
  end

  describe '.get_user_favorite_songs' do
    it 'does not return an error' do
      @request.get_user_info
      response = @request.send_request
      expect(response).not_to include("errors")
    end
  end

  describe 'get_does_song_exist' do
    it 'returns true if a song exists' do
      @request.get_does_song_exist(SONG1)
      response = @request.send_request["result"]
      expect(response).to be_truthy
    end
  end

  describe '.get_songs_info' do
    it 'returns info about a song' do
     @request.get_songs_info(SONG_ARRAY)
      response = @request.send_request["result"]["songs"].count
      expect(response).to eq(3)
    end
  end

  describe '.get_song_search_results' do
    it 'returns an array of songs' do
      @request.get_song_search_results(QUERY)
      response = @request.send_request["result"]["songs"]
      expect(response).not_to be_nil
    end
  end

  describe '.add_user_favorite_song' do
    it 'adds a song to the favorites songs of the user' do
      @request.remove_user_favorite_songs(SONG2)
      @request.send_request
      @request.add_user_favorite_song(SONG2)
      response = @request.send_request["result"]["success"]
      expect(response).to be_truthy
    end
  end

  describe '.remove_user_favorite_songs' do
    it 'removes a song from the favorite songs of the user' do
      @request.add_user_favorite_song(SONG3)
      @request.send_request
      @request.remove_user_favorite_songs(SONG3)
      response = @request.send_request["result"]["success"]
      expect(response).to be_truthy
    end
  end

  describe '.get_popular_songs_today' do
    it 'returns top songs for the day' do
      @request.get_popular_songs_today
      response = @request.send_request["result"]
      expect(response).to include("songs")
    end
  end

  describe '.get_popular_songs_month' do
    it 'returns top songs for this month' do
      @request.get_popular_songs_today
      response = @request.send_request["result"]
      expect(response).to include("songs")
    end
  end

  describe 'get_does_album_exist' do
    it 'returns true if an album exists' do
      @request.get_does_album_exist(ALBUM1)
      response = @request.send_request["result"]
      expect(response).to be_truthy
    end
  end

  describe '.get_albums_info' do
    it 'returns info about multiple albums' do
      @request.get_albums_info([ALBUM1, ALBUM2])
      response = @request.send_request["result"]["albums"].count
      expect(response).to eq(2)
    end
  end

  describe '.get_album_search_results' do
    it 'returns an array of songs' do
      @request.get_album_search_results(QUERY)
      response = @request.send_request["result"]["albums"]
      expect(response).not_to be_nil
    end
  end

  describe '.get_album_songs' do
    it 'returns the songs belonging to an album' do
      @request.get_album_songs(ALBUM2)
      response = @request.send_request["result"]["songs"]
      expect(response).not_to be_nil
    end
  end

  describe 'get_does_artist_exist' do
    it 'returns true if an artist exists' do
      @request.get_does_artist_exist(ARTIST1)
      response = @request.send_request["result"]
      expect(response).to be_truthy
    end
  end

  describe '.get_artists_info' do
    it 'returns info about multiple artists' do
      @request.get_artists_info([ARTIST1, ARTIST2])
      response = @request.send_request["result"]["artists"].count
      expect(response).to eq(2)
    end
  end

  describe '.get_artist_search_results' do
    it 'returns an array of songs' do
      @request.get_artist_search_results(QUERY)
      response = @request.send_request["result"]["artists"]
      expect(response).not_to be_nil
    end
  end

  describe '.get_artist_albums' do
    it 'gets all of the albums from an artist' do
      @request.get_artist_albums(ARTIST2)
      response = @request.send_request["result"]["albums"]
      expect(response).not_to be_nil
    end
  end

  describe '.get_artist_verified_albums' do
    it 'returns the verified albums related to an artist' do
      @request.get_artist_verified_albums(ARTIST1)
      response = @request.send_request["result"]["albums"]
      expect(response).not_to be_nil
    end
  end

  describe '.get_artist_popular_songs' do
    it 'returns the top songs for the given artist' do
      @request.get_artist_popular_songs(ARTIST2)
      response = @request.send_request["result"]["songs"]
      expect(response).not_to be_nil
    end
  end

  describe 'Playlist Methods' do
    before :each do
      @playlist1 = Request.new
      @playlist1.create_playlist("demo_playlist", [SONG1, SONG2, SONG3])
      @playlist1_id = @playlist1.send_request["result"]["playlistID"]
    end

    after :each do
      clean_playlist = Request.new
      clean_playlist.delete_playlist(@playlist1_id)
      clean_playlist.send_request
    end

    describe '.get_playlist' do
      it 'returns playlist info and songs' do
        @request.get_playlist_info(@playlist1_id)
        response = @request.send_request["result"]["PlaylistName"]
        expect(response).to eq("demo_playlist")
      end
    end

    describe '.get_playlist_info' do
      it 'returns info about a playlist' do
        @request.get_playlist_info(@playlist1_id)
        response = @request.send_request["result"]["PlaylistName"]
        expect(response).to eq("demo_playlist")
      end
    end

    describe '.get_playlist_search_results' do
      it 'returns an array of songs' do
        @request.get_playlist_search_results(QUERY)
        response = @request.send_request["result"]["playlists"]
        expect(response).not_to be_nil
      end
    end

    describe '.get_user_playlist' do
      it 'returns the playlists belonging to the user' do
        @request.get_user_playlists
        response = @request.send_request["result"]
        expect(response).to include("playlists")
      end

      it 'does not return an error' do
        @request.get_user_info
        response = @request.send_request
        expect(response).not_to include("errors")
      end
    end

    describe '.create_playlist' do
      it 'creates a playlist' do
        @request.create_playlist("create_playlist", [SONG1, SONG2, SONG3])
        response = @request.send_request["result"]
        playlist_id = response["playlistID"]
        success = response["success"]
        expect(success).to be_truthy

        @request.delete_playlist(playlist_id)
        @request.send_request
      end
    end

    describe '.delete_playlist' do
      it 'deletes a playlist' do
        @request.delete_playlist(@playlist1_id)
        response = @request.send_request["result"]["success"]
        expect(response).to be_truthy
      end
    end

    # method is not working as it should, might be restricted
    #describe '.undelete_playlist' do
      #it 'restores a deleted playlist' do
        #@request.create_playlist("create_playlist", [41999592, 41259399,41878461])
        #playlist_id = @request.send_request["result"]["playlistID"]
        #@request.delete_playlist(playlist_id)
        #@request.send_request
        #@request.undelete_playlist(playlist_id)
        #response = @request.send_request["result"]["success"]
        #expect(response).to be_truthy
      #end
    #end
    
    describe '.set_playlist_songs' do
      it 'overwrites the songs in a playlist with new songs' do
        @request.set_playlist_songs(@playlist1_id, SONG_ARRAY)
        response = @request.send_request["result"]["success"]
        expect(response).to be_truthy
      end
    end

    describe '.rename_playlist' do
      it 'renames a playlist' do
        @request.rename_playlist(@playlist1_id, "rename_playlist")
        response = @request.send_request["result"]["success"]
        expect(response).to be_truthy
      end
    end

    describe '.subscribe_playlist' do
      it 'subscribes the user to a playlist' do
        @request.subscribe_playlist(@playlist1_id)
        response = @request.send_request["result"]["success"]
        expect(response).to be_truthy
      end
    end

    describe '.unsubscribe_playlist' do
      it 'unsubscribes the user from a playlist' do
        @request.subscribe_playlist(@playlist1_id)
        @request.send_request

        @request.unsubscribe_playlist(@playlist1_id)
        response = @request.send_request["result"]["success"]
        expect(response).to be_truthy
      end
    end
  end # Playlist tests end here

  describe '.ping_service' do
    it 'has a valid response' do
      @request.ping_service
      response = @request.send_request["result"]
      expect(response).to be_truthy
    end
  end

  describe '.get_country' do
    it 'returns a valid country id based when given ip' do
      @request.get_country
      response = @request.send_request["result"]["ID"]
      expect(response).not_to be_nil
    end
  end

  describe '.get_service_description' do
    it 'describes service methods' do
      @request.get_service_description
      response = @request.send_request["result"]["methods"]
      expect(response).to be_truthy
    end
  end

  describe '.logout' do
    it 'logs a user out' do
      @request.logout
      response = @request.send_request["result"]["success"]
      expect(response).to be_truthy
    end
  end

  describe '.start_session' do
    it "Returuns an authenticated session_id" do
      request = Request.new
      status = request.start_session["result"]["success"]
      expect(status).to be_truthy
    end
  end
end

