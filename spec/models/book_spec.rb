require 'spec_helper'

describe "Book" do
  before do
    @author = Author.create(:name => "Paulo Coehlo")

    @book =  Book.create(:name => "The Alchemist", :author => @author)

    review = Review.create(:content => "It was good")

    @book.review_ids = review.id

  end

  it "can initialize a book" do
    expect(Book.new).to be_an_instance_of(Book)
  end

  it "can have a name" do
    expect(@book.name).to eq("The Alchemist")
  end

  it "can have many reviews" do
    expect(@book.reviews.count).to eq(1)
  end

  it "has an author" do
    expect(@book.author).to eq(@author)
  end

  it "can slugify its name" do

    expect(@book.slug).to eq("the-alchemist")
  end

  describe "Class methods" do
    it "given the slug can find a book" do
      slug = "the-alchemist"

      expect((Book.find_by_slug(slug)).name).to eq("The Alchemist")
    end
  end
end
