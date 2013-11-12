Feature: Bulk raw image search
  In order to get bulk raw image search results
  As a user
  I want to search using bulk image queries

  Background:
    Given I am on the home page

#  @javascript
#  @not-jenkins
#  Scenario Outline: I perform bulk image search
#    Given I select the "Bulk Image" tab
#    And I attach the file "<file>" to "File"
#    And I press "Search SkyMapper"
#    Then I should be on the raw image search results page
#    And I wait for "Fetching results..."
#    And I should see "Query returned <count> objects."
#    And I should see results for catalogue "<catalogue>" as "<results>" in all pages with limit "50"
#    And I should see raw image results as "<results>" in all pages with limit "50" in proper order
#    Then I follow "Back"
#    And I should see the "Bulk Image" tab
#  Examples:
#    | catalogue | file | results                 | count |
#    | image     |      | skymapper_image_query_1 | 36    |
#    | image     |      | skymapper_image_query_3 | 1000  |

  @javascript
  Scenario: I cannot submit bulk image search if csv file has errors
    Given I select the "Bulk Image" tab
    And I attach the file "skymapper_bulk_invalid_4.csv" to "File"
    And I select "CSV" from "Download format"
    And I press "Search SkyMapper"
    Then I should the following list of file errors
      | error                                                                        |
      | Line 7: Right ascension must be greater than or equal to 0                   |
      | Line 8: Right ascension must be less than 360                                |
      | Line 9: Right ascension must be less than 360                                |
      | Line 10: Right ascension must be greater than or equal to 0                  |
      | Line 11: Right ascension must be a number with a maximum of 6 decimal places |
      | Line 12: Right ascension can't be blank                                      |
      | Line 12: Right ascension is not a number                                     |
      | Line 13: Right ascension can't be blank                                      |
      | Line 13: Right ascension is not a number                                     |
      | Line 14: Right ascension is not a number                                     |
      | Line 14: Right ascension must be a number with a maximum of 6 decimal places |
      | Line 15: Right ascension is not a number                                     |
      | Line 15: Right ascension must be a number with a maximum of 6 decimal places |
      | Line 16: Right ascension is not a number                                     |
      | Line 16: Right ascension must be a number with a maximum of 6 decimal places |
      | Line 7: Declination must be greater than or equal to -90                     |
      | Line 8: Declination must be less than or equal to 90                         |
      | Line 9: Declination must be less than or equal to 90                         |
      | Line 10: Declination must be greater than or equal to -90                    |
      | Line 11: Declination must be a number with a maximum of 6 decimal places     |
      | Line 12: Declination must be a number with a maximum of 6 decimal places     |
      | Line 13: Declination can't be blank                                          |
      | Line 13: Declination is not a number                                         |
      | Line 14: Declination is not a number                                         |
      | Line 14: Declination must be a number with a maximum of 6 decimal places     |
      | Line 15: Declination is not a number                                         |
      | Line 15: Declination must be a number with a maximum of 6 decimal places     |
      | Line 16: Declination is not a number                                         |
      | Line 16: Declination must be a number with a maximum of 6 decimal places     |

  @javascript
  Scenario Outline: I cannot submit bulk image search if form has errors (required errors)
    Given I select the "Bulk Image" tab
    And I press "Search SkyMapper"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field           | error                   |
    | File (csv)      | This field is required. |
    | Download format | This field is required. |