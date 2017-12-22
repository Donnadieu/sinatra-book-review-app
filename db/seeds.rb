user = User.create(:name => "Omar", :email => "test@email.com", :password => "123456")
author = Author.find(1)
book =  Book.find(1)
review = Review.create(:content => "New review", :user_id => user.id, :book_id => book.id)
