require 'spec_helper'

describe 'User' do
  before do
    @user = User.create(:name => "User Test", :email => "test@email.com", :password => "1234567")
  end
  # binding.pry
  it 'can slug the username' do
    expect(@user.slug).to eq("user-test")
  end

  it 'can find a user based on the slug' do
    slug = @user.slug
    expect(User.find_by_slug(slug).name).to eq("User Test")
  end

  it 'has a secure password' do

    expect(@user.authenticate("dog")).to eq(false)
    expect(@user.authenticate("1234567")).to eq(@user)

  end
end
