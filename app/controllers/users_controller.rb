class UsersController < ApplicationController

  get '/users/:slug' do
    if logged_in? && current_user
      @reviews  = current_user.reviews
      erb :'/users/show_user'
    else
      redirect '/login'
    end
  end
end
