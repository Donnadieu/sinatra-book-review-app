class BookScraper

  def self.one_page_results?(page)
    page.css("tr").count < 20 && page.css("tr").count > 0
  end

  def self.search(search_term = "the analyst by John Katzenbach")
    count = 256
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
      count
    elsif !next_page && one_page_results?(results_page)
      results_page.css("tr").each do |book|
        book_name = book.css("td a.bookTitle span").text
        book_author = book.css("td a.authorName span").first.text
        book_url = "https://www.goodreads.com/#{book.css("td a.bookTitle").attr('href').text}"
        # Save results
        if Author.is_name_in_database?(book_author)
          @author = Author.find_by_downcase_name(book_author).first
        else
          @author = Author.create(name: book_author)
          book = Book.create(name: book_name, author: @author)
        end
        if !@author.is_book_by_author?(book_name)
          book = Book.create(name: book_name, author: @author)
        end
      end
    elsif !no_results && next_page
      while next_page != nil && next_page.text.include?("next")
        results_page.css("tr").each do |book|
          book_name = book.css("td a.bookTitle span").text
          book_author = book.css("td a.authorName span").first.text
          book_url = "https://www.goodreads.com/#{book.css("td a.bookTitle").attr('href').text}"
          # Save results
          if Author.is_name_in_database?(book_author)
            @author = Author.find_by_downcase_name(book_author).first
          else
            @author = Author.create(name: book_author)
            book = Book.create(name: book_name, author: @author)
          end
          if !@author.is_book_by_author?(book_name)
            book = Book.create(name: book_name, author: @author)
          end
        end
        scraper.click(next_page)
        results_page = scraper.click(next_page)
        next_page = results_page.at("a.next_page")
      end
    end
  end
end
