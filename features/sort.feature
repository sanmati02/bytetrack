Feature: sort jobs on the homepage

  As a SWE
  So that I can sort my job applications

  Background: jobs in database

  Given I am on the Bytetrack main page
  Given I clear the user database
  Given a registered user with email "user@example.com" and password "password"
  And I follow "Log In"
  When the user types in the email "user@example.com" and password "password"
  And I press "Log in"
  Given the following jobs exist for user "user@example.com":
  | Company    | Date Applied | Priority | Final Decision | Online Assessment Status | Interview Status |
  | Uber       | 2023-09-21   | Low      | Received Offer | Complete                 | Complete         |
  | Amazon     | 2020-01-01   | High     | Rejected       | Complete                 | Not Scheduled    |
  | Google     | 2023-08-15   | High     | Waiting        | Complete                 | Complete         |
  | Netflix    | 2020-01-01   | High     | Waiting        | N/A                      | N/A              |
  | Meta       | 2023-03-03   | Low      | Waiting        | Complete                 | Scheduled        |
  | JP Morgan  | 2023-02-05   | Medium   | Waiting        | Complete                 | Scheduled        |
  | Hulu       | 2020-08-10   | Low      | Waiting        | N/A                      | N/A              |
  | Yahoo      | 2023-09-15   | Medium   | Waiting        | Complete                 | Complete         |


Scenario: sort by company name in decreasing order for each category in Kanban
  Given I am on the Bytetrack home page
  When I select "Company Title: Z-A" for "Sort Jobs"
  And I press "Apply Sort"
  Then I should see "Uber" before "Amazon" in the "Heard Back" column
  Then I should see "Netflix" before "Hulu" in the "Applied" column
  Then I should see "Meta" before "JP Morgan" in the "Completed OA" column
  Then I should see "Yahoo" before "Google" in the "Completed Interviews" column

Scenario: sort by company name in increasing order for each category in Kanban
  Given I am on the Bytetrack home page
  When I select "Company Title: A-Z" for "Sort Jobs"
  And I press "Apply Sort"
  Then I should see "Amazon" before "Uber" in the "Heard Back" column
  Then I should see "Hulu" before "Netflix" in the "Applied" column
  Then I should see "JP Morgan" before "Meta" in the "Completed OA" column
  Then I should see "Google" before "Yahoo" in the "Completed Interviews" column

Scenario: sort by date applied in increasing order
  Given  I am on the Bytetrack home page
  When I select "Date Applied" for "Sort Jobs"
  And I press "Apply Sort"
  Then I should see "2020-01-01" before "2023-09-21" in the "Heard Back" column
  Then I should see "2020-01-01" before "2020-08-10" in the "Applied" column
  Then I should see "2023-02-05" before "2023-03-03" in the "Completed OA" column
  Then I should see "2023-08-15" before "2023-09-15" in the "Completed Interviews" column

Scenario: sort by priority in increasing order
  Given  I am on the Bytetrack home page
  When I select "Priority: Low-High" for "Sort Jobs"
  And I press "Apply Sort"
  Then I should see "Low" before "High" in the "Heard Back" column
  Then I should see "Low" before "High" in the "Applied" column
  Then I should see "Low" before "Medium" in the "Completed OA" column
  Then I should see "Medium" before "High" in the "Completed Interviews" column


Scenario: sort by priority in decreasing order
  Given  I am on the Bytetrack home page
  When I select "Priority: High-Low" for "Sort Jobs"
  And I press "Apply Sort"
  Then I should see "High" before "Low" in the "Heard Back" column
  Then I should see "High" before "Low" in the "Applied" column
  Then I should see "Medium" before "Low" in the "Completed OA" column
  Then I should see "High" before "Medium" in the "Completed Interviews" column


  Scenario: Selecting a sort type and clearing settings
    Given  I am on the Bytetrack home page
    When I select "Priority: High-Low" for "Sort Jobs"
    And I press "Clear Settings"
    Then I should see "Sort By"

Scenario: Sorting and then, clearing settings
  Given  I am on the Bytetrack home page
  When I select "Priority: High-Low" for "Sort Jobs"
  And I press "Apply Sort"
  And I press "Clear Settings"
  Then I should see "Sort By"

Scenario: sort by final decision in decreasing order
  Given  I am on the Bytetrack home page
  When I select "Final Decision" for "Sort Jobs"
  And I press "Apply Sort"
  Then I should see a red border before green border in the Heard Back column
