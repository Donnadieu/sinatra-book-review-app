class SearchController < ApplicationController
  use Rack::Flash

  post '/books/search' do
    BookScraper.search(params[:search_term])
    @search_results = Book.search(params[:search_term])

    if @search_results.empty?
      flash[:message] = "No book found with that query try again"
      erb :'/search_results'
    else
      erb :'/search_results'
    end
  end
end
