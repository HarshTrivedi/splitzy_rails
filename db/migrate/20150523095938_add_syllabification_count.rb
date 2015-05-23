class AddSyllabificationCount < ActiveRecord::Migration
  def self.up
  	add_column :words, :syllabifications_count, :integer, :default => 0

	Word.reset_column_information
	Word.all.each do |word|
	    Word.update_counters word.id, :syllabifications_count => word.syllabifications.length
	end

  end

  def self.down
  	remove_column :words , :syllabifications_count
  end

end
