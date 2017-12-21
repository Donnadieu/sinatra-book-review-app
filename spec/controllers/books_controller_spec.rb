require 'spec_helper'

describe BooksController do

  before do
    @user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
    @book =  Book.create(:name => "The Alchemist", :author => @author)
  end
  describe 'index action' do
    context 'logged in' do
      it 'lets a user view the books page if logged in' do

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'submit'
        get "/books"
        expect(page.status_code).to eq(200)
        expect(last_response.location).to include("/books")
      end
    end
    context 'logged out' do
      it 'does not let a user view the books if logged out' do
        get "/books"
        expect(last_response.location).to include("/login")
      end
    end
  end
  describe 'show action' do
    context 'logged in' do
      it 'displays a single book if logged in' do

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'submit'

        visit "/books/#{@book.slug}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("#{@book.name}")
      end
    end
  end
  context 'logged out' do
    it 'does not let a user view the books if logged out' do
      get "/books/#{@book.slug}"
      expect(last_response.location).to include("/login")
    end
  end
end
