require 'spec_helper'

describe 'User' do
  before do
    @user = User.create(:name => "user test", :email => "test123@email.com", :password => "test")
  end
  it 'can slug the username' do
    expect(@user.slug).to eq("user-test")
  end

  it 'can find a user based on the slug' do
    slug = @user.slug
    expect(User.find_by_slug(slug).name).to eq("user test")
  end

  it 'has a secure password' do

    expect(@user.authenticate("dog")).to eq(false)
    expect(@user.authenticate("test")).to eq(@user)

  end
end
