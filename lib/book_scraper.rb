class BookScraper

  def self.one_page_results?(page)
    page.css("tr").count < 20 && page.css("tr").count > 0
  end

  def self.search(search_term = "Paulo Coelho")
    # Instantiate a new web scraper with Mechanize
    scraper = Mechanize.new
    # hard-coding the address
    url = "https://www.goodreads.com/"
    page = scraper.get(url)
    # Getting the search form on the page
    search_form = page.forms.last
    # Use Mechanize to enter search terms into the form fields
    search_form.fields.map {|f| f.value = search_term if f.name == "query"}
    # Get results
    results_page = search_form.submit
    next_page = results_page.at("a.next_page")
    no_results = results_page.css("h3.searchSubNavContainer").text == "No results."
    # Parse results
    if no_results
      puts "Sorry No Books found with that query"
    elsif !next_page && one_page_results?(results_page)
      results_page.css("tr").each do |book|
        book_name = book.css("td a.bookTitle span").text
        book_author = book.css("td a.authorName span").first.text
        book_url = "https://www.goodreads.com/#{book.css("td a.bookTitle").attr('href').text}"
        # Save results
        if !book_name.empty? || !book_name == nil
          book = Book.create(name: book_name) unless Book.downcase_names.include?(book_name.downcase)
        end
        if !book_author.empty? || !book_author == nil
          Author.create({name: book_author}) unless Author.downcase_names.include?(book_author.downcase)
        elsif book_author.empty? || book_author == nil
          Author.create({name: book_author}) unless Author.downcase_names.include?(book_author.downcase)
        end
      end
    elsif !no_results && next_page
      while next_page != nil && next_page.text.include?("next")
        results_page.css("tr").each do |book|
          book_name = book.css("td a.bookTitle span").text
          book_author = book.css("td a.authorName span").first.text
          book_url = "https://www.goodreads.com/#{book.css("td a.bookTitle").attr('href').text}"
          # Save results
          if !book_name.empty? || !book_name == nil
            Book.create(name: book_name) unless Book.downcase_names.include?(book_name.downcase)
          end
          if !book_author.empty? || !book_author == nil
            Author.create({name: book_author}) unless Author.downcase_names.include?(book_author.downcase)
          elsif book_author.empty? || book_author == nil
            Author.create({name: book_author}) unless Author.downcase_names.include?(book_author.downcase)
          end
        end
        scraper.click(next_page)
        results_page = scraper.click(next_page)
        next_page = results_page.at("a.next_page")
      end
    end
  end
end
