Feature: Autocomplete Company Titles

  Scenario: Display autocomplete suggestions based on input in company title
    Given there are users with the following jobs:
      | User Email        | Password   | Company Title            |
      | user1@example.com | 123456     | ABC Inc.                 |
      | user2@example.com | 1234567    | XYZ Corporation          |
      | user3@example.com | 12345678   | Autocomplete Suggestions |

    Given I visit the company titles field with term "A"


    Then I should see the following autocomplete suggestions:
      | Autocomplete Suggestions |
      | ABC Inc.                 |


  Scenario: Display autocomplete suggestions based on input in job title
    Given there are users with the following jobs:
      | User Email        | Password   | Job Title            |
      | user1@example.com | 123456     | SWE Intern           |
      | user2@example.com | 1234567    | SDE                  |
      | user3@example.com | 12345678   | SWE                  |

    Given I visit the job titles field with term "SWE"

    Then I should see the following autocomplete suggestions:
      | SWE Intern  |
      | SWE         |
