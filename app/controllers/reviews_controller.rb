require 'rack-flash'

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
      redirect '/login'
    end
  end

  post '/reviews' do
    if params[:content].strip.empty?
      @book = Book.find(params[:book_id])
    elsif current_user.reviews.empty?
      Review.create(content: params[:content].strip, book_id: params[:book_id], user_id: current_user.id)
      @book = Book.find(params[:book_id])
    else
      current_user.reviews.each do |review|
        if review.book_id == params[:book_id].to_i
          @book = Book.find(params[:book_id])
        end
      end
    end
    redirect "/books/#{@book.slug}"
  end

  get '/reviews/:id/edit' do
    if !logged_in?
      redirect '/login'
    else
      @review = Review.find(params[:id])
      if current_user.id == @review.user_id
        erb :'/reviews/edit_review'
      else
        redirect '/login'
      end
    end
  end

  patch '/reviews/:id' do
    if params[:content].strip.empty?
      @review = Review.find(params[:id])
      redirect "/reviews/#{@review.id}/edit"
    else
      @review = Review.find(params[:id])
      @review.content = params[:content].strip
      @review.save
    end
  end

  delete '/reviews/:id/delete' do
    @review = Review.find(params[:id])
    @review.destroy
  end
end
