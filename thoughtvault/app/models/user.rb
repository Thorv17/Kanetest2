# CSI2441 Assignment 2 - MyQuote
# Student: Vinith Magheswaran (ID: 10676287)
# User model - represents application users with role-based access and authentication

class User < ApplicationRecord
  # bcrypt password hashing and authentication
  has_secure_password

  # A user can create and own many quotes; deleting a user cascades to delete their quotes
  has_many :quotes, dependent: :destroy

  # First and last name are required for all users
  validates :fname, :lname, presence: true

  # Email must be unique and present (case-insensitive comparison)
  validates :email, presence: true, uniqueness: { case_sensitive: false, message: "address is already registered" }

  # Password must be at least 6 characters when creating a new user
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  # Account status must be one of: Active, Suspended, or Banned (blocks login when not Active)
  validates :status, inclusion: { in: %w[Active Suspended Banned] }
end
