Feature: Bulk raw image search
  In order to get bulk raw image search results
  As a user
  I want to search using bulk image queries

  Background:
    Given I am on the home page

  @javascript
  @not-jenkins
  Scenario Outline: I perform bulk image search
    Given I select the "Bulk Image" tab
    Then I should see link "example"
    And I attach the file "<file>" to "File"
    And I press "Search SkyMapper"
    Then I should be on the bulk image search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see results for catalogue "<catalogue>" as "<results>" in all pages with limit "50"
    And I should see raw image results as "<results>" in all pages with limit "50" in proper order
    Then I follow "Back"
    And I should see the "Bulk Image" tab
  Examples:
    | catalogue | file                       | results                      | count |
    | image     | skymapper_bulk_valid_4.csv | skymapper_bulk_image_query_1 | 72    |

  @javascript
  Scenario: I cannot submit bulk image search if csv file has errors
    Given I select the "Bulk Image" tab
    And I attach the file "skymapper_bulk_invalid_4.csv" to "File"
    And I press "Search SkyMapper"
    Then I should the following list of file errors
      | error                                                                                                           |
      | Line 7: Right ascension should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD.  |
      | Line 7: Declination must be greater than or equal to -90 and less then or equal to 90.                          |
      | Line 8: Right ascension must be greater than or equal to 0 and less then 360.                                   |
      | Line 8: Declination must be greater than or equal to -90 and less then or equal to 90.                          |
      | Line 9: Right ascension must be greater than or equal to 0 and less then 360.                                   |
      | Line 9: Declination must be greater than or equal to -90 and less then or equal to 90.                          |
      | Line 10: Right ascension should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD. |
      | Line 10: Declination must be greater than or equal to -90 and less then or equal to 90.                         |
      | Line 11: Right ascension should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD. |
      | Line 11: Declination should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD.     |
      | Line 12: Right ascension can't be blank                                                                         |
      | Line 12: Declination should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD.     |
      | Line 13: Right ascension can't be blank                                                                         |
      | Line 13: Declination can't be blank                                                                             |
      | Line 14: Right ascension should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD. |
      | Line 14: Declination should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD.     |
      | Line 15: Right ascension should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD. |
      | Line 15: Declination should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD.     |
      | Line 16: Right ascension should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD. |
      | Line 16: Declination should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD.     |

  @javascript
  Scenario Outline: I cannot submit bulk image search if form has errors (required errors)
    Given I select the "Bulk Image" tab
    And I press "Search SkyMapper"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field           | error                   |
    | File (csv)      | This field is required. |


  @javascript
  Scenario Outline: I perform bulk image search
    Given I select the "Bulk Image" tab
    Then I should see link "example"
    And I attach the file "<file>" to "File"
    And I press "Search SkyMapper"
    Then I should be on the bulk image search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see results for catalogue "<catalogue>" as "<results>" in all pages with limit "50"
    And I should see raw image results as "<results>" in all pages with limit "50" in proper order
    When I click on element with css "a.image-link"
    And I pause for 1 seconds
    Then I should see "You are about to download an image that is approximately 512MB."
  Examples:
    | catalogue | file                       | results                      | count |
    | image     | skymapper_bulk_valid_4.csv | skymapper_bulk_image_query_1 | 72    |

