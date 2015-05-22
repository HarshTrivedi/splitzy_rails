class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :value
      t.text :suggestion
      t.references :language, index: true

      t.timestamps
    end
  end
end
