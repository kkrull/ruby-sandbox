Feature: Get help
  In order to write tests without any more effort than necessary
  As a programmer
  I want to be able to use helper classes that are available to RSpec

  Scenario: Get help from Cucumber-specific helper modules
    When I use a cucumber helper module
    Then help should be available
  
  Scenario: Get help from helper module shared with RSpec
    When I use a rspec helper module
    Then help should be available
