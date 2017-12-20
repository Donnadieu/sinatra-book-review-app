require 'spec_helper'

describe UsersController do

  describe 'user show page' do
    it 'shows all a single users reviews' do
      user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
      review1 = Review.create(:content => "It was good!", :user_id => user.id)
      review2 = Review.create(:content => "It was bad", :user_id => user.id)
      get "/users/#{user.slug}"

      expect(last_response.body).to include("It was good!")
      expect(last_response.body).to include("It was bad :)")
    end
  end

  describe 'index action' do
    context 'logged in' do
      it 'lets a user view the books index if logged in' do

        user1 = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        review1 = Review.create(:content => "It was good!", :user_id => user1.id)

        user2 = User.create(:name => "user test2", :email => "test@aol.com", :password => "789456")
        review2 = Review.create(:content => "It was bad", :user_id => user2.id)

        visit '/login'

        fill_in(:name, :with => "User Test")
        fill_in(:password, :with => "user test2")
        click_button 'submit'
        visit "/books"
        expect(page.body).to include(review1.content)
        expect(page.body).to include(review2.content)
      end
    end
  end
end
