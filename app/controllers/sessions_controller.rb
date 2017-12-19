class SessionsController < ApplicationController

  get '/login' do

  end

  get '/signup'do
    erb :'/users/create_user'
  end
end
