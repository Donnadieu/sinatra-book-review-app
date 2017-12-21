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
        :email => "tets@email.com",
        :password => "123456"
      }
      post '/signup', params
      expect(last_response.location).to include("/users/user-test")
    end

    it 'does not let a user sign up without a username' do
      params = {
        :name => "",
        :email => "tets@email.com",
        :password => "123456"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without an email' do
      params = {
        :name => "user test",
        :email => "",
        :password => "123456"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without a password' do
      params = {
        :name => "user test",
        :email => "tets@email.com",
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a logged in user view the signup page' do
      user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
      params = {
        :name => "User test",
        :email => "tets@email.com",
        :password => "123456"
      }
      post '/signup', params
      session = {}
      session[:user_id] = user.id
      get '/signup'
      expect(last_response.location).to include('/users/user-test')
    end
  end

  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the books index after login' do
      user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")
      params = {
        :email => "tets@email.com",
        :password => "123456"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome,")
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")

      params = {
        :email => "tets@email.com",
        :password => "123456"
      }
      post '/login', params
      session = {}
      session[:user_id] = user.id
      get '/login'
      expect(last_response.location).to include("/books")
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in" do
      user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")

      params = {
        :email => "tets@email.com",
        :password => "123456"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/login")
    end

    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")
    end

    it 'does not load /tweets if user not logged in' do
      get '/books'
      expect(last_response.location).to include("/login")
    end

    it 'does load /tweets if user is logged in' do
      user = User.create(:name => "User Test", :email => "test@email.com", :password => "123456")


      visit '/login'

      fill_in(:email, :with => "test@email.com")
      fill_in(:password, :with => "123456")
      click_button 'submit'
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
