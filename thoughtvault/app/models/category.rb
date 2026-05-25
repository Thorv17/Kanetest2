# CSI2441 Assignment 2 - MyQuote
# Student: Vinith Magheswaran (ID: 10676287)
# Category model - represents philosophical categories (e.g., Ethics, Metaphysics)

class Category < ApplicationRecord
  # Categories are associated with quotes through the QuoteCategory join table
  has_many :quote_categories, dependent: :destroy
  has_many :quotes, through: :quote_categories

  # Each category name must be unique and present (case-insensitive)
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
