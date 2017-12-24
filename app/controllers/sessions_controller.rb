class SessionsController < ApplicationController
  use Rack::Flash

  get '/signup'do
    if logged_in?
      redirect "/users/#{current_user.slug}"
    else
      erb :'/users/create_user'
    end
  end

  post '/signup' do
    if !complete_info_signup?
      flash[:message] = "All fields must be filled."
      redirect to '/signup'
    elsif !params[:email].include?("@")
      flash[:message] = "Please enter a valid email"
      redirect to '/signup'
    elsif user = User.find_by(email: params[:email])
      flash[:message] = "Email already registered."
      binding.pry
      erb :'/users/create_user'
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
    user = User.find_by(:email => params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/users/#{user.slug}"
    else
      flash[:message] = "Incorrect login details"

      erb :'/users/login'
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
