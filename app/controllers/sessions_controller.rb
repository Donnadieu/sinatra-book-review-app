class SessionsController < ApplicationController
  use Rack::Flash
    
  get '/login' do
    if logged_in?
      redirect "/users/#{current_user.slug}"
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    user = User.find_by(:email => params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/users/#{user.slug}"
    else
      flash[:message] = "Incorrect login details"
      redirect "/login"
    end
  end

  get '/signup'do
    if logged_in?
      redirect "/users/#{current_user.slug}"
    else
      erb :'/users/create_user'
    end
  end

  post '/signup' do
    if user = User.find_by(email: params[:email])
      flash[:message] = "Email already registered."
      redirect "/login"
    else
      @user = User.create(name: params[:name], email: params[:email], password: params[:password])
      session[:user_id] = @user.id
      redirect "/users/#{@user.slug}"
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
