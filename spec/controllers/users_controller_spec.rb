require 'spec_helper'

describe UsersController do

  describe 'user show action' do
    context 'logged in' do
      it 'shows a single user reviews if logged in' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        review1 = Review.create(:content => "It was good!", :user_id => user.id)
        review2 = Review.create(:content => "It was bad", :user_id => user.id)

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'submit'
        get "/users/#{user.slug}"

        expect(last_response.body).to include("It was good!")
        expect(last_response.body).to include("It was bad :)")
      end
    end
    context 'logged out' do
      it 'does not let a user view the reviews if logged out' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
        review = Review.create(:content => "New review", :user_id => user.id)
        get "/user/#{user.slug}"
        expect(last_response.location).to include("/login")
      end
    end
  end
end
# describe 'index action' do
#   context 'logged in' do
#     it 'lets a user view the books index if logged in' do
#
#       user1 = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
#       review1 = Review.create(:content => "It was good!", :user_id => user1.id)
#
#       user2 = User.create(:name => "user test2", :email => "test@aol.com", :password => "789456")
#       review2 = Review.create(:content => "It was bad", :user_id => user2.id)
#
#       visit '/login'
#
#       fill_in(:name, :with => "User Test")
#       fill_in(:password, :with => "123456")
#       click_button 'submit'
#       visit "/books"
#       expect(page.body).to include(review1.content)
#       expect(page.body).to include(review2.content)
#     end
#   end
# end
