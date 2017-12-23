class SearchController < ApplicationController

  post '/books/search' do
    BookScraper.search(params[:search_term])
    @search_results = Book.search(params[:search_term])
    erb :'/search_results'
  end
end
