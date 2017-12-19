class SessionsController < ApplicationController

  get '/login' do

  end

  get '/signup'do
    erb :create_user
  end
end
