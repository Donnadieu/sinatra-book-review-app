class BooksController < ApplicationController

  get '/books' do
    if logged_in?
      erb :'/books/index'
    else
      redirect '/login'
    end
  end

  get '/books/:slug' do
    if logged_in?
      @book = Book.find_by slug(params[:slug])
      erb :'/books/show_book'
    else
      redirect '/login'
    end
  end
end