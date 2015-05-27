class AddReportCategoryToWords < ActiveRecord::Migration
  def change
    add_column :words, :report_category, :string
  end
end
