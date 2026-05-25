class CreateAuthors < ActiveRecord::Migration[8.1]
  def change
    create_table :authors do |t|
      t.string :fname, null: false
      t.string :lname
      t.string :birth_yr
      t.string :death_yr
      t.text :bio

      t.timestamps
    end
  end
end
