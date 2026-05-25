# CSI2441 Assignment 2 - MyQuote
# Student: Vinith Magheswaran (ID: 10676287)
# Quote model - represents a philosophical quote with content, metadata, and categorization

class Quote < ApplicationRecord
  # A quote belongs to a user (creator) and to an author (philosopher/thinker is required)
  belongs_to :user
  # optional: true disables Rails auto-validation; we handle it with validates :author below
  belongs_to :author, optional: true

  # Quotes are tagged with categories via the QuoteCategory join table
  has_many :quote_categories, dependent: :destroy
  has_many :categories, through: :quote_categories

  # Accepts nested attributes for inline category assignment during quote creation/editing
  accepts_nested_attributes_for :quote_categories, allow_destroy: true

  # Validation: quote content must not be empty
  validates :content, presence: { message: "cannot be blank" }

  # Validation: a thinker/author must be selected (matches DB null: false constraint)
  validates :author, presence: { message: "must be selected" }

  # Custom validation: every quote must belong to at least one category
  validate :requires_at_least_one_category

  private

  # Ensures user selects at least one category for the quote
  def requires_at_least_one_category
    active_tags = quote_categories.reject(&:marked_for_destruction?)
    errors.add(:base, "At least one category must be selected.") if active_tags.empty?
  end
end
