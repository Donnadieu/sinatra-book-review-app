require 'spec_helper'

describe AuthorsController do

  before do
    @user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
    @author = Author.create(:name => "Paulo Coehlo")
    @book =  Book.create(:name => "The Alchemist", :author => @author)
  end
  describe 'index action' do
    context 'logged in' do
      it 'lets a user view the authors page if logged in' do

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'Login'
        visit "/authors"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("#{@author.name}")
      end
    end
    context 'logged out' do
      it 'does not let a user view the authors if logged out' do
        get "/authors"
        expect(last_response.location).to include("/login")
      end
    end
  end
  describe 'show action' do
    context 'logged in' do
      it 'displays a single auhtor if logged in' do

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'Login'

        visit "/authors/#{@author.slug}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("#{@author.name}")
      end
    end
  end
  context 'logged out' do
    it 'does not let a user view the authors if logged out' do
      get "/authors/#{@author.slug}"
      expect(last_response.location).to include("/login")
    end
  end
end
