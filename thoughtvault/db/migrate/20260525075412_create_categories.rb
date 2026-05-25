# CSI2441 Assignment 2 - MyQuote
# Student: Vinith Magheswaran (ID: 10676287)
# Migration: Create categories table for philosophical categories

class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      # Category name (e.g., "Ethics", "Metaphysics") - must be unique
      t.string :name, null: false

      t.timestamps
    end

    # Enforce unique category names
    add_index :categories, :name, unique: true
  end
end
