Feature: User Authentication

Background: clear users
Given I clear the user database

Scenario: User signs in successfully
  Given a registered user with email "user@example.com" and password "password"
  When the user types in the email "user@example.com" and password "password"
  When I follow Log in
  Then they should see a success message

Scenario: User signs out successfully
  Given a user is signed in with email "user@example.com" and password "password"
  And I follow "Sign Out"
  Then they should see a signed-out message
  And I am on the Bytetrack main page



Scenario: User signs in successfully
  Given I am on the Bytetrack main page
  And I follow "Sign Up"
  When the user types in the email "user@example.com" and password "password" and confirmation "password"
  And I press "Sign up"
  Then they should see a success message for signing up


Scenario: User makes mistakes while signing up (password mismatching)
  Given I am on the Bytetrack main page
  And I follow "Sign Up"
  When the user types in the email "user@example.com" and password "password" and confirmation "password1"
  And I press "Sign up"
  Then they should see an error message for password mismatch
  When the user types in the email "user@example.com" and password "password" and confirmation "password"
  And I press "Sign up"
  Then they should see a success message for signing up

Scenario: User makes mistakes while signing up (password length)
    Given I am on the Bytetrack main page
    And I follow "Sign Up"
    When the user types in the email "user@example.com" and password "pass" and confirmation "pass"
    And I press "Sign up"
    Then they should see an error message for password length
    When the user types in the email "user@example.com" and password "password" and confirmation "password"
    And I press "Sign up"
    Then they should see a success message for signing up


Scenario: User makes mistakes while signing in (wrong username)
    Given I am on the Bytetrack main page
    Given a registered user with email "user@example.com" and password "password"
    And I follow "Log In"
    When the user types in the email "student@example.com" and password "password"
    And I press "Log in"
    Then they should see an error message for wrong username or password
    When the user types in the email "user@example.com" and password "password"
    And I press "Log in"
    Then they should see a success message



  Scenario: User makes mistakes while signing in (wrong password)
      Given I am on the Bytetrack main page
      Given a registered user with email "user@example.com" and password "password"
      And I follow "Log In"
      When the user types in the email "student@example.com" and password "pass"
      And I press "Log in"
      Then they should see an error message for wrong username or password
      When the user types in the email "user@example.com" and password "password"
      And I press "Log in"
      Then they should see a success message
