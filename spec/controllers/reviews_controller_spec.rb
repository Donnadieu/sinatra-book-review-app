require 'spec_helper'

describe ReviewsController do

  describe 'new action' do
    context 'logged in' do
      it 'lets user view new review form if logged in' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        book =  Book.create(:name => "The Alchemist")

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'submit'
        visit "/books/#{book.slug}"
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a review if they are logged in' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        book =  Book.create(:name => "The Alchemist")

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'submit'

        visit "/books/#{book.slug}"
        fill_in(:content, :with => "I was good")
        click_button 'submit'

        user = User.find_by(:email => "test@email.com")
        review = Review.find_by(:content => "It was good")
        expect(review).to be_instance_of(Review)
        expect(review.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user review from another user' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        user2 = User.create(:name => "User Test2", :email => "test@aol.com", :password => "789456")
        book =  Book.create(:name => "The Alchemist")

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'submit'

        visit "/reviews/books/#{book.slug}"

        fill_in(:content, :with => "Review")
        click_button 'submit'

        user1 = User.find_by(:id => user1.id)
        user2 = User.find_by(:id => user2.id)
        review = Review.find_by(:content => "Review")
        expect(review).to be_instance_of(Review)
        expect(review.user_id).to eq(user.id)
        expect(review.user_id).not_to eq(user2.id)
      end

      it 'does not let a user create a blank review' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        book =  Book.create(:name => "The Alchemist")

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'submit'

        visit "/books/#{book.slug}"

        fill_in(:content, :with => "")
        click_button 'submit'

        expect(Review.find_by(:content => "")).to eq(nil)
        expect(page.current_path).to eq("/books/#{book.slug}")
      end
    end

    context 'logged out' do
      it 'does not let user view new review form if not logged in' do
        book =  Book.create(:name => "The Alchemist")
        get "/books/#{book.slug}"
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single review' do

        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        review = Review.create(:content => "New review", :user_id => user.id)

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'submit'

        visit "/reviews/#{review.id}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("Delete Review")
        expect(page.body).to include(review.content)
        expect(page.body).to include("Edit Review")
      end
    end

    context 'logged out' do
      it 'does not let a user view a review' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        review = Review.create(:content => "New review", :user_id => user.id)
        get "/review/#{review.id}"
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view review edit form if they are logged in' do
        user = User.create(:username => "User Test", :email => "test@email.com", :password => "123456")
        review = Review.create(:content => "reviewing!", :user_id => user.id)
        visit '/login'

        fill_in(:username, :with => "User Test")
        fill_in(:password, :with => "123456")
        click_button 'submit'
        visit '/reviews/1/edit'
        expect(page.status_code).to eq(200)
        expect(page.body).to include(review.content)
      end

      it 'does not let a user edit a review they did not create' do
        user1 = User.create(:username => "User Test", :email => "test@email.com", :password => "123456")
        review1 = Review.create(:content => "reviewing!", :user_id => user1.id)

        user2 = User.create(:username => "User Test2", :email => "email@aol.com", :password => "789456")
        review2 = Review.create(:content => "look at this review", :user_id => user2.id)

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'submit'
        session = {}
        session[:user_id] = user1.id
        visit "/reviews/#{review2.id}/edit"
        expect(page.current_path).to include('/books')
      end

      it 'lets a user edit their own review if they are logged in' do
        user = User.create(:username => "User Test", :email => "test@email.com", :password => "123456")
        review = Review.create(:content => "reviewing!", :user_id => 1)
        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'submit'
        visit '/reviews/1/edit'

        fill_in(:content, :with => "i love reviewing")

        click_button 'submit'
        expect(Review.find_by(:content => "i love reviewing")).to be_instance_of(Review)
        expect(Review.find_by(:content => "reviewing!")).to eq(nil)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a text with blank content' do
        user = User.create(:username => "User Test", :email => "test@email.com", :password => "123456")
        review = Review.create(:content => "reviewing!", :user_id => 1)
        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'submit'
        visit '/reviews/1/edit'

        fill_in(:content, :with => "")

        click_button 'submit'
        expect(Review.find_by(:content => "i love reviewing")).to be(nil)
        expect(page.current_path).to eq("/reviews/1/edit")
      end
    end

    context "logged out" do
      it 'does not load let user view review edit form if not logged in' do
        get '/reviews/1/edit'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own review if they are logged in' do
        user = User.create(:username => "User Test", :email => "test@email.com", :password => "123456")
        review = Review.create(:content => "reviewing!", :user_id => 1)
        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'submit'
        visit 'reviews/1'
        click_button "Delete Review"
        expect(page.status_code).to eq(200)
        expect(Review.find_by(:content => "reviewing!")).to eq(nil)
      end

      it 'does not let a user delete a review they did not create' do
        user1 = User.create(:username => "User Test", :email => "test@email.com", :password => "123456")
        review1 = Review.create(:content => "reviewing!", :user_id => user1.id)

        user2 = User.create(:username => "User Test2", :email => "email@aol.com", :password => "789456")
        review2 = Review.create(:content => "look at this review", :user_id => user2.id)

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'submit'
        visit "reviews/#{review2.id}"
        click_button "Delete Review"
        expect(page.status_code).to eq(200)
        expect(Review.find_by(:content => "look at this review")).to be_instance_of(Review)
        expect(page.current_path).to include('/reviews')
      end
    end

    context "logged out" do
      it 'does not load let user delete a review if not logged in' do
        review = Review.create(:content => "reviewing!", :user_id => 1)
        visit '/reviews/1'
        expect(page.current_path).to eq("/login")
      end
    end
  end
end
