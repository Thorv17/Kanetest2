class QuoteTag < ApplicationRecord
  belongs_to :quote
  belongs_to :category, optional: true

  validate :category_selection_required

  private

  def category_selection_required
    errors.add(:base, "Category fields must not be empty (remove unused rows)") if category_id.blank?
  end
end
