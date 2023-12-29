
Given /the following jobs exist for user "(.*)"/ do |user_email, jobs_table|
  user = User.find_by(email: user_email)
    jobs_table.hashes.each do |job|
      new_job = user.jobs.new(
       company_title: job['Company'],
       job_title: job['Job Title'],
       date_applied: job['Date Applied'],
       priority: job['Priority'],
       final_decision: job['Final Decision'],
       online_assessment_status: job['Online Assessment Status'],
       online_assessment_deadline: job['Online Asssessment Deadline'],
       oa_notes: job['OA Notes'],
       interview_status: job['Interview Status'],
       interview_date: job['Interview Date'],
       interview_notes: job['Interview Notes'],
       confidence_rating_oa: job["OA Confidence"],
       confidence_rating_interview: job["Interview Confidence"]
   )
   new_job.save


  end

    # Alternatively, you can print specific attributes of the job, e.g., job.title
end

Given /I clear the user database/ do
  User.destroy_all
end



And /the list of jobs should not contain "(.*)"$/ do |company_title|
  job = Job.find_by(company_title: company_title)
  expect(job).to be_nil
end

And /I select "(.*)" for "(.*)"/ do |option, field|
  select option, from: field.downcase.gsub(" ", "_")
end

And /I choose "(.*)" for "(.*)"/ do |option, field|
  field = field.downcase.gsub(" ", "_")
  select option, from: "job[#{field}]"
end

And /I update the "(.*)" to "(.*)"/ do |field, option|
  select option, from: field
end

And /I enter "(.*)" for "(.*)"/ do |input, field|
  field.downcase.gsub(" ", "_")
end

And /the Date Applied of "(.*)" should be "(.*)"/ do |company_title, date|
    job = Job.find_by(company_title: company_title)
    expect(Job.find_by(:company_title => company_title).date_applied).to eq Date.parse(date)
end

Then /the Final Decision of "(.*)" should be "(.*)"/ do |company_title, final_decision|
    expect(Job.find_by(:company_title => company_title).final_decision).to eq final_decision
end

Then /the OA Status of "(.*)" should be "(.*)"/ do |company_title, oa_status|
    expect(Job.find_by(:company_title => company_title).online_assessment_status).to eq oa_status
end

Then /the OA Notes of "(.*)" should be "(.*)"/ do |company_title, oa_notes|
    expect(Job.find_by(:company_title => company_title).oa_notes).to eq oa_notes
end

Then /the Priority of "(.*)" should be "(.*)"/ do |company_title, priority|
    expect(Job.find_by(:company_title => company_title).priority).to eq priority
end

Then /the Location of "(.*)" should be "(.*)"/ do |company_title, location|
    expect(Job.find_by(:company_title => company_title).location).to eq location
end

Then /the Confidence OA Rating of "(.*)" should be "(.*)"/ do |company_title, oa_rating|
  expect(Job.find_by(:company_title => company_title).confidence_rating_oa).to eq oa_rating.to_i
end

Then /the Skills of "(.*)" should be "(.*)"/ do |company_title, skills|
    expect(Job.find_by(:company_title => company_title).skills).to eq skills
end

Then /the Interview Notes of "(.*)" should be "(.*)"/ do |company_title, interview_notes|
    expect(Job.find_by(:company_title => company_title).interview_notes).to eq interview_notes
end

Then /the Confidence Interview Rating of "(.*)" should be "(.*)"/ do |company_title, interview_rating|
    expect(Job.find_by(:company_title => company_title).confidence_rating_interview).to eq interview_rating.to_i
end

Then /I should see "(.*)" before "(.*)" in the "(.*)" column/ do |e1, e2, column_name|

  card_elements = page.all(".col-md .card-body:has(h5.card-title:contains('#{column_name}'))")

  index1 = card_elements[0].text.index(e1)
  index2 = card_elements[0].text.index(e2)
  expect(index1).to be < index2

 end

Then /^I should (not )?see the following jobs: (.*)$/ do |no, job_list|
  jobs = job_list.split(", ")
  if no.nil?
    jobs.each do |job|
      expect(page).to have_content(job)
    end
  else
    jobs.each do |job|
      expect(page).not_to have_content(job)
    end
  end
end

And /I should see "(.*)" in "(.*)" column/ do |company_title, column_name|
  card_elements = page.all(".col-md .card-body:has(h5.card-title:contains('#{column_name}'))")
  expect(card_elements[0].text.include?(company_title))

 end

Then /^I should (not )?see an OA reminder for the following jobs: (.*)$/ do |no, job_list|
  jobs = job_list.split(", ")
  list_items = page.all('#oa .alert.alert-warning ul li')
  item_texts = list_items.map(&:text)
  if no.nil?
    jobs.each do |job|
      expect(item_texts).to include(job)
    end
  else
    expect(item_texts.length).to eq(0)
  end
end

Then /^I should (not )?see an interview reminder for the following jobs: (.*)$/ do |no, job_list|
  jobs = job_list.split(", ")
  list_items = page.all('#interview .alert.alert-warning ul li')
  item_texts = list_items.map(&:text)
  if no.nil?
    jobs.each do |job|
      expect(item_texts).to include(job)
    end
  else
    expect(item_texts.length).to eq(0)
  end
end

Given("today is {string}") do |today_date|
    Timecop.freeze(Date.parse(today_date))
end

Then /^I should get an alert for required field (.*)$/ do |field|
  error_message_pattern = /#{Regexp.escape(field)} cannot be empty/
  expect(page).to have_content(error_message_pattern)
end

Then(/^I should get an alert for future Date Applied entry$/) do
  expect(page).to have_content("Date Applied must not be in the future.")
end

Then(/^I should get an alert for OA deadline being before Date Applied entry$/) do
  expect(page).to have_content("Online Assessment Deadline must be after Date Applied")
end

Then(/^I should get an alert for Interview Date being before Date Applied entry$/) do
  expect(page).to have_content("Interview Date must be after Date Applied.")
end

Then (/^I should see a red border before green border in the Heard Back column$/) do
  card_elements = page.all(".col-md .card-body:has(h5.card-title:contains('Heard Back'))")

  index1 = card_elements[0].native.inner_html.index('FF4F4B')
  index2 = card_elements[0].native.inner_html.index('6aaf6a')
  expect(index1).to be < index2
  # expect(card_elements[0].text.include?(company_title))
end



Then("I should see 6 Chartkick charts") do
  expect(page).to have_css('div#chart-1')
  expect(page).to have_css('div#chart-2')
  expect(page).to have_css('div#chart-3')
  expect(page).to have_css('div#chart-4')
  expect(page).to have_css('div#chart-5')
  expect(page).to have_css('div#chart-6')
end


Given(/^a registered user with email "([^"]*)" and password "([^"]*)"$/) do |email, password|
  create(:user, email: email, password: password) # Use FactoryBot or your preferred way to create a user
end

When(/^the user types in the email "([^"]*)" and password "([^"]*)"$/) do |email, password|
  visit new_user_session_path
  fill_in 'Email', with: email
  fill_in 'Password', with: password
end

When(/^the user types in the email "([^"]*)" and password "([^"]*)" and confirmation "([^"]*)"$/) do |email, password, confirm|
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  fill_in 'Password confirmation', with: confirm
end

Then(/^they should see a success message$/) do
  expect(page).to have_content('Signed in successfully')
end

Then(/^they should see a success message for signing up$/) do
  expect(page).to have_content('You have signed up successfully')
end

When (/^I follow Log in$/) do
  find('input[value="Log in"]').click
end

Given(/^a user is signed in with email "([^"]*)" and password "([^"]*)"$/) do |email, password|
  create(:user, email: email, password: password) # Use FactoryBot or your preferred way to create a user
  visit new_user_session_path
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  find('input[value="Log in"]').click
end

Then(/^they should see a signed-out message$/) do
  expect(page).to have_content('Signed out successfully')
end

Then(/^they should see an error message for password mismatch$/) do
  expect(page).to have_content("Password confirmation doesn't match Password")
end

Then(/^they should see an error message for password length$/) do
  expect(page).to have_content("Password is too short")
end

Then(/^they should see an error message for wrong username or password$/) do
  expect(page).to have_content("Invalid Email or password")
end

And(/^I print out contents$/) do
  puts page.html
end


Given("there are users with the following jobs:") do |table|
  table.hashes.each do |row|
    user_email = row['User Email']
    password = row['Password']
    user = User.find_or_create_by(email: user_email) do |u|
      u.password = password
    end
        user.save!
        user.jobs.create(company_title: row['Company Title'], job_title: row['Job Title'])
  end
end


Then("I should see the following autocomplete suggestions:") do |table|
  expected_suggestions = table.raw.flatten
  actual_suggestions_string = page.body
  actual_suggestions = JSON.parse(actual_suggestions_string)
  expect(actual_suggestions).to match_array(expected_suggestions)
end

Given(/^I visit the company titles field with term "([^"]*)"$/) do |term|
  visit company_titles_path(term: term)
end

Given(/^I visit the job titles field with term "([^"]*)"$/) do |term|
  visit job_titles_path(term: term)
end
