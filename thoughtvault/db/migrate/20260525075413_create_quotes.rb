# CSI2441 Assignment 2 - ThoughtVault
# Student: Vinith Magheswaran (ID: 10676287)
# Migration: Create quotes table for user quote collection

class CreateQuotes < ActiveRecord::Migration[8.1]
  def change
    create_table :quotes do |t|
      # The quote text itself (required, must not be empty)
      t.text :content, null: false

      # Publication year as string format (optional, e.g., "1785", "384 BCE")
      t.string :pub_year

      # User's personal note or comment about the quote (optional)
      t.text :note

      # Privacy flag: false = private (default), true = visible to all users
      t.boolean :is_public, default: false, null: false

      # Foreign key to users table: the user who created/owns this quote (required)
      t.references :user, null: false, foreign_key: true

      # Foreign key to authors table: the philosopher/thinker who wrote the quote (required)
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
