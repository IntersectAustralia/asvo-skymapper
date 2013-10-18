Feature: Radial search
  In order to get radial search results
  As a user
  I want to search using point queries

  Background:
    Given I am on the home page

  @javascript
  Scenario Outline: I perform rectangular search
    And I select the "Rectangular" tab
    And I select "<survey>" from "SkyMapper Survey"
    And I fill in "<ra_min>" for "Right Ascension min (deg)"
    And I fill in "<ra_max>" for "Right Ascension max (deg)"
    And I fill in "<dec_min>" for "Declination min (deg)"
    And I fill in "<dec_max>" for "Declination max (deg)"
    And I fake search with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the rectangular search results page
    And I should see results for "<results>"
  Examples:
    | survey             | ra_min         | ra_max        | dec_min     | dec_max  | results                 |
    | Five-Second Survey | 178.83871      | 0             | 0.5         | 45       | skymapper_point_query_1 |
    | Main Survey        | 178.83871      | 20            | 0.5         | 45       | skymapper_point_query_2 |

  @javascript
  Scenario Outline: I can submit rectangular search with the follow values
    And I select the "Rectangular" tab
    And I fill in "<value>" for "<field>"
    Then I should not see any errors for "<field>"
  Examples:
    | field                     | value     |
    | Right Ascension min (deg) | 0         |
    | Right Ascension min (deg) | 359.99999 |
    | Right Ascension min (deg) | 123.45678 |
    | Right Ascension max (deg) | 0         |
    | Right Ascension max (deg) | 359.99999 |
    | Right Ascension max (deg) | 123.45678 |
    | Declination min (deg)     | -90       |
    | Declination min (deg)     | 90        |
    | Declination min (deg)     | 12.34567  |
    | Declination max (deg)     | -90       |
    | Declination max (deg)     | 90        |
    | Declination max (deg)     | 12.34567  |

  @javascript
  Scenario Outline: I cannot submit rectangular search if form has errors
    And I select the "Rectangular" tab
    And I fill in "<value>" for "<field>"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field                     | value    | error                                                                                    |
    | Right Ascension min (deg) | -1       | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right Ascension min (deg) | 360      | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right Ascension min (deg) | 1.123456 | This field should be a number with 5 decimal places.                                     |
    | Right Ascension max (deg) | -1       | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right Ascension max (deg) | 360      | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right Ascension max (deg) | 1.123456 | This field should be a number with 5 decimal places.                                     |
    | Declination min (deg)     | -91      | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination min (deg)     | 91       | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination min (deg)     | 1.123456 | This field should be a number with 5 decimal places.                                     |
    | Declination max (deg)     | -91      | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination max (deg)     | 91       | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination max (deg)     | 1.123456 | This field should be a number with 5 decimal places.                                     |

  @javascript
  Scenario: Right Ascension min greater than the Right Ascension max should display error for integers
    And I select the "Rectangular" tab
    And I fill in "20" for "Right Ascension min (deg)"
    And I fill in "10" for "Right Ascension max (deg)"
    Then I should see error "This field should be a number greater than 20 and less than 360." for "Right Ascension max (deg)"

  @javascript
  Scenario: Right Ascension min greater than the Right Ascension max should display error for decimals
    And I select the "Rectangular" tab
    And I fill in "33.33" for "Right Ascension min (deg)"
    And I fill in "10.5" for "Right Ascension max (deg)"
    Then I should see error "This field should be a number greater than 33.33 and less than 360." for "Right Ascension max (deg)"

  @javascript
  Scenario: Right Ascension max should be greater than or equal to the Right Ascension min when Right Ascension min is 0
    And I select the "Rectangular" tab
    And I fill in "0" for "Right Ascension min (deg)"
    And I fill in "-1" for "Right Ascension max (deg)"
    Then I should see error "This field should be a number greater than or equal to 0 and less than 360." for "Right Ascension max (deg)"

  @javascript
  Scenario: Declination min greater than the Declination max should display error for integers
    And I select the "Rectangular" tab
    And I fill in "-45" for "Declination min (deg)"
    And I fill in "-50" for "Declination max (deg)"
    Then I should see error "This field should be a number greater than -45 and less than or equal to 90." for "Declination max (deg)"

  @javascript
  Scenario: Declination min greater than the Declination max should display error for decimals
    And I select the "Rectangular" tab
    And I fill in "12.1234" for "Declination min (deg)"
    And I fill in "-50" for "Declination max (deg)"
    Then I should see error "This field should be a number greater than 12.1234 and less than or equal to 90." for "Declination max (deg)"

  @javascript
  Scenario: Declination max should be greater than or equal to the Declination min when Declination min is 0
    And I select the "Rectangular" tab
    And I fill in "0" for "Declination min (deg)"
    And I fill in "-91" for "Declination max (deg)"
    Then I should see error "This field should be a number greater than 0 and less than or equal to 90." for "Declination max (deg)"

  @javascript
  Scenario Outline: I cannot submit rectangular search if form has errors (required errors)
    And I select the "Rectangular" tab
    And I press "Search SkyMapper"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field                     | error                   |
    | Right Ascension min (deg) | This field is required. |
    | Right Ascension max (deg) | This field is required. |
    | Declination min (deg)     | This field is required. |
    | Declination max (deg)     | This field is required. |

  @javascript
  Scenario: I submit perform radial search if form has errors (select required errors)
    And I select the "Rectangular" tab
    And I press "Search SkyMapper"
    Then I should see error "This field is required." for "SkyMapper Survey"

