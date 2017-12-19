require 'spec_helper'

describe "Review" do
  before do
    @user = @user = User.create(:name => "user test", :email => "test123@email.com", :password => "test")

    @author = Author.create(:name => "Paulo Coehlo")

    @book =  Book.create(:name => "The Alchemist", :author => @author)

    @review = Review.create(:content => "It was good")

    @book.reviews << @review

    @user.reviews << @review

  end

  it "can initialize a review" do
    expect(Review.new).to be_an_instance_of(Review)
  end

  it "has content" do
    expect(@review.content).to eq("It was good")
  end

  it "belongs to and User" do
    expect(@user.review_ids).to include(@review.id)
  end

  it "belongs to and Book" do
    expect(@book.review_ids).to include(@review.id)
  end

  it "belongs to and Author through a Book" do
    expect(@book.author.review_ids).to include(@review.id)
  end
end
