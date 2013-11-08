Feature: Bulk catalogue search
  In order to get bulk search results
  As a user
  I want to search using bulk point queries

  Background:
    Given I am on the home page

  @javascript
  Scenario Outline: I perform bulk catalogue search
    Given I select the "Bulk Catalogue" tab
    And I select "<survey>" from "SkyMapper survey"
    And I attach the file "<file>" to "File"
    And I select "<type>" from "Download format"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fake tap search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the bulk catalogue download page
  Examples:
    | survey | catalogue | file | sr | type | results |

  @javascript
  Scenario Outline: I can submit bulk catalogue search with the follow values
    Given I select the "Bulk Catalogue" tab
    And I fill in "<value>" for "<field>"
    Then I should not see any errors for "<field>"
  Examples:
    | field               | value      |
    | Search radius (deg) | 0.00000001 |
    | Search radius (deg) | 0.05000000 |
    | Search radius (deg) | 0.01234567 |

  @javascript
  Scenario Outline: I cannot submit bulk catalogue search if form has errors
    Given I select the "Bulk Catalogue" tab
    And I fill in "<value>" for "<field>"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field               | value       | error                                                                        |
    | Search radius (deg) | 0           | This field should be a number greater than 0 and less than or equal to 0.05. |
    | Search radius (deg) | 0.05000001  | This field should be a number greater than 0 and less than or equal to 0.05. |
    | Search radius (deg) | 0.012345678 | This field should be a number with 8 decimal places.                         |
    | Search radius (deg) | 0abc        | This field should be a number greater than 0 and less than or equal to 0.05. |

  @javascript
  Scenario: I cannot submit bulk catalogue search if csv file has errors
    Given I select the "Bulk Catalogue" tab
    And I select "Five-Second Survey" from "SkyMapper survey"
    And I attach the file "skymapper_bulk_catalogue_invalid_4.csv" to "File"
    And I select "CSV" from "Download format"
    And I fill in "0.05" for "Search radius (deg)"
    And I press "Search SkyMapper"
    Then I should the following list of file errors
      | error                                                           |
      | Line 7: Right ascension must be greater than or equal to 0      |
      | Line 8: Right ascension must be less than 360                   |
      | Line 9: Right ascension must be less than 360                   |
      | Line 10: Right ascension must be greater than or equal to 0     |
      | Line 11: Right ascension must be a number with 8 decimal places |
      | Line 12: Right ascension can't be blank                         |
      | Line 12: Right ascension is not a number                        |
      | Line 13: Right ascension can't be blank                         |
      | Line 13: Right ascension is not a number                        |
      | Line 14: Right ascension is not a number                        |
      | Line 14: Right ascension must be a number with 8 decimal places |
      | Line 15: Right ascension is not a number                        |
      | Line 15: Right ascension must be a number with 8 decimal places |
      | Line 16: Right ascension is not a number                        |
      | Line 16: Right ascension must be a number with 8 decimal places |
      | Line 7: Declination must be greater than or equal to -90        |
      | Line 8: Declination must be less than or equal to 90            |
      | Line 9: Declination must be less than or equal to 90            |
      | Line 10: Declination must be greater than or equal to -90       |
      | Line 11: Declination must be a number with 8 decimal places     |
      | Line 12: Declination must be a number with 8 decimal places     |
      | Line 13: Declination can't be blank                             |
      | Line 13: Declination is not a number                            |
      | Line 14: Declination is not a number                            |
      | Line 14: Declination must be a number with 8 decimal places     |
      | Line 15: Declination is not a number                            |
      | Line 15: Declination must be a number with 8 decimal places     |
      | Line 16: Declination is not a number                            |
      | Line 16: Declination must be a number with 8 decimal places     |

  @javascript
  Scenario Outline: I cannot submit radial search if form has errors (required errors)
    Given I select the "Bulk Catalogue" tab
    And I press "Search SkyMapper"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field               | error                   |
    | SkyMapper survey    | This field is required. |
    | File (csv)          | This field is required. |
    | Download format     | This field is required. |
    | Search radius (deg) | This field is required. |