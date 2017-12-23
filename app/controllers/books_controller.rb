class BooksController < ApplicationController
  use Rack::Flash

  get '/books' do
    if logged_in?
      @selected_letter = params[:selected_letter]
      if params[:selected_letter] == nil
        @books = Book.order(:name)
      else
        @books = Book.where("name LIKE '#{@selected_letter}'")
      end
      erb :'/books/books'
    else
      redirect '/login'
    end
  end

  get '/books/:slug' do
    if logged_in? && @book = Book.find_by_slug(params[:slug])
      erb :'/books/show_book'
    else
      redirect '/login'
    end
  end
end
