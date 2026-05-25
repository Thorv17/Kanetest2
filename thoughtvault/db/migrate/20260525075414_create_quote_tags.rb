class CreateQuoteTags < ActiveRecord::Migration[8.1]
  def change
    create_table :quote_tags do |t|
      t.references :quote, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
