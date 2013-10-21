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
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search Radius (deg)"
    And I fake search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I should see radial search parameters with values ("<ra>", "<dec>", "<sr>")
    And I should see "Query returned <count> objects."
    #And I should see results for catalogue "<catalogue>" as "<results>" in all pages with limit "50"
  Examples:
    | survey             | catalogue | ra        | dec      | sr   | results                    | count |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | 0.5  | skymapper_point_query_fs_1 | 272   |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | 2    | skymapper_point_query_fs_3 | 1000  |
    | Main Survey        | ms        | 178.83871 | -1.18844 | 0.15 | skymapper_point_query_ms_1 | 488   |
    | Main Survey        | ms        | 178.83871 | -1.18844 | 0.5  | skymapper_point_query_ms_3 | 1000  |

  @javascript
  Scenario Outline: I perform radial search returns empty
    And I select the "Radial" tab
    And I select "<survey>" from "SkyMapper Survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search Radius (deg)"
    And I fake search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I should see radial search parameters with values ("<ra>", "<dec>", "<sr>")
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should not see any results
  Examples:
    | survey             | catalogue | ra | dec | sr | results                    | count |
    | Five-Second Survey | fs        | 1  | 1   | 1  | skymapper_point_query_fs_2 | 0     |
    | Main Survey        | ms        | 1  | 1   | 1  | skymapper_point_query_ms_2 | 0     |

  @javascript
  Scenario Outline: I cannot perform radial search if request error
    And I select the "Radial" tab
    And I select "<survey>" from "SkyMapper Survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search Radius (deg)"
    And I fake search request for catalogue "<catalogue>" returns error
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I should see radial search parameters with values ("<ra>", "<dec>", "<sr>")
    And I wait for "Fetching results..."
    And I should see "There was an error fetching the results."
    And I should not see any results
  Examples:
    | survey             | catalogue | ra        | dec      | sr  |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | 0.5 |
    | Main Survey        | ms        | 178.83871 | -1.18844 | 0.5 |

  @javascript
  Scenario Outline: I can submit radial search with the follow values
    And I select the "Radial" tab
    And I fill in "<value>" for "<field>"
    Then I should not see any errors for "<field>"
  Examples:
    | field                 | value     |
    | Right ascension (deg) | 0         |
    | Right ascension (deg) | 359.99999 |
    | Right ascension (deg) | 123.45678 |
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
    | Right ascension (deg) | -1       | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right ascension (deg) | 360      | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right ascension (deg) | 1.123456 | This field should be a number with 5 decimal places.                                     |
    | Right ascension (deg) | abc      | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right ascension (deg) | abc      | This field should be a number with 5 decimal places.                                     |
    | Declination (deg)     | -91      | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination (deg)     | 91       | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination (deg)     | 1.123456 | This field should be a number with 5 decimal places.                                     |
    | Declination (deg)     | abc      | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination (deg)     | abc      | This field should be a number with 5 decimal places.                                     |
    | Search Radius (deg)   | 0        | This field should be a number greater than 0 and less than or equal to 10.               |
    | Search Radius (deg)   | 11       | This field should be a number greater than 0 and less than or equal to 10.               |
    | Search Radius (deg)   | abc      | This field should be a number greater than 0 and less than or equal to 10.               |

  @javascript
  Scenario Outline: I cannot submit radial search if form has errors (required errors)
    And I select the "Radial" tab
    And I press "Search SkyMapper"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field                 | error                   |
    | Right ascension (deg) | This field is required. |
    | Declination (deg)     | This field is required. |
    | Search Radius (deg)   | This field is required. |

  @javascript
  Scenario: I submit perform radial search if form has errors (select required errors)
    And I select the "Radial" tab
    And I press "Search SkyMapper"
    Then I should see error "This field is required." for "SkyMapper Survey"

