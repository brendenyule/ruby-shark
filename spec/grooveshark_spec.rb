require 'spec_helper.rb'
require './rubyshark.rb'

describe Request do
  #describe '.start_session' do
    #it "Returuns an authenticated session_id" do
      #request = Request.new
      #status = request.start_session["result"]["success"]
      #expect(status).to be_truthy
    #end
  #end

  before :all do
      Request.new.start_session
  end
  
  before :each do
    @request = Request.new
  end

  describe '.get_user_playlist' do
    it 'does not return an error' do
      @request.get_user_info
      response = @request.send_request
      expect(response).not_to include("errors")
    end
  end


  describe '.get_user_favorite_songs' do
    it 'does not return an error' do
      @request.get_user_info
      response = @request.send_request
      expect(response).not_to include("errors")
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


  describe '.get_user_playlists' do
    it 'returns the playlists belonging to the user' do
    end
  end


  describe '.get_user_subscription_details' do
    it 'Should return false if user does not have plus membership' do
      @request.get_user_subscription_details
      response = @request.send_request["result"]["isPlus"]
      expect(response).not_to be_truthy
    end
  end


  describe '.add_user_favorite_song' do
    it 'adds a song to the favorites songs of the user' do
    end
  end
  

  describe '.remove_user_favorite_song' do
    it 'removes a song from the favorite songs of the user' do
    end
  end


  describe '.subscribe_playlist' do
    it 'subscribes the user to a playlist' do
    end
  end


  describe '.unsubscribe_playlist' do
    it 'unsubscribes the user from a playlist' do
    end
  end


  describe '.get_country' do
    it 'returns a valid country id based when given ip' do
      @request.get_country
      response = @request.send_request["result"]["ID"]
      expect(response).not_to be_nil
    end
  end


  describe '.get_playlist_info' do
    it 'returns info about a playlist' do
    end
  end


  describe '.get_popular_songs_today' do
    it 'returns top songs for the day' do
    end
  end


  describe '.get_popular_songs_month' do
    it 'returns top songs for this month' do
    end
  end


  describe '.ping_service' do
    it 'has a valid response' do
      @request.ping_service
      response = @request.send_request["result"]
      expect(response).to be_truthy
    end
  end


  describe '.get_service_description' do
    it 'describes service methods' do
    end
  end


  describe '.undelete_playlist' do
    it 'restores a deleted playlist' do
    end
  end


  describe '.delete_playlist' do
    it 'deletes a playlist' do
    end
  end


  describe '.get_playlist' do
    it 'returns playlist info and songs' do
    end
  end

  
  describe '.set_playlist_songs' do
    it 'overwrites the songs in a playlist with new songs' do
    end
  end


  describe '.create_playlist' do
    it 'creates a playlist' do
    end
  end


  describe '.rename_playlist' do
    it 'renames a playlist' do
    end
  end


  describe '.get_user_id_from_username' do
    it 'returns a valid userID' do
    end
  end


  describe '.create_playlist' do
    it 'creates a valid playlist' do
    end
  end


  describe '.get_album_songs' do
    it 'returns the songs belonging to an album' do
    end
  end


  describe '.get_artist_info' do
    it 'returns info about a artist' do
    end
  end


  describe '.get_album_info' do
    it 'returns info about a album' do
    end
  end


  describe '.get_songs_info' do
    it 'returns info about a song' do
    end
  end


  describe 'get_does_song_exist' do
    it 'returns true if a song exists' do
    end
  end


  describe 'get_does_artist_exist' do
    it 'returns true if an artist exists' do
    end
  end


  describe 'get_does_album_exist' do
    it 'returns true if an album exists' do
    end
  end


  describe '.get_artist_albums' do
    it 'gets all of the albums from an artist' do
    end
  end


  describe '.get_artist_verified_albums' do
    it 'returns the verified albums related to an artist' do
    end
  end

  describe '.get_artist_popular_song' do
    it 'returns the top songs for the given artist' do
    end
  end

  describe '.logout' do
    it 'logs a user out' do
      @request.logout
      response = @request.send_request["result"]["success"]
      expect(response).to be_truthy
    end
  end
end

