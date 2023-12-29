class Users::SessionsController < Devise::SessionsController
    protected
  
    def after_sign_in_path_for(resource)
      jobs_path 
    end
  end