class AuthorsController < ApplicationController
  use Rack::Flash
  
  get '/authors' do
    if logged_in?
      @selected_letter = params[:selected_letter]
      if params[:selected_letter] == nil
        @authors = Author.order(:name)
      else
        @authors = Author.where("name LIKE '#{@selected_letter}'")
      end
      erb :'/authors/authors'
    else
      redirect '/login'
    end
  end


  get '/authors/:slug' do
    if logged_in? && @author = Author.find_by_slug(params[:slug])
      erb :'/authors/show_author'
    else
      redirect '/login'
    end
  end
end
