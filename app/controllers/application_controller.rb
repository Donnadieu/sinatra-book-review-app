require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'app/public'
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end
end
