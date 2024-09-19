class User < ApplicationRecord
  has_secure_password
  has_many :tasks
  has_many :columns

  validates :email, presence: true, uniqueness: true
end
