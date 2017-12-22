require 'spec_helper'

describe ReviewsController do

  describe 'new action' do
    context 'logged in' do
      it 'lets user view new review form if logged in' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        author = Author.create(:name => "Paulo Coehlo")
        book =  Book.create(:name => "The Alchemist", :author => author)

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'Login'

        visit "/books/#{book.slug}"

        expect(page.body).to include('content')
      end
      it 'lets user create a review if they are logged in' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        author = Author.create(:name => "Paulo Coehlo")
        book =  Book.create(:name => "The Alchemist", :author => author)

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'Login'

        visit "/books/#{book.slug}"
        fill_in(:content, :with => "It was good")
        click_button 'submit'

        user = User.find_by(:email => "test@email.com")
        review = Review.find_by(:content => "It was good")
        expect(review).to be_instance_of(Review)
        expect(review.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end
      it 'does not let a user create a blank review' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        author = Author.create(:name => "Paulo Coehlo")
        book =  Book.create(:name => "The Alchemist", :author => author)

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'Login'

        visit "/books/#{book.slug}"

        fill_in(:content, :with => "")
        click_button 'submit'

        expect(Review.find_by(:content => "")).to eq(nil)
        expect(page.current_path).to eq("/books/#{book.slug}")
      end
    end
    context 'logged out' do
      it 'does not let user view new review form if not logged in' do
        author = Author.create(:name => "Paulo Coehlo")
        book =  Book.create(:name => "The Alchemist", :author => author)
        get "/books/#{boo = Book.create(:name => "The Alchemist", :author => "Paulo Coehlo").slug}"
        expect(last_response.location).to include("/login")
      end
    end
  end
  describe 'show action' do
    context 'logged in' do
      it 'displays a single review if it belongd to user' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        review = Review.create(:content => "New review", :user_id => user.id)

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'Login'

        visit "/reviews/#{review.id}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("Delete Review")
        expect(page.body).to include(review.content)
        expect(page.body).to include("Edit Review")
      end
      it 'does not let a user view a review from another user' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        user2 = User.create(:name => "User Test2", :email => "test@aol.com", :password => "789456")
        review = Review.create(:content => "It was good", :user_id => user2.id)

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'Login'

        get "/reviews/#{review.id}"

        expect(last_response.location).to include("/login")
      end
    end
    context 'logged out' do
      it 'does not let a user view a review if logged out' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        review = Review.create(:content => "New review", :user_id => user.id)
        get "/reviews/#{review.id}"
        expect(last_response.location).to include("/login")
      end
    end
  end
  describe 'edit action' do
    context "logged in" do
      it 'lets a user view review edit form if they are logged in' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        review = Review.create(:content => "reviewing!", :user_id => user.id)
        visit '/login'

        fill_in(:name, :with => "User Test")
        fill_in(:password, :with => "123456")
        click_button 'Login'
        visit "/reviews/#{review.id}/edit"
        expect(page.status_code).to eq(200)
        expect(page.body).to include(review.content)
      end
      it 'does not let a user edit a review they did not create' do
        user1 = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        review1 = Review.create(:content => "reviewing!", :user_id => user1.id)

        user2 = User.create(:name => "User Test2", :email => "email@aol.com", :password => "789456")
        review2 = Review.create(:content => "look at this review", :user_id => user2.id)

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'Login'
        session = {}
        session[:user_id] = user1.id
        visit "/reviews/#{review2.id}/edit"
        expect(page.current_path).to include("/users/#{user1.slug}")
      end
      it 'lets a user edit their own review if they are logged in' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        review = Review.create(:content => "reviewing!", :user_id => 1)

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'Login'
        visit "/reviews/#{review.id}/edit"

        fill_in(:content, :with => "i love reviewing")

        click_button 'submit'
        expect(Review.find_by(:content => "i love reviewing")).to be_instance_of(Review)
        expect(Review.find_by(:content => "reviewing!")).to eq(nil)
        expect(page.status_code).to eq(200)
      end
      it 'does not let a user edit a text with blank content' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        review = Review.create(:content => "reviewing!", :user_id => 1)
        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'Login'
        visit "/reviews/#{review.id}/edit"

        fill_in(:content, :with => "")

        click_button 'submit'
        expect(Review.find_by(:content => "i love reviewing")).to be(nil)
        expect(page.current_path).to eq("/reviews/#{review.id}/edit")
      end
    end
    context "logged out" do
      it 'does not load let user view review edit form if not logged in' do
        review = Review.create(:content => "reviewing!", :user_id => 1)
        get "/reviews/#{review.id}/edit"
        expect(last_response.location).to include("/login")
      end
    end
  end
  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own review if they are logged in' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        review = Review.create(:content => "reviewing!", :user_id => user.id)
        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'Login'
        visit "/reviews/#{review.id}"
        click_button "Delete Review"
        expect(page.status_code).to eq(200)
        expect(Review.find_by(:content => "reviewing!")).to eq(nil)
      end
      it 'does not let a user delete a review they did not create' do
        user1 = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        review1 = Review.create(:content => "reviewing!", :user_id => user1.id)

        user2 = User.create(:name => "User Test2", :email => "email@aol.com", :password => "789456")
        review2 = Review.create(:content => "look at this review", :user_id => user2.id)

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'Login'
        visit "reviews/#{review2.id}"

        expect(page.status_code).to eq(200)
        expect(page.current_path).to include('/reviews')
      end
    end
    context "logged out" do
      it 'does not load let user delete a review if not logged in' do
        review = Review.create(:content => "reviewing!")
        visit "reviews/#{review.id}"
        expect(page.current_path).to eq("/login")
      end
    end
  end
end
