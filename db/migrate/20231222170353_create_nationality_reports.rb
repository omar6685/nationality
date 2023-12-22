class CreateNationalityReports < ActiveRecord::Migration[7.0]
  def change
    create_table :nationality_reports do |t|
      t.string :result

      t.timestamps
    end
  end
end
