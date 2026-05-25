# CSI2441 Assignment 2 - MyQuote
# Student: Vinith Magheswaran (ID: 10676287)
# QuoteTag model - join table linking quotes to categories for many-to-many relationship

class QuoteTag < ApplicationRecord
  # Each quote_tag belongs to exactly one quote and one category
  belongs_to :quote
  belongs_to :category, optional: true

  # Custom validation: if a category slot is not removed, it must have a category selected
  validate :category_selection_required

  private

  # Prevents empty category fields; users must either select a category or remove the row
  def category_selection_required
    errors.add(:base, "Category fields must not be empty (remove unused rows)") if category_id.blank?
  end
end
