class Category < ApplicationRecord
  has_many :quote_tags, dependent: :destroy
  has_many :quotes, through: :quote_tags

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
