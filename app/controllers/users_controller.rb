class UsersController < ApplicationController

  get '/users/:slug' do
    erb :'/users/show_user'
  end
end
