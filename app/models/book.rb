class Book < ActiveRecord::Base
  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods

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
