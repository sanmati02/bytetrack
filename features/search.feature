Feature: add and edit jobs

  As a SWE
  So that I can search my job applications

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
    | Amazon     | 2020-01-01   | Low      | Rejected       | Complete                 | Not Scheduled    |
    | Google     | 2023-09-15   | High     | Waiting        | Complete                 | Complete         |
    | Microsoft  | 2020-01-01   | High     | Waiting        | N/A                      | N/A              |
    | Meta       | 2023-08-05   | Medium   | Waiting        | Complete                 | Scheduled        |

  Scenario: search through jobs using company name
    Given I am on the Bytetrack home page
    When I fill in "search" with "m"
    And I press "Apply Search"
    Then I should see the following jobs: Meta, Microsoft
    But I should not see the following jobs: Uber, Amazon, Google
    And I should see "Meta" in "Completed Interviews" column
    And I should see "Microsoft" in "Applied" column
