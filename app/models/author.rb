class Author < ActiveRecord::Base
  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods

  has_many :books
  has_many :reviews, through: :books
end
