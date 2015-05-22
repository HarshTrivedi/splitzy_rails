class CreateSyllabifications < ActiveRecord::Migration
  def change
    create_table :syllabifications do |t|
      t.string :value
      t.text :note
      t.references :word, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
