Feature: Move files

  Background:
    Given a file named "recipe.rb" with:
    """
    set_base_path 'tmp/aruba/'

    move_files do
      like /^\d+_\d+_\d{4}.txt$/
      to "originals"
    end
    """
    And an empty file named "01_01_2010.txt"

  Scenario: I run the db_import -h command
    When I run `db_import -h`
    Then the output should contain "-h, --help"

  Scenario: I run the db_import command
    When I run `db_import `
