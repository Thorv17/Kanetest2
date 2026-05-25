# CSI2441 Assignment 2 - ThoughtVault
# Student: Vinith Magheswaran (ID: 10676287)
# Migration: Create users table for authentication and user management

class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      # User name fields (required)
      t.string :fname, null: false
      t.string :lname, null: false

      # Email for authentication (must be unique, required)
      t.string :email, null: false

      # bcrypt-hashed password (required)
      t.string :password_digest, null: false

      # Role flag: true for admin, false for standard user (default: false)
      t.boolean :is_admin, default: false, null: false

      # Account status: Active (can login), Suspended (locked), or Banned (permanently denied)
      t.string :status, default: "Active", null: false

      t.timestamps
    end

    # Enforce unique email addresses (case-insensitive in application)
    add_index :users, :email, unique: true
  end
end
