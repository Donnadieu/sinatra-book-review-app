if Book.all.empty?
  @book = Book.create(name: book_name) unless book_name.empty? || book_name == nil
elsif !book_name.empty? || !book_name == nil
  Book.all.each do |book|
    if book.name.downcase == book_name.downcase
      if book.author.name.downcase == book_author.downcase
        @book = Book.find_by(name: book_name, author: book.author.name)
      end
    elsif book.name.downcase == book_name.downcase
      @book = Book.find_by(name: book_name)
    elsif book.author.name.downcase == book_author.downcase

      @book = Book.create(name: book_name)
    end
  end
end
if Book.all.empty?
  @book = Book.create(name: book_name) unless book_name.empty? || book_name == nil
elsif !book_name.empty? || !book_name == nil
  Book.all.each do |book|
    if book.name.downcase == book_name.downcase && book.author.name.downcase == book_author.downcase
      Book.find_by(name: book.name, author: book.author.name)
    elsif book.author.name.downcase == book_author.downcase
      book.author <<
    end
  end
end
end
