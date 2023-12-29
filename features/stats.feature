Feature: see application stats

  As a SWE
  So that I can see stats for my job applications

  Background: jobs in database

    Given I am on the Bytetrack main page
    Given I clear the user database
    Given a registered user with email "user@example.com" and password "password"
    And I follow "Log In"
    When the user types in the email "user@example.com" and password "password"
    And I press "Log in"
    Given the following jobs exist for user "user@example.com":
    | Company    | Date Applied | Priority | Final Decision | Online Assessment Status | Interview Status | OA Confidence | Interview Confidence |
    | Uber       | 2023-09-21   | Low      | Received Offer | Complete                 | Complete         | 2             | 4                    |
    | Amazon     | 2020-01-01   | Low      | Rejected       | Complete                 | Not Scheduled    | 2             | 5                    |
    | Google     | 2023-09-15   | High     | Waiting        | Complete                 | Complete         | 3             | 3                    |
    | Netflix    | 2020-01-01   | High     | Waiting        | N/A                      | N/A              | 4             | 4                    |
    | Meta       | 2023-08-05   | Medium   | Waiting        | Complete                 | Scheduled        | 4             | 5                    |


Scenario: go to stats page from homepage
  Given I am on the Bytetrack homepage
  When I follow "See Statistics"
  Then I should be on the stats page
  And I should see "Application Statistics"

Scenario: viewing summary paragraph
  Given I am on the stats page
  And I should see "5 job(s) applied"
  And I should see "4 online assessment(s) completed with a confidence of 60.0%"
  And I should see "2 interview(s) completed with a confidence of 84.0%"
  And I should see "1 offer(s) received"
  And I should see "1 rejection(s)"
  And I should see "3 pending"

Scenario: viewing charts
  Given I am on the stats page
  Then I should see 6 Chartkick charts
