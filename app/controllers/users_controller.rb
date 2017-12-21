class UsersController < ApplicationController

  get '/users/:slug' do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      erb :'/users/show_user'
    else
      redirect '/login'
    end
  end
end
