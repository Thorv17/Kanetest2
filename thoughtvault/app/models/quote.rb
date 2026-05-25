class Quote < ApplicationRecord
  belongs_to :user
  belongs_to :author, optional: true
  has_many :quote_tags, dependent: :destroy
  has_many :categories, through: :quote_tags
  accepts_nested_attributes_for :quote_tags, allow_destroy: true

  validates :content, presence: { message: "cannot be blank" }
  validate :requires_at_least_one_category

  private

  def requires_at_least_one_category
    active_tags = quote_tags.reject(&:marked_for_destruction?)
    errors.add(:base, "At least one category must be selected.") if active_tags.empty?
  end
end
