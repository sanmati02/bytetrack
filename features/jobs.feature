Feature: add and edit jobs

  As a SWE
  So that I can track my job applications

Background: jobs in database

Given I am on the Bytetrack main page
Given I clear the user database
Given a registered user with email "user@example.com" and password "password"
And I follow "Log In"
When the user types in the email "user@example.com" and password "password"
And I press "Log in"
Given the following jobs exist for user "user@example.com":
  | Company    | Job Title  | Date Applied | Priority | Final Decision | Online Assessment Status | Interview Status |
  | Uber       | SWE Intern | 2023-09-01   | Low      | Received Offer | Not yet received         | Complete         |
  | Amazon     | SDE Intern | 2020-01-01   | Low      | Rejected       | Complete                 | Not scheduled    |
  | Google     | SWE Intern | 2023-09-01   | High     | Waiting        | Complete                 | Not scheduled    |
  | Netflix    | SWE Intern | 2020-01-01   | High     | Waiting        | N/A                      | N/A              |
  | Meta       | TPM Intern | 2023-08-05   | Medium   | Waiting        | Not yet received         | Scheduled        |


Scenario: create a new job to be in the Applied Column
  Given I am on the Bytetrack homepage

  When I follow "Add New Job"
  And  I fill in "company_title" with "Apple"
  And I fill in "job_title" with "SWE Intern"
  And  I fill in "Date Applied" with "2023-10-01"
  And  I press "Save Changes"
  Then I should be on the home page
  And  I should see "Apple"
  And the Date Applied of "Apple" should be "2023-10-01"
  And I should see "Apple" in "Applied" column

Scenario: create a new job with OA Status as complete to be in the Completed OA column
  Given I am on the Bytetrack homepage
  When I follow "Add New Job"
  And  I fill in "company_title" with "Morgan & Stanley"
  And I fill in "job_title" with "SDE Intern"
  And  I fill in "Date Applied" with "2022-11-03"
  And  I choose "Complete" for "Online Assessment Status"
  And  I press "Save Changes"
  Then I should be on the home page
  And  I should see "Morgan & Stanley"
  And the Date Applied of "Morgan & Stanley" should be "2022-11-03"
  And the OA Status of "Morgan & Stanley" should be "Complete"
  And I should see "Morgan & Stanley" in "Completed OA" column

Scenario: create a new job with OA Status as Pending and Interview Status as Complete to be in the Completed Interview column
  Given I am on the Bytetrack homepage
  When I follow "Add New Job"
  And  I fill in "company_title" with "PayPal"
  And  I fill in "Date Applied" with "2023-08-11"
  And I fill in "job_title" with "SWE"
  And  I choose "Complete" for "Interview Status"
  And  I choose "Pending" for "Online Assessment Status"
  And  I press "Save Changes"
  Then I should be on the home page
  And  I should see "PayPal"
  And the Date Applied of "PayPal" should be "2023-08-11"
  And I should see "PayPal" in "Completed Interviews" column

Scenario: create a new job with Final decision provided to be in the Heard Back column
  Given I am on the Bytetrack homepage
  When I follow "Add New Job"
  And  I fill in "company_title" with "Ikea"
  And  I fill in "Date Applied" with "2023-04-23"
  And I fill in "job_title" with "SWE"
  And  I choose "Rejected" for "Final Decision"
  And  I press "Save Changes"
  Then I should be on the home page
  And  I should see "Ikea"
  And the Date Applied of "Ikea" should be "2023-04-23"
  And I should see "Ikea" in "Heard Back" column

Scenario: create a new job with location, priority, and skills
  Given I am on the Bytetrack homepage
  When I follow "Add New Job"
  And  I fill in "company_title" with "Microsoft"
  And  I fill in "Date Applied" with "2023-10-19"
  And I fill in "job_title" with "SWE"
  And  I fill in "Seattle, Washington" for "Location"
  And  I fill in "Object Oriented Programming in Java" for "Skills"
  And  I choose "High" for "Priority"
  And  I press "Save Changes"
  Then I should be on the home page
  And  I should see "Microsoft"
  And the Date Applied of "Microsoft" should be "2023-10-19"
  And the Priority of "Microsoft" should be "High"
  And the Location of "Microsoft" should be "Seattle, Washington"
  And the Skills of "Microsoft" should be "Object Oriented Programming in Java"
  And I should see "Microsoft" in "Applied" column

Scenario: create a new job and edit to add OA notes, OA rating
  Given I am on the Bytetrack homepage
  When I follow "Add New Job"
  And  I fill in "company_title" with "Salesforce"
  And  I fill in "Date Applied" with "2022-11-14"
  And I fill in "job_title" with "SWE"
  And  I press "Save Changes"
  Then I should be on the home page
  And I go to the edit page for "Salesforce" and user "user@example.com"
  And  I update the "OA Status" to "Complete"
  And  I fill in "leetcode medium" for "OA Notes"
  And  I update the "OA Confidence Rating" to "4"
  And  I press "Update Job Info"
  And I follow "ByteTrack"
  Then I should be on the home page
  And  I should see "Salesforce"
  And the Date Applied of "Salesforce" should be "2022-11-14"
  And the OA Notes of "Salesforce" should be "leetcode medium"
  And the Confidence OA Rating of "Salesforce" should be "4"
  And I should see "Salesforce" in "Completed OA" column

Scenario: create a new job and edit to add interview notes, interview rating
  Given I am on the Bytetrack homepage
  When I follow "Add New Job"
  And  I fill in "company_title" with "United Healthcare"
  And  I fill in "Date Applied" with "2022-12-12"
  And I fill in "job_title" with "SWE"
  And  I press "Save Changes"
  Then I should be on the home page
  And I go to the edit page for "United Healthcare" and user "user@example.com"
  And  I update the "Interview Status" to "Complete"
  And  I fill in "asked me my strengths and weaknesses" for "Interview Notes"
  And  I update the "Interview Confidence Rating" to "2"
  And  I press "Update Job Info"
  And I follow "ByteTrack"
  And  I should see "United Healthcare"
  And the Date Applied of "United Healthcare" should be "2022-12-12"
  And the Interview Notes of "United Healthcare" should be "asked me my strengths and weaknesses"
  And the Confidence Interview Rating of "United Healthcare" should be "2"
  And I should see "United Healthcare" in "Completed Interviews" column

Scenario: update final decision to existing job
  And I go to the edit page for "Amazon" and user "user@example.com"
  And  I update the "Final Decision" to "Rejected"
  And  I press "Update Job Info"
  Then the Final Decision of "Amazon" should be "Rejected"
  And I follow "ByteTrack"
  Then I should be on the home page
  And I should see "Amazon" in "Heard Back" column

Scenario: update OA Status to existing job
  And I go to the edit page for "Netflix" and user "user@example.com"
  And  I update the "OA Status" to "Complete"
  And  I press "Update Job Info"
  Then the OA Status of "Netflix" should be "Complete"
  And I follow "ByteTrack"
  Then I should be on the home page
  And I should see "Netflix" in "Completed OA" column

Scenario: delete a job
  When I go to the details page for "Meta"
  Then I should see "Delete"
  And I follow "Delete"
  Then I should be on the home page
  And the list of jobs should not contain "Meta"

Scenario: Input validation test - user does not fill in required field of date applied
  Given I am on the Bytetrack homepage
  When I follow "Add New Job"
  And  I fill in "company_title" with "Figma"
  And I fill in "job_title" with "SWE Intern"
  And  I press "Save Changes"
  Then I should get an alert for required field Date Applied
  And  I fill in "Date Applied" with "2022-11-14"
  And  I press "Save Changes"
  Then I should be on the home page
  And the Date Applied of "Figma" should be "2022-11-14"
  And I should see "Figma" in "Applied" column

Scenario: Input validation test - user does not fill in required field of company title
  Given I am on the Bytetrack homepage
  When I follow "Add New Job"
  And I fill in "job_title" with "SWE Intern"
  And  I fill in "Date Applied" with "2023-08-11"
  And  I press "Save Changes"
  Then I should get an alert for required field Company
  And  I fill in "company_title" with "GE"
  And  I press "Save Changes"
  Then I should be on the home page
  And the Date Applied of "GE" should be "2023-08-11"
  And I should see "GE" in "Applied" column

Scenario: Input validation test - user does not fill in required field of job title
  Given I am on the Bytetrack homepage
  When I follow "Add New Job"
  And  I fill in "company_title" with "Datadog"
  And  I fill in "Date Applied" with "2022-11-09"
  And  I press "Save Changes"
  Then I should get an alert for required field Job Title
  And  I fill in "job_title" with "SWE intern"
  And  I press "Save Changes"
  Then I should be on the home page
  And I should see "Datadog" in "Applied" column

Scenario: Erroneous input - date applied is set to the future
  Given today is "Mon, 13 Nov 2023"
  Given I am on the Bytetrack homepage
  When I follow "Add New Job"
  And  I fill in "company_title" with "Tesla"
  And  I fill in "Date Applied" with "2024-11-09"
  And I fill in "job_title" with "SWE Intern"
  And  I press "Save Changes"
  Then I should get an alert for future Date Applied entry
  And  I fill in "Date Applied" with "2023-11-09"
  And  I press "Save Changes"
  Then I should be on the home page
  And I should see "Tesla" in "Applied" column

Scenario: Erroneous input - interview date has to be after date applied
  Given today is "Mon, 13 Nov 2023"
  Given I am on the Bytetrack homepage
  When I follow "Add New Job"
  And  I fill in "company_title" with "Best Buy"
  And  I fill in "Date Applied" with "2023-11-09"
  And  I fill in "Interview Date" with "2022-10-09"
  And I fill in "job_title" with "SWE Intern"
  And  I press "Save Changes"
  Then I should get an alert for Interview Date being before Date Applied entry
  And  I fill in "Interview Date" with "2023-11-18"
  And  I press "Save Changes"
  Then I should be on the home page
  And I should see "Best Buy" in "Applied" column

Scenario: Erroneous input - OA deadline has to be after date applied
  Given today is "Mon, 13 Nov 2023"
  Given I am on the Bytetrack homepage
  When I follow "Add New Job"
  And  I fill in "company_title" with "Delta"
  And  I fill in "Date Applied" with "2023-11-09"
  And  I fill in "OA Deadline" with "2021-08-11"
  And I fill in "job_title" with "SWE Intern"
  And  I press "Save Changes"
  Then I should get an alert for OA deadline being before Date Applied entry
  And  I fill in "OA Deadline" with "2023-11-25"
  And  I press "Save Changes"
  Then I should be on the home page
  And I should see "Delta" in "Applied" column

Scenario: Input validation test - user tries removing required fields while editing
  Given I am on the Bytetrack homepage
  And I go to the edit page for "Uber" and user "user@example.com"
  And  I fill in "Company" with ""
  And I fill in "Job Title" with ""
  And  I fill in "Date Applied" with ""
  And  I press "Update Job Info"
  Then I should get an alert for required field Company
  Then I should get an alert for required field Job Title
  Then I should get an alert for required field Date Applied
  And  I fill in "Date Applied" with "2022-11-14"
  And  I fill in "Company" with "Uber"
  And I fill in "Job Title" with "SWE Intern"
  And  I fill in "Date Applied" with "2023-09-22"
  And  I press "Update Job Info"
  Then I should be on the details page for "Uber"

Scenario: Erroneous input - date applied is set to the future while editing
  Given today is "Mon, 13 Nov 2023"
  Given I am on the Bytetrack homepage
  And I go to the edit page for "Uber" and user "user@example.com"
  And  I fill in "Date Applied" with "2023-11-15"
  And  I press "Update Job Info"
  Then I should get an alert for future Date Applied entry
  And  I fill in "Date Applied" with "2023-11-14"
  And  I press "Update Job Info"
  Then I should be on the details page for "Uber"

Scenario: Erroneous input - OA deadline and interview date set to before date applied while editing
  Given today is "Mon, 13 Nov 2023"
  Given I am on the Bytetrack homepage
  And I go to the edit page for "Uber" and user "user@example.com"
  And  I fill in "OA Deadline" with "2021-08-11"
  And  I fill in "Interview Date" with "2021-08-11"
  And  I press "Update Job Info"
  Then I should get an alert for OA deadline being before Date Applied entry
  Then I should get an alert for Interview Date being before Date Applied entry
  And  I fill in "OA Deadline" with "2023-11-25"
  And  I fill in "Interview Date" with "2023-11-25"
  And  I press "Update Job Info"
  Then I should be on the details page for "Uber"
