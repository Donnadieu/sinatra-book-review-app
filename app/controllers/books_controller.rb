class BooksController < ApplicationController

  get '/books' do
    if logged_in?
      erb :'/books/index'
    else
      redirect '/login'
    end
  end
end
