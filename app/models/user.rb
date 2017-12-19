class User < ActiveRecord::Base
  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods
  
  has_secure_password

  has_many :reviews
  has_many :books, through: :reviews
end
