require 'spec_helper'

describe UsersController do

  describe 'user show action' do
    context 'logged in' do
      it 'shows a single user reviews if logged in' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        book1 =  Book.create(:name => "The Alchemist")
        book2 = Book.create(:name => "The Fifth Mountain")
        review1 = Review.create(:content => "It was good!", :user_id => user.id, :book_id => book1.id)
        review2 = Review.create(:content => "It was bad", :user_id => user.id, :book_id => book2.id)

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'Login'

        visit "/users/#{user.slug}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("#{review1.content}")
        expect(page.body).to include("#{review2.content}")
      end
    end
    context 'logged out' do
      it 'does not let a user view the reviews if logged out' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")

        get "/users/#{user.slug}"

        expect(last_response.location).to include("/login")
      end
    end
  end
end
