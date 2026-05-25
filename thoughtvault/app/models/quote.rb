# CSI2441 Assignment 2 - ThoughtVault
# Student: Vinith Magheswaran (ID: 10676287)
# Quote model - represents a philosophical quote with content, metadata, and categorization

class Quote < ApplicationRecord
  # A quote belongs to a user (creator) and optionally to an author (philosopher/thinker)
  belongs_to :user
  belongs_to :author, optional: true

  # Quotes are tagged with categories via the QuoteTag join table
  has_many :quote_tags, dependent: :destroy
  has_many :categories, through: :quote_tags

  # Accepts nested attributes for inline category assignment during quote creation/editing
  accepts_nested_attributes_for :quote_tags, allow_destroy: true

  # Validation: quote content must not be empty
  validates :content, presence: { message: "cannot be blank" }

  # Custom validation: every quote must belong to at least one category
  validate :requires_at_least_one_category

  private

  # Ensures user selects at least one category for the quote
  def requires_at_least_one_category
    active_tags = quote_tags.reject(&:marked_for_destruction?)
    errors.add(:base, "At least one category must be selected.") if active_tags.empty?
  end
end
