class ReviewsController < ApplicationController
  use Rack::Flash

  get '/reviews' do
    if logged_in?
      @reviews = Review.all
      erb :'/reviews/reviews'
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
      flash[:message] = "Review must a have content"
      @book = Book.find(params[:book_id])
    elsif current_user.reviews.empty?
      Review.create(content: params[:content].strip, book_id: params[:book_id], user_id: current_user.id)
      flash[:message] = "Review succesfully posted"
      @book = Book.find(params[:book_id])
    else
      current_user.reviews.each do |review|
        if review.book_id == params[:book_id].to_i
          @book = Book.find(params[:book_id])
        else
          Review.create(content: params[:content].strip, book_id: params[:book_id], user_id: current_user.id)
          flash[:message] = "Review succesfully created"
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
      flash[:message] = "Review must have content"
      @review = Review.find(params[:id])
      redirect "/reviews/#{@review.id}/edit"
    else
      flash[:message] = "Review succesfully updated"
      @review = Review.find(params[:id])
      @review.content = params[:content].strip
      @review.save
      redirect "/reviews/#{@review.id}/edit"
    end
  end

  delete '/reviews/:id/delete' do
    @review = Review.find(params[:id])
    @book = @review.book
    @review.destroy
    flash[:message] = "Review succesfully deleted"
    redirect "/books/#{@book.slug}"
  end
end
