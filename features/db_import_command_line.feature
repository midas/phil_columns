Feature: db_import command line

  Scenario: I run the db_import -h command
    When I run `db_import -h`
    Then the output should contain "-h, --help"

  Scenario: I run the db_import command with no recipe file path
    When I run `db_import`
    Then the output should contain "Please provide a recipe file path"

  Scenario: I run the db_import command with a non-existent recipe file
    When I run `db_import /some/non/existent/recip/path.rb`
    Then the output should contain "Recipe file does not exist"
