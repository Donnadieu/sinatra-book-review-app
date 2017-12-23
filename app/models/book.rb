class Book < ActiveRecord::Base
  include SearchCop

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods

  search_scope :search do
    attributes :name
    attributes author: "author.name"
  end

  belongs_to :author

  has_many :reviews
  has_many :users, through: :reviews

  def self.find_by_downcase_name(name)
    book = []
    self.all.each do |instance|
      if instance.name.downcase == name.downcase
        book << instance
      end
    end
    book
  end
end
