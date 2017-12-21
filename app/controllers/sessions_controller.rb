class SessionsController < ApplicationController

  get '/signup'do
    if logged_in?
      redirect "/users#{current_user.slug}"
    else
      erb :'/users/create_user'
    end
  end

  post '/signup' do
    if !complete_info_signup? || logged_in?
      redirect to '/signup'
    else
      @user = User.create(name: params[:name], email: params[:email], password: params[:password])
      session[:user_id] = @user.id
      redirect to "/users/#{@user.slug}"
    end
  end

  get '/login' do
    if logged_in?
      redirect "/users#{current_user.slug}"
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    user = User.find_by(name: params[:name])
    if !complete_info_login? && !user.authenticate
      redirect to '/signup'
    else
      session[:user_id] = user.id
      redirect "/users/#{user.slug}"
    end
  end
end
