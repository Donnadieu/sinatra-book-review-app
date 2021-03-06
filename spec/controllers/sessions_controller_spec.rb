require 'spec_helper'

describe SessionsController do

  describe "Signup Page" do

    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'signup directs user to user show page' do
      params = {
        :name => "user test",
        :email => "test@email.com",
        :password => "1234567"
      }
      post '/signup', params
      expect(last_response.location).to include("/users/user-test")
    end

    it 'does not let a user sign up without a username' do

      visit '/signup'
      expect(page.find_by_id("name")[:required].eql?('required')).to be_truthy
    end

    it 'does not let a user sign up without an email' do

      visit '/signup'
      expect(page.find_by_id("email")[:required].eql?('required')).to be_truthy
    end

    it 'does not let a user sign up without a password' do

      visit '/signup'
      expect(page.find_by_id("password")[:required].eql?('required')).to be_truthy
    end

    it 'does not let a logged in user view the signup page' do
      user = User.create(:name => "User Test", :email => "test@email.com", :password => "1234567")
      visit '/login'

      fill_in(:email, :with => "test@email.com")
      fill_in(:password, :with => "1234567")
      click_button 'Login'

      visit '/signup'
      expect(page.current_path).to include('/users/user-test')
    end
  end

  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the user show page after login' do
      user = User.create(:name => "User Test", :email => "test@email.com", :password => "1234567")
      params = {
        :email => "test@email.com",
        :password => "1234567"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome")
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:name => "User Test", :email => "test@email.com", :password => "1234567")

      params = {
        :email => "test@email.com",
        :password => "1234567"
      }
      post '/login', params
      session = {}
      session[:user_id] = user.id
      get '/login'
      expect(last_response.location).to include("/users/#{user.slug}")
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in" do
      user = User.create(:name => "User Test", :email => "test@email.com", :password => "1234567")

      params = {
        :email => "test@email.com",
        :password => "1234567"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/")
    end

    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")
    end

    it 'does not load books if user not logged in' do
      get '/books'
      expect(last_response.location).to include("/login")
    end

    it 'does load books if user is logged in' do
      user = User.create(:name => "User Test", :email => "test@email.com", :password => "1234567")


      visit '/login'

      fill_in(:email, :with => "test@email.com")
      fill_in(:password, :with => "1234567")
      click_button 'Login'

      visit  '/books'

      expect(page.current_path).to eq('/books')
    end
  end

  context 'logged out' do
    it 'does not let a user view the books index if not logged in' do
      get '/books'
      expect(last_response.location).to include("/login")
    end
  end
end
