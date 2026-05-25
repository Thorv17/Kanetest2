# CSI2441 Assignment 2 - ThoughtVault
# Student: Vinith Magheswaran (ID: 10676287)
# Migration: Create authors table for philosophers and thinkers

class CreateAuthors < ActiveRecord::Migration[8.1]
  def change
    create_table :authors do |t|
      # First name of author/philosopher (required)
      t.string :fname, null: false

      # Last name of author (optional, may be blank for single-name thinkers)
      t.string :lname

      # Birth year as string to support "384 BCE" format (optional)
      t.string :birth_yr

      # Death year as string to support "322 BCE" format (optional)
      t.string :death_yr

      # Biographical information (optional, can be empty)
      t.text :bio

      t.timestamps
    end
  end
end
