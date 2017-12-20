require 'spec_helper'

describe AuthorsController do
  before do
    @user1 = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
    @user2 = User.create(:name => "user test2", :email => "test@aol.com", :password => "789456")
    @author = Author.create(:name => "Paulo Coehlo")
    @book =  Book.create(:name => "The Alchemist", :author => @author)
    @review1 = Review.create(:content => "It was good", :user_id => @user1.id)
    @review2 = Review.create(:content => "It was bad", :user_id => @user2.id)
    @book.reviews << @review1
    @book.reviews << @review2

  end

  describe 'index action' do

    context 'logged in' do
      it 'lets a user view the authors index if logged in' do

        visit '/login'

        fill_in(:name, :with => "User Test")
        fill_in(:password, :with => "123456")
        click_button 'submit'
        visit "/authors"
        expect(page.body).to include(review1.content)
        expect(page.body).to include(review2.content)
      end
    end
  end

  describe 'author show page' do
    it 'displays a single author' do

      get "/author/#{author.slug}"

      expect(last_response.body).to include("#{@author.name}")
    end
  end
end
