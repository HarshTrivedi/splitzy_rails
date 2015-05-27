class AddReportNoteToWords < ActiveRecord::Migration
  def change
    add_column :words, :report_note, :text
  end
end
