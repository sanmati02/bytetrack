# spec/controllers/company_titles_controller_spec.rb

require 'rails_helper'

RSpec.describe JobTitlesController, type: :controller do

  describe '#index' do
    before(:each) do
      User.destroy_all
      @user1 = User.create(email:"user@example.com", password: "password")
      @user1.save!
      @user1.jobs.create(company_title: 'ABC Inc.', job_title: 'SWE Grad', final_decision: 'Waiting')
      @user2 = User.create(email:"user1@example.com", password: "password1")
      @user2.save!
      @user2.jobs.create(company_title: 'XYZ Ltd.', job_title: 'SDE', final_decision: 'Waiting')
      # @jobs = @user.jobs
    end

    it 'returns a JSON array of unique job titles based on the search term' do
      # user1 = create(:user)
      # user2 = create(:user)
      # job1 = create(:job, user: user1, company_title: 'ABC Inc.')
      # job2 = create(:job, user: user2, company_title: 'XYZ Ltd.')

      get :index, params: { term: 'SW' }, format: :json

      response_body = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/json')
      expect(response_body).to match_array(['SWE Grad'])
    end
  end
end
