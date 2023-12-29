class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :company_title
      t.string :job_title
      t.text :description
      t.string :application_status
      t.date :date_applied
      t.string :online_assessment_status
      t.date :online_assessment_deadline
      t.string :interview_status
      t.date :interview_date
      t.string :final_decision
      t.integer :priority

      t.timestamps
    end
  end
end
