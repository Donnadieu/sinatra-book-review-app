class BookScraper

  def self.one_page_results?(page)
    page.css("tr").count < 20 && page.css("tr").count > 0
  end

  def self.scrape_attributes(page)
    count = 0
    page.css("tr").each do |book|
      while count <= 5
        book_name = book.css("td a.bookTitle span").text
        book_author = book.css("td a.authorName span").first.text
        book_url = "https://www.goodreads.com/#{book.css("td a.bookTitle").attr('href').text}"
        # Save results
        if Author.is_name_in_database?(book_author)
          @author = Author.find_by_downcase_name(book_author).first
        else
          @author = Author.create(name: book_author)
          book = Book.create(name: book_name, author: @author)
          description_scraper = Mechanize.new
          book_page = description_scraper.get(book_url)
          description_array = book_page.css("#description").text.split
          description_array.pop
          book.description = description_array.join(" ")
          book.cover_url = book_page.css("#coverImage").attr("src").text
        end
        if !@author.is_book_by_author?(book_name)
          book = Book.create(name: book_name, author: @author)
          description_scraper = Mechanize.new
          book_page = description_scraper.get(book_url)
          description_array = book_page.css("#description").text.split
          description_array.pop
          book.description = description_array.join(" ")
          book.cover_url = book_page.css("#coverImage").attr("src").text
        end
        count +=1
      end
    end
  end

  def self.search(search_term = nil)
    count = 0
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
      "No results for this query"
    else
      scrape_attributes(results_page)
    end
  end
end
# elsif !next_page && one_page_results?(results_page)
#   scrape_attributes(results_page)
# elsif next_page
  # while next_page != nil && next_page.text.include?("next")
  #   scrape_attributes(results_page)
  #   scraper.click(next_page)
  #   results_page = scraper.click(next_page)
  #   next_page = results_page.at("a.next_page")
  # end
