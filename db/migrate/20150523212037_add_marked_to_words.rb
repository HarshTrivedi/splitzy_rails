class AddMarkedToWords < ActiveRecord::Migration
  def change
    add_column :words, :marked, :boolean , :default => false
  end
end
