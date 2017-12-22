class SessionsController < ApplicationController

  get '/signup'do
    if logged_in?
      redirect "/users/#{current_user.slug}"
    else
      erb :'/users/create_user'
    end
  end

  post '/signup' do
    if !complete_info_signup? || logged_in?
      redirect to '/signup'
    elsif user = User.find_by(email: params[:email])
      redirect to '/login'
    else
      @user = User.create(name: params[:name], email: params[:email], password: params[:password])
      session[:user_id] = @user.id
      redirect to "/users/#{@user.slug}"
    end
  end

  get '/login' do
    if logged_in?
      redirect "/users/#{current_user.slug}"
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    user = User.find_by(email: params[:email])
    if !complete_info_login? && !user.authenticate || user == nil
      redirect to '/signup'
    else
      session[:user_id] = user.id
      redirect "/users/#{user.slug}"
    end
  end

  get '/logout' do
    if logged_in?
      logout
      redirect '/'
    else
      redirect '/'
    end
  end
end
