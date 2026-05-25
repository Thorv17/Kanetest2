class User < ApplicationRecord
  has_secure_password
  has_many :quotes, dependent: :destroy

  validates :fname, :lname, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false, message: "address is already registered" }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :status, inclusion: { in: %w[Active Suspended Banned] }
end
