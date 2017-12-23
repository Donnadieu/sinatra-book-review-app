class BooksController < ApplicationController

  get '/books' do
    if logged_in?
      @books = Book.all
      erb :'/books/index'
    else
      redirect '/login'
    end
  end

  post '/books/search' do
    BookScraper.search(params[:search_term])
  end

  get '/books/:slug' do
    if logged_in? && @book = Book.find_by_slug(params[:slug])
      erb :'/books/show_book'
    else
      redirect '/login'
    end
  end
end
