# CSI2441 Assignment 2 - ThoughtVault
# Student: Vinith Magheswaran (ID: 10676287)
# Author model - represents philosophers, thinkers, and sources of quotes

class Author < ApplicationRecord
  # An author can have many quotes; deleting an author nullifies (not cascades) associated quotes
  has_many :quotes, dependent: :nullify

  # Author must have at least a first name
  validates :fname, presence: { message: "must be provided" }
end
