class Book < ActiveRecord::Base
  extend Slugifiable::ClassMethods
  extend DowncaseNames::ClassMethods
  include Slugifiable::InstanceMethods

  belongs_to :author

  has_many :reviews
  has_many :users, through: :reviews
end
