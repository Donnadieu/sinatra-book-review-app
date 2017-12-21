class Author < ActiveRecord::Base
  extend Slugifiable::ClassMethods
  extend DowncaseNames::ClassMethods
  include Slugifiable::InstanceMethods

  has_many :books
  has_many :reviews, through: :books
end
