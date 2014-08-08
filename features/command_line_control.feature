# File: command_line_control.feature

Feature: Command line control
  In order to control the program
  As a command line user
  I want to be able to have a CLI control interface

  # Scenario 1
  Scenario: Show CLI help screen when started without task
    When I run `scylla`
    Then the output should match /Commands/

  Scenario: Show help info when `help` argument passed
    When I run `scylla help`
    Then the output should match /Commands/

  Scenario: Show error and usage example if crawl called without url
    When I run `scylla crawl`
    Then the output should match:
      """
      ERROR:.*was called with no arguments
      Usage:.*crawl <url>
      """

  Scenario: Run crawler when url specified
    When I run `scylla crawl http://api.github.com`
    Then the output should contain "Started crawler on"
    And the output should contain "http://api.github.com"