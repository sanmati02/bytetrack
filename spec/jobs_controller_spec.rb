require 'rails_helper'

RSpec.describe JobsController, type: :controller do
 #  describe 'GET #index' do
 #   let(:user) { create(:user) }
 #   let(:job1) { create(:job, user: user, company_title: 'Example1', priority: 'High', final_decision: 'Accepted') }
 #   let(:job2) { create(:job, user: user, company_title: 'Example2', priority: 'Medium', final_decision: 'Pending') }
 #
 #   before do
 #     sign_in user
 #     # Create jobs and any other necessary setup
 #     job1
 #     job2
 #
 # end


  describe 'show' do
    before(:each) do
      User.destroy_all
      @user = User.create(email:"user@example.com", password: "password")
      @user.save!
      @user.jobs.create(company_title: 'Lumedica', job_title: 'SWE', final_decision: 'Waiting')
      @jobs = @user.jobs

    end
    it 'show all job' do
      @job_to_show = @jobs.first
      expect(@job_to_show).not_to be_nil, "No jobs found for the user."

      puts "Job to show: #{@job_to_show.inspect}"

      get :show, params: { user_id: @user.id, id: @job_to_show.id }

      expect(assigns(:job)).to eq(@job_to_show)
    end
  end

  describe 'create' do
    before(:each) do
      User.destroy_all
      @user = User.create(email:"user@example.com", password: "password")
      @user.save!
      @user.jobs.create(company_title: 'Lumedica', job_title: 'SWE', final_decision: 'Waiting')
      @jobs = Job.all
    end

    # Job should not be created because date applied is empty
    it 'should not create a job' do
      sign_in @user
      job = { company_title: 'Lumedica', job_title: 'SWE', final_decision: 'Waiting' }
      post :create, params: { job: job, user_id: @user.id }
      expect(@jobs.count).to eq(1)
    end

    # Job should be created because all required inputs are filled
    it 'should create a job' do
      sign_in @user
      job = {company_title: 'Stryker', job_title: 'SWE', date_applied: '2023-10-11'}
      post :create, params: { job: job, user_id: @user.id }
      expect(@jobs.count).to eq(2)
    end

    # Job should not be created because date applied is in the future
    it 'should not create a job' do
      sign_in @user
      job = {company_title: 'Figma', job_title: 'SWE', date_applied: '2024-10-11'}
      post :create, params: {job: job, user_id: @user.id}
      expect(@jobs.count).to eq(1)
    end
  end

  describe "update" do
    let(:job_attributes) do
      { company_title: 'Lumedica', job_title: 'SWE', date_applied: 1.day.ago, final_decision: 'Waiting', priority: 'Low' }
    end

    before(:each) do
      User.destroy_all
      @user = User.create(email: "user@example.com", password: "password")
      @user.save!
      @new_job = @user.jobs.create!(job_attributes)
      @jobs = @user.jobs

    end

    let(:attr1) do
      {:company_title => 'New Company', job_title: 'SWE', date_applied: 1.day.ago, final_decision: 'Waiting', priority: 'Low'}
    end

    it 'should update a job' do
      sign_in @user
      put :update, params: {id: @new_job.id, :job => attr1, user_id: @user.id}
      @new_job.reload
      expect(@new_job.company_title).to eq('New Company')
    end

    let(:attr2) do
      {:company_title => '', job_title: 'SWE', date_applied: 1.day.ago, final_decision: 'Waiting', priority: 'Low'}
    end

    it 'should not update a job' do
      sign_in @user
      put :update, params: {id: @new_job.id, :job => attr2, user_id: @user.id}
      @new_job.reload
      expect(@new_job.company_title).to eq('Lumedica')
    end

    let(:attr3) do
      {:company_title => '', job_title: 'SWE', date_applied: Date.today + 1, final_decision: 'Waiting', priority: 'Low'}
    end

    it 'should not update a job' do
      sign_in @user
      put :update, params: {id: @new_job.id, :job => attr3, user_id: @user.id}
      @new_job.reload
      expect(@new_job.date_applied).to eq(1.day.ago.to_date)
    end

  end

  describe 'edit' do
   before(:each) do
      User.destroy_all
      @user = User.create(email:"user@example.com", password: "password")
      @user.save!
      @user.jobs.create(company_title: 'Lumedica', job_title: 'SWE', final_decision: 'Waiting')
      @jobs = Job.all
   end


   it 'assigns the requested job to @job' do
     # Create a job for testing
     # Simulate a GET request to the 'edit' action with the job's ID
     sign_in @user
     job_to_edit = @jobs.first

     get :edit, params: { user_id: @user.id, id: job_to_edit.id }

     # Ensure that the job instance variable is assigned
     expect(assigns(:job)).to eq(job_to_edit)
   end
  end

  describe 'index' do
    before(:each) do
       User.destroy_all
       @user = User.create(email:"user@example.com", password: "password")
       @user.save!
    end

    it 'assigns all jobs to @jobs' do
      sign_in @user
      job1 = @user.jobs.create!(company_title: 'Lumedica', job_title: 'SWE', final_decision: 'Waiting')
      job2 = @user.jobs.create!(company_title: 'Lumedica', job_title: 'SWE', final_decision: 'Waiting')

      get :index

      expect(assigns(:jobs)).to match_array([job1, job2])
    end

    it 'filters jobs by priority' do
      sign_in @user
      low_priority_job = @user.jobs.create!(company_title: 'Low Priority Company', priority: 'Low')
      high_priority_job = @user.jobs.create!(company_title: 'High Priority Company', priority: 'High')

      get :index, params: { user_id: @user.id, priority: 'Low'}

      expect(assigns(:jobs)).to contain_exactly(low_priority_job)
    end

    it 'filters jobs by final decision' do
      sign_in @user
      waiting_job = @user.jobs.create!(company_title: 'Company A', final_decision: 'Waiting')
      offered_job = @user.jobs.create!(company_title: 'Company B', final_decision: 'Received Offer')

      get :index, params: {user_id: @user.id, final_decision: 'Waiting'}

      expect(assigns(:jobs)).to contain_exactly(waiting_job)
    end

    it 'filters jobs by action required' do
      sign_in @user
      Timecop.freeze(Date.parse('2023-11-24'))
      job1 = @user.jobs.create!(company_title: 'Company 1', final_decision: 'Waiting', online_assessment_status: 'Pending', online_assessment_deadline: '2023-11-25')
      job2 = @user.jobs.create!(company_title: 'Company 2', final_decision: 'Waiting', interview_status: 'Scheduled', interview_date: '2023-11-25')

      get :index, params: {user_id: @user.id, task_list: 'Both'}

      expect(assigns(:jobs)).to eq([job1, job2])
    end

    it 'sorts jobs by company_title in ascending order' do
      sign_in @user
      job1 = @user.jobs.create!(company_title: 'BCG', priority: "High", online_assessment_status: "Pending", interview_status: "N/A", final_decision: "Waiting", date_applied: 1.day.ago)
      job2 = @user.jobs.create!(company_title: 'Amazon', priority: "High", online_assessment_status: "Pending", interview_status: "N/A", final_decision: "Waiting", date_applied: 1.day.ago)

      get :index, params: {user_id: @user.id, sort_jobs: "Company Title: A-Z"}
      applied = assigns(:applied_jobs)
      expect(applied).to eq([job2, job1])
    end

    it 'sorts jobs by company_title in descending order' do
      sign_in @user
      job1 = @user.jobs.create!(company_title: 'Amazon', priority: "High", online_assessment_status: "Pending", interview_status: "N/A", final_decision: "Waiting", date_applied: 1.day.ago)
      job2 = @user.jobs.create!(company_title: 'BCG', priority: "High", online_assessment_status: "Pending", interview_status: "N/A", final_decision: "Waiting", date_applied: 1.day.ago)

      get :index, params: {user_id: @user.id, sort_jobs: "Company Title: Z-A"}
      applied = assigns(:applied_jobs)
      expect(applied).to eq([job2, job1])
    end

    it 'sorts jobs by date_applied in descending order' do
      sign_in @user
      job1 = @user.jobs.create!(company_title: 'Amazon', priority: "High", online_assessment_status: "Pending", interview_status: "N/A", final_decision: "Waiting", date_applied: 1.day.ago)
      job2 = @user.jobs.create!(company_title: 'BCG', priority: "High", online_assessment_status: "Pending", interview_status: "N/A", final_decision: "Waiting", date_applied: 2.day.ago)

      get :index, params: {user_id: @user.id, sort_jobs: "Date Applied"}
      applied = assigns(:applied_jobs)
      expect(applied).to eq([job2, job1])
    end

    it 'sorts jobs by priority in ascending order' do
      sign_in @user
      job2 = @user.jobs.create!(company_title: 'Amazon', priority: "Low", online_assessment_status: "Pending", interview_status: "N/A", final_decision: "Waiting", date_applied: 1.day.ago)
      job1 = @user.jobs.create!(company_title: 'BCG', priority: "High", online_assessment_status: "Pending", interview_status: "N/A", final_decision: "Waiting", date_applied: 2.day.ago)


      get :index, params: {user_id: @user.id, sort_jobs: "Priority: Low-High"}
      applied = assigns(:applied_jobs)
      expect(applied).to eq([job2, job1])
    end

    it 'sorts jobs by priority in descending order' do
      sign_in @user
      job1 = @user.jobs.create!(company_title: 'Amazon', priority: "Low", online_assessment_status: "Pending", interview_status: "N/A", final_decision: "Waiting", date_applied: 1.day.ago)
      job2 = @user.jobs.create!(company_title: 'BCG', priority: "High", online_assessment_status: "Pending", interview_status: "N/A", final_decision: "Waiting", date_applied: 2.day.ago)

      get :index, params: {user_id: @user.id, sort_jobs: "Priority: High-Low"}

      applied = assigns(:applied_jobs)
      expect(applied).to eq([job2, job1])
    end

    it 'sorts jobs by final_decision in descending order' do
      sign_in @user
      job1 = @user.jobs.create!(company_title: 'Amazon', priority: "Low", online_assessment_status: "Complete", interview_status: "N/A", final_decision: "Rejected", date_applied: 1.day.ago)
      job2 = @user.jobs.create!(company_title: 'BCG', priority: "High", online_assessment_status: "Complete", interview_status: "N/A", final_decision: "Received Offer", date_applied: 2.day.ago)

      get :index, params: {user_id: @user.id, sort_jobs: "Final Decision"}
      applied = assigns(:heard_back_jobs)
      expect(applied).to eq([job1, job2])
    end

    it 'searches jobs by company_title' do
      sign_in @user
      job1 = @user.jobs.create!(company_title: 'Amazon', priority: "Low", online_assessment_status: "Complete", interview_status: "N/A", final_decision: "Rejected", date_applied: 1.day.ago)
      job2 = @user.jobs.create!(company_title: 'BCG', priority: "High", online_assessment_status: "Complete", interview_status: "N/A", final_decision: "Received Offer", date_applied: 2.day.ago)

      get :index, params: {user_id: @user.id, search: "B"}
      applied = assigns(:heard_back_jobs)
      expect(applied).to eq([job2])
    end
  end

  describe 'calculate_oa_and_interview_dates' do
    before(:each) do
       User.destroy_all
       @user = User.create(email:"user@example.com", password: "password")
       @user.save!
    end

    it 'calculates correct interview dates to send reminder' do
      sign_in @user
      job1 = @user.jobs.create!(company_title: 'Amazon', priority: "High", online_assessment_status: "Pending", interview_status: "N/A", final_decision: "Waiting", date_applied: 1.day.ago, interview_date: Date.today+1)
      get :index, params: {user_id: @user.id}

      interviews_due = assigns(:companies_with_interviews_due)
      expect(interviews_due).to include(job1.company_title)
    end

    it 'calculates correct oa date to send reminder' do
      sign_in @user
      job2 = @user.jobs.create!(company_title: 'BCG', priority: "High", online_assessment_status: "Pending", interview_status: "N/A", final_decision: "Waiting", date_applied: 2.day.ago, online_assessment_deadline: Date.today+2)
      job3 = @user.jobs.create!(company_title: 'Splunk', priority: "Low", online_assessment_status: "Pending", interview_status: "N/A", final_decision: "Waiting", date_applied: Date.today, online_assessment_deadline: Date.today+1)

      get :index, params: {user_id: @user.id}
      oa_due = assigns(:companies_with_oa_deadlines)

      expect(oa_due).to include(job2.company_title)
      expect(oa_due).to include(job3.company_title)

    end
  end

  describe 'destroy' do
    before(:each) do
      User.destroy_all
      @user = User.create(email: "user@example.com", password: "password")
      @user.save!
    end

    it 'should destroy a job' do
      sign_in @user
      job = @user.jobs.create!(company_title: 'Lumedica', job_title: 'SWE', application_status: 'N/A')
      previous_count = @user.jobs.count
      delete :destroy, params: {user_id: @user.id, id: job.id}
      expect(@user.jobs.count).to eq(previous_count - 1)
    end
  end

  describe 'job_card_style' do
    it 'returns the correct style for "Received Offer"' do
      job = Job.create!(company_title: 'Target', job_title: 'SWE', final_decision: 'Received Offer')
      expect(controller.job_card_style(job)).to eq('border-color: #6aaf6a; border-width: 3px;')
    end

    it 'returns the correct style for "Rejected"' do
      job = Job.create!(company_title: 'Target', job_title: 'SWE', final_decision: 'Rejected')
      expect(controller.job_card_style(job)).to eq('border-color: #FF4F4B; border-width: 3px;')
    end

    it 'returns an empty string for other decisions' do
      job = Job.create!(company_title: 'Target', job_title: 'SWE', final_decision: 'Waiting')
      expect(controller.job_card_style(job)).to eq('')
    end
  end
end
