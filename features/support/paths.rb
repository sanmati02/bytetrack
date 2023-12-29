# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #

  def edit_job_path_for_company_title_and_user(company_title, user_email)
    user = User.find_by(email: user_email)

  #   user.jobs.each do |job|
  #     print("here")
  #     puts job.inspect
  # # Alternatively, you can print specific attributes of the job, e.g., job.title
  #   end
    job = user.jobs.find_by(company_title: company_title)

    if job
      edit_job_path(job)
    else
      # Handle the case when the user or job is not found, e.g., redirect to an error page
      raise ActiveRecord::RecordNotFound, "Job not found for company_title: #{company_title} and user_login: #{user_email}"
    end
  end


  def path_to(page_name)
    case page_name

    when /^the (Bytetrack )?home\s?page$/ then '/jobs'
    when /^the (Bytetrack )?main\s?page$/ then '/'


    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))


  when /^the edit page for "(.*)" and user "(.*)"$/ then edit_job_path_for_company_title_and_user($1, $2)
  when /^the details page for "(.*)"$/ then job_path(Job.find_by(company_title: $1).id)

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
