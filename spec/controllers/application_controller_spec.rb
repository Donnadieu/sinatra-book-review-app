require 'spec_helper'

describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome")
    end
  end

  describe "Search page" do
    context 'logged in' do
      it 'loads the book search page if logged in' do
        user = User.create(:name => "User Test", :email => "test@email.com", :password => "1234567")

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "1234567")
        click_button 'Login'

        visit '/books'
        expect(page.status_code).to eq(200)
        expect(page.current_path).to include("/books")
      end
    end
  end

  context 'logged out' do
    it 'does not loads the book search page if logged out' do
      user = User.create(:name => "User Test", :email => "test@email.com", :password => "1234567")

      get '/books'

      expect(last_response.location).to include("/login")
    end
  end
end
