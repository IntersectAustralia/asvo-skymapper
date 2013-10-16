Feature: Radial search
  In order to get radial search results
  As a user
  I want to search using point queries

  Background:
    Given I am on the home page

  @javascript
  Scenario Outline: I perform radial search
    And I select the "Radial" tab
    And I select "<survey>" from "SkyMapper Survey"
    And I fill in "<ra>" for "Right Ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search Radius (deg)"
    And I press "Search SkyMapper"
    Then I should see search table "skymapper_radial_search_1.vo"
  Examples:
    | survey             | ra       | dec      | sr  |
    | Five-Second Survey | -1.18844 | -1.18844 | 0.5 |

  @javascript
  Scenario Outline: I perform radial search
    And I select the "Radial" tab
    And I select "<survey>" from "SkyMapper Survey"
    And I fill in "<ra>" for "Right Ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search Radius (deg)"
    And I press "Search SkyMapper"
    Then I should see search table "skymapper_radial_search_2.vo"
  Examples:
    | survey      | ra        | dec      | sr  |
    | Main Survey | 178.83871 | -1.18844 | 0.5 |

  @javascript
  Scenario Outline: I can submit radial search with the follow values
    And I select the "Radial" tab
    And I fill in "<value>" for "<field>"
    Then I should not see any errors for "<field>"
  Examples:
    | field                 | value     |
    | Right Ascension (deg) | 0         |
    | Right Ascension (deg) | 359.99999 |
    | Right Ascension (deg) | 123.45678 |
    | Declination (deg)     | -90       |
    | Declination (deg)     | 90        |
    | Declination (deg)     | 12.34567  |
    | Search Radius (deg)   | 0.00001   |
    | Search Radius (deg)   | 10        |
    | Search Radius (deg)   | 1.23456   |

  @javascript
  Scenario Outline: I cannot submit radial search if form has errors
    And I select the "Radial" tab
    And I fill in "<value>" for "<field>"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field                 | value    | error                                                                                    |
    | Right Ascension (deg) | -1       | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right Ascension (deg) | 360      | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right Ascension (deg) | 1.123456 | This field should be a number with 5 decimal places.                                     |
    | Declination (deg)     | -91      | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination (deg)     | 91       | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination (deg)     | 1.123456 | This field should be a number with 5 decimal places.                                     |
    | Search Radius (deg)   | 0        | This field should be a number greater than 0 and less than or equal to 10.               |
    | Search Radius (deg)   | 11       | This field should be a number greater than 0 and less than or equal to 10.               |

  @javascript
  Scenario Outline: I cannot submit radial search if form has errors (required errors)
    And I select the "Radial" tab
    And I press "Search SkyMapper"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field                 | error                   |
    | Right Ascension (deg) | This field is required. |
    | Declination (deg)     | This field is required. |
    | Search Radius (deg)   | This field is required. |

  @javascript
  Scenario: I submit perform radial search if form has errors (select required errors)
    And I select the "Radial" tab
    And I press "Search SkyMapper"
    Then I should see error "This field is required." for "SkyMapper Survey"

