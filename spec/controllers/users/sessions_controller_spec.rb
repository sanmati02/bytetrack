require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  describe '#after_sign_in_path_for' do
    # @user = User.create(email: "user@example.com", password: "password")
    let(:user) { create(:user) } # Assuming you have a factory for user

    it 'redirects to the jobs path after sign-in' do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, params: { user: { email: user.email, password: user.password } }

      expect(response).to redirect_to(jobs_path)

  end
  end
end
