class Author < ApplicationRecord
  has_many :quotes, dependent: :nullify

  validates :fname, presence: { message: "must be provided" }
end
