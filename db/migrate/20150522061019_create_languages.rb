class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :value

      t.timestamps
    end
  end
end
