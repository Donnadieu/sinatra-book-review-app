class AuthorsController < ApplicationController

  get '/authors' do
    if logged_in?
      erb :'/authors/index'
    else
      redirect '/login'
    end
  end

  get '/authors/:slug' do
    if logged_in? && @author = Author.find_by_slug(params[:slug])
      erb :'/authors/show_book'
    else
      redirect '/login'
    end
  end
end
