require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base  

  configure do
    set :public_folder, 'app/public'
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do
    erb :index
  end

  helpers do

    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def logout
      session.destroy
    end

    def complete_info_signup?
      !params[:name].empty? && !params[:email].empty? && !params[:password].empty?
    end

    def complete_info_login?
      !params[:email].empty? && !params[:password].empty?
    end
  end
end
