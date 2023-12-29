class RemoveDescriptionAndAddNewFields < ActiveRecord::Migration
  def change
    # Remove the "description" column
    remove_column :jobs, :description

    # Add new columns
    add_column :jobs, :skills, :string
    add_column :jobs, :location, :string
    add_column :jobs, :confidence_rating_oa, :integer
    add_column :jobs, :confidence_rating_interview, :integer
    add_column :jobs, :interview_notes, :string
    add_column :jobs, :oa_notes, :string
  end
end
