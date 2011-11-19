require 'vlc_client'

class ApplicationController < ActionController::Base
  protect_from_forgery
  VLC = VlcClient.new "localhost", "8765"
end
