Feature: reminders on the homepage

  As a SWE
  So that I can get reminders on impending OA and interview deadlines

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



Scenario: add OA Notes and Interview Date not within 3 days to existing jobs and not see reminders for the interview
And I go to the edit page for "Amazon" and user "user@example.com"
  And  I fill in "OA Notes" with "implement binary tree"
  And  I fill in "Interview Date" with "Sat, 28 Oct 2023"
  And  I press "Update Job Info"
  And I go to the edit page for "Meta" and user "user@example.com"
  And  I fill in "Interview Date" with "Sat, 31 Dec 2023"
  And  I press "Update Job Info"
  And I follow "ByteTrack"
  Then I should be on the home page
  Then I should not see an interview reminder for the following jobs: Amazon, Meta

Scenario: add OA Notes and Interview Date within 3 days to an existing job and see a reminder for the interview
  Given today is "Tues, 8 Nov 2023"
  And I go to the edit page for "Google" and user "user@example.com"
  And  I fill in "OA Notes" with "three sum"
  And  I fill in "Interview Date" with "Sat, 9 Nov 2023"
  And  I press "Update Job Info"
  And I follow "ByteTrack"
  Then I should be on the home page
  Then I should see an interview reminder for the following jobs: Google

Scenario: See OA reminder for multiple jobs after editing with deadlines in the next 3 days
  Given today is "Tues, 8 Nov 2023"
  And I go to the edit page for "Uber" and user "user@example.com"
  And  I fill in "OA Deadline" with "Sat, 10 Nov 2023"
  And  I press "Update Job Info"
  And I go to the edit page for "Meta" and user "user@example.com"
  And  I fill in "OA Deadline" with "Sat, 9 Nov 2023"
  And  I press "Update Job Info"
  And I follow "ByteTrack"
  Then I should be on the home page
  Then I should see an OA reminder for the following jobs: Uber, Meta

Scenario: Should not see OA reminder for a job after with OA deadline in 5 days
  Given today is "Tues, 8 Nov 2023"
  And I go to the edit page for "Netflix" and user "user@example.com"
  And  I fill in "OA Deadline" with "Sat, 2 Nov 2023"
  And  I press "Update Job Info"
  And I follow "ByteTrack"
  Then I should be on the home page
  Then I should not see an OA reminder for the following jobs: Netflix
