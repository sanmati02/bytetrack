require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  describe '#after_sign_up_path_for' do
    # @user = User.create(email: "user@example.com", password: "password")
    let(:user_params) { { email: 'test@example.com', password: 'password' } }

    it 'redirects to the jobs path after sign-up' do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, params: { user: user_params }

      expect(response).to redirect_to(jobs_path)

  end
  end
end
