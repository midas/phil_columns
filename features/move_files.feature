Feature: Move files

  Background:
    Given an empty file named "01_01_2010.txt"

  Scenario: Running the db_import command with a recipe containing the move_files command
    Given a file named "recipe.rb" with:
    """
    set_base_path '/Users/cjharrelson/development/personal/gems/phil_columns/tmp/aruba'

    move_files do
      like /^\d+_\d+_\d{4}.txt$/
      to "originals"
    end
    """
    When I run `db_import /Users/cjharrelson/development/personal/gems/phil_columns/tmp/aruba/recipe.rb`
    Then the exit status should be 0
    And the following files should exist:
      | originals/01_01_2010.txt |
    And the following files should not exist:
      | 01_01_2010.txt |

  Scenario: Running the db_import command (overriding the base path) with a recipe containing the move_files command
    Given a file named "recipe.rb" with:
    """
    set_base_path '/some/fake/base/path'

    move_files do
      like /^\d+_\d+_\d{4}.txt$/
      to "originals"
    end
    """
    When I run `db_import /Users/cjharrelson/development/personal/gems/phil_columns/tmp/aruba/recipe.rb -p /Users/cjharrelson/development/personal/gems/phil_columns/tmp/aruba`
    Then the exit status should be 0
    And the following files should exist:
      | originals/01_01_2010.txt |
    And the following files should not exist:
      | 01_01_2010.txt |
