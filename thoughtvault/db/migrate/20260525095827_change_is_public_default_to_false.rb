# CSI2441 Assignment 2 - ThoughtVault
# Student: Vinith Magheswaran (ID: 10676287)
# Migration: Change is_public default from true to false
# Quotes should be private by default; user explicitly opts in to make them public

class ChangeIsPublicDefaultToFalse < ActiveRecord::Migration[8.1]
  def change
    # Change column default so new quotes are private unless the user ticks "Make public"
    change_column_default :quotes, :is_public, from: true, to: false
  end
end
