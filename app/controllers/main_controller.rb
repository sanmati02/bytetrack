class MainController < ApplicationController
  before_action :ensure_no_user_signed_in
  def home
  end


  private

  def ensure_no_user_signed_in
    sign_out(current_user) if user_signed_in?
  end
end
