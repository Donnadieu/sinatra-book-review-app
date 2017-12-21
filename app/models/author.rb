class Author < ActiveRecord::Base
  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods

  has_many :books
  has_many :reviews, through: :books

  def self.is_name_in_database?(name)
    self.all.collect do |instance|
      instance.name.downcase
    end.include?(name.downcase)
  end

  def self.find_by_downcase_name(name)
    author = []
    self.all.each do |instance|
      if instance.name.downcase == name.downcase
        author << instance
      end
    end
    author
  end

  def is_book_by_author?(name)
    self.books.collect do |book|
      book.name.downcase
    end.include?(name.downcase)
  end
end
