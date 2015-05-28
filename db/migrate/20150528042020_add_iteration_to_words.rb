class AddIterationToWords < ActiveRecord::Migration
  def change
    add_column :words, :iteration, :integer , :default => -1
  end
end
