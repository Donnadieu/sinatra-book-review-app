class ReviewsController < ApplicationController

  get '/reviews' do
    if logged_in?
      erb :'/reviews/index'
    else
      redirect '/login'
    end
  end

  get '/reviews/:id' do
    if @review = Review.find(params[:id])
      if logged_in? && current_user.id == @review.user_id
        erb :'/reviews/show_review'
      else
        redirect '/login'
      end
    else
      redirect
    end
  end
end
