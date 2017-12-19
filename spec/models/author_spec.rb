require 'spec_helper'

describe "Author" do
  before do
    @author = Author.create(:name => "Paulo Coehlo")

    the_alchemist =  Book.create(:name => "The Alchemist", :author => @author)

    review = Review.create(:content => "It was good")

    the_alchemist.reviews << review

  end
  it "can be initialized" do
    expect(@author).to be_an_instance_of(Author)
  end

  it "can have a name" do
    expect(@author.name).to eq("Paulo Coehlo")
  end

  it "has many books" do
    expect(@author.books.count).to eq(1)
  end

  it "can have many reviews" do
    expect(@author.reviews.count).to eq(1)
  end

  it "can slugify its name" do
    expect(@author.slug).to eq("paulo-coehlo")
  end

  describe "Class methods" do
    it "given the slug can find an Artist" do
      slug = "paulo-coehlo"
      expect((Author.find_by_slug(slug)).name).to eq("Paulo Coehlo")
    end
  end

end
