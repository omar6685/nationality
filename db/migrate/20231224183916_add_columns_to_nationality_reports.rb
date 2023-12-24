class AddColumnsToNationalityReports < ActiveRecord::Migration[7.0]
  def change
    add_column :nationality_reports, :saudis, :float
    add_column :nationality_reports, :total_employees, :float
    add_column :nationality_reports, :max_addition, :string
    add_column :nationality_reports, :name, :string
  end
end
