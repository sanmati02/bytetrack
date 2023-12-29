class ChangeFieldTypeInJobs < ActiveRecord::Migration
  def change
    change_column :jobs, :priority, :string
  end
end
