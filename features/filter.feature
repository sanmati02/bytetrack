Feature: filter jobs on the homepage

  As a SWE
  So that I can filter my job applications

Background: jobs in database

  Given I am on the Bytetrack main page
  Given I clear the user database
  Given a registered user with email "user@example.com" and password "password"
  And I follow "Log In"
  When the user types in the email "user@example.com" and password "password"
  And I press "Log in"
  Given the following jobs exist for user "user@example.com":
  | Company    | Date Applied | Priority | Final Decision | Online Assessment Status | Online Asssessment Deadline | Interview Status | Interview Date |
  | Uber       | 2023-09-21   | Low      | Received Offer | Complete                 |                             | Complete         |                |
  | Amazon     | 2020-01-01   | Low      | Rejected       | Complete                 |                             | Not Scheduled    |                |
  | Google     | 2023-09-15   | High     | Waiting        | Complete                 |                             | Complete         |                |
  | Netflix    | 2020-01-01   | High     | Waiting        | Pending                  | 2023-11-26                  | N/A              |                |
  | Meta       | 2023-08-05   | Medium   | Waiting        | Complete                 |                             | Scheduled        | 2023-11-25     |



Scenario: restrict to jobs with "High" priority
  Given I am on the Bytetrack home page
  When I select "High" for "Priority"
  And I press "Apply Filters"
  Then I should see the following jobs: Google, Netflix
  And I should see "Google" in "Completed Interviews" column
  And I should see "Netflix" in "Applied" column
  But I should not see the following jobs: Uber, Amazon, Meta

Scenario: restrict to jobs with "Low" priority and "Rejected" final decision
  Given I am on the Bytetrack home page
  When I select "Low" for "Priority"
  And I select "Rejected" for "Final Decision"
  And I press "Apply Filters"
  Then I should see the following jobs: Amazon
  But I should not see the following jobs: Uber, Meta, Google, Netflix
  And I should see "Amazon" in "Completed OA" column

Scenario: restrict to jobs based on if action is required
  Given I am on the Bytetrack home page
  Given today is "Tues, 8 Nov 2023"
  When I select "Interview Upcoming" for "Task List"
  And I press "Apply Filters"
  Then I should see the following jobs: Meta
  But I should not see the following jobs: Uber, Amazon, Google, Netflix
  When I select "Both" for "Task List"
  And I press "Apply Filters"
  Then I should see the following jobs: Meta, Netflix
  But I should not see the following jobs: Uber, Amazon, Google

  Scenario: add a filter, but clear filters
    Given I am on the Bytetrack home page
    Given today is "Tues, 8 Nov 2023"
    When I select "Interview Upcoming" for "Task List"
    And I press "Apply Filters"
    And I press "Clear Settings"
    Then I should see "Select Priority"
    Then I should see "Select Final Decision"
    Then I should see "Select Task List"


  Scenario: Filter by Final decision, but clear filters
    Given I am on the Bytetrack home page
    Given today is "Tues, 8 Nov 2023"
    And I select "Rejected" for "Final Decision"
    And I press "Apply Filters"
    Then I press "Clear Settings"
    Then I should see "Select Final Decision"
