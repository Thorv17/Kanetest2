# CSI2441 Assignment 2 - MyQuote
# Student: Vinith Magheswaran (ID: 10676287)
# Migration: Rename QuoteTag model and table to QuoteCategory per assignment requirement

class RenameQuoteTagToQuoteCategory < ActiveRecord::Migration[8.1]
  def change
    # Rename the quote_tags table to quote_categories (as required by assignment specification)
    rename_table :quote_tags, :quote_categories
  end
end
