# CSI2441 Assignment 2 - MyQuote
# Student: Vinith Magheswaran (ID: 10676287)
# Migration: Create quote_tags join table for many-to-many relationship between quotes and categories

class CreateQuoteTags < ActiveRecord::Migration[8.1]
  def change
    create_table :quote_tags do |t|
      # Foreign key to quotes table: the quote being tagged (required)
      t.references :quote, null: false, foreign_key: true

      # Foreign key to categories table: the category assigned to this quote (required)
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
