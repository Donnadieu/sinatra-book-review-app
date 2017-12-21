class ReviewsController < ApplicationController

  get '/reviews' do
    if logged_in?
      erb :'/reviews/index'
    else
      redirect '/login'
    end
  end

  get '/reviews/:id' do
    if logged_in?
    end     

  end
end
