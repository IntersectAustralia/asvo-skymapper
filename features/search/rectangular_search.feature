Feature: Rectangular search
  In order to get rectangular search results
  As a user
  I want to search using rectangle queries

  Background:
    Given I am on the home page

  @javascript
  Scenario Outline: I perform rectangular search
    And I select the "Rectangular" tab
    And I select "<survey>" from "SkyMapper Survey"
    And I fill in "<ra_min>" for "Right Ascension Min (deg)"
    And I fill in "<ra_max>" for "Right Ascension Max (deg)"
    And I fill in "<dec_min>" for "Declination Min (deg)"
    And I fill in "<dec_max>" for "Declination Max (deg)"
    And I fake search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    And I should see rectangular search parameters with values ("<ra_min>", "<ra_max>", "<dec_min>", "<dec_max>")
    Then I should be on the rectangular search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see results for catalogue "<catalogue>" as "<results>" in all pages with limit "50"
  Examples:
    | survey             | catalogue | ra_min    | ra_max | dec_min | dec_max | results                          | count |
    | Five-Second Survey | fs        | 178.83871 | 0      | 0.5     | 45      | skymapper_rectangular_query_fs_1 |       |
    | Five-Second Survey | fs        | 178.83871 | 0      | 0.5     | 45      | skymapper_rectangular_query_fs_3 | 1000  |
    | Main Survey        | ms        | 178.83871 | 20     | 0.5     | 45      | skymapper_rectangular_query_ms_1 |       |
    | Main Survey        | ms        | 178.83871 | 20     | 0.5     | 45      | skymapper_rectangular_query_ms_3 | 1000  |

  @javascript
  Scenario Outline: I perform rectangular search returns empty
    And I select the "Rectangular" tab
    And I select "<survey>" from "SkyMapper Survey"
    And I fill in "<ra_min>" for "Right Ascension Min (deg)"
    And I fill in "<ra_max>" for "Right Ascension Max (deg)"
    And I fill in "<dec_min>" for "Declination Min (deg)"
    And I fill in "<dec_max>" for "Declination Max (deg)"
    And I fake search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    And I should see rectangular search parameters with values ("<ra_min>", "<ra_max>", "<dec_min>", "<dec_max>")
    Then I should be on the rectangular search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should not see any results
  Examples:
    | survey             | catalogue | ra_min | ra_max | dec_min | dec_max | results                          | count |
    | Five-Second Survey | fs        | 1      | 1      | 1       | 1       | skymapper_rectangular_query_fs_2 | 0     |
    | Main Survey        | ms        | 1      | 1      | 1       | 1       | skymapper_rectangular_query_ms_2 | 0     |

  @javascript
  Scenario Outline: I cannot perform rectangular search if request error
    And I select the "Rectangular" tab
    And I select "<survey>" from "SkyMapper Survey"
    And I fill in "<ra_min>" for "Right Ascension Min (deg)"
    And I fill in "<ra_max>" for "Right Ascension Max (deg)"
    And I fill in "<dec_min>" for "Declination Min (deg)"
    And I fill in "<dec_max>" for "Declination Max (deg)"
    And I fake search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the rectangular search results page
    And I should see rectangular search parameters with values ("<ra_min>", "<ra_max>", "<dec_min>", "<dec_max>")
    And I wait for "Fetching results..."
    And I should see "There was an error fetching the results."
    And I should not see any results
  Examples:
    | survey             | catalogue | ra_min    | ra_max | dec_min | dec_max | results                          |
    | Five-Second Survey | fs        | 178.83871 | 0      | 0.5     | 45      | skymapper_rectangular_query_fs_1 |
    | Main Survey        | ms        | 178.83871 | 20     | 0.5     | 45      | skymapper_rectangular_query_ms_1 |

  @javascript
  Scenario Outline: I can submit rectangular search with the follow values
    And I select the "Rectangular" tab
    And I fill in "<value>" for "<field>"
    Then I should not see any errors for "<field>"
  Examples:
    | field                     | value     |
    | Right Ascension Min (deg) | 0         |
    | Right Ascension Min (deg) | 359.99999 |
    | Right Ascension Min (deg) | 123.45678 |
    | Right Ascension Max (deg) | 0         |
    | Right Ascension Max (deg) | 359.99999 |
    | Right Ascension Max (deg) | 123.45678 |
    | Declination Min (deg)     | -90       |
    | Declination Min (deg)     | 90        |
    | Declination Min (deg)     | 12.34567  |
    | Declination Max (deg)     | -90       |
    | Declination Max (deg)     | 90        |
    | Declination Max (deg)     | 12.34567  |

  @javascript
  Scenario Outline: I cannot submit rectangular search if form has errors
    And I select the "Rectangular" tab
    And I fill in "<value>" for "<field>"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field                     | value    | error                                                                                    |
    | Right Ascension Min (deg) | -1       | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right Ascension Min (deg) | 360      | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right Ascension Min (deg) | 1.123456 | This field should be a number with 5 decimal places.                                     |
    | Right Ascension Min (deg) | abc      | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right Ascension Min (deg) | abc      | This field should be a number with 5 decimal places.                                     |
    | Right Ascension Max (deg) | -1       | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right Ascension Max (deg) | 360      | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right Ascension Max (deg) | 1.123456 | This field should be a number with 5 decimal places.                                     |
    | Right Ascension Max (deg) | abc      | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right Ascension Max (deg) | abc      | This field should be a number with 5 decimal places.                                     |
    | Declination Min (deg)     | -91      | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination Min (deg)     | 91       | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination Min (deg)     | 1.123456 | This field should be a number with 5 decimal places.                                     |
    | Declination Min (deg)     | abc      | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination Min (deg)     | abc      | This field should be a number with 5 decimal places.                                     |
    | Declination Max (deg)     | -91      | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination Max (deg)     | 91       | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination Max (deg)     | 1.123456 | This field should be a number with 5 decimal places.                                     |
    | Declination Max (deg)     | abc      | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination Max (deg)     | abc      | This field should be a number with 5 decimal places.                                     |

  @javascript
  Scenario Outline: Max fields should display error if min fields are greater than
    And I select the "Rectangular" tab
    And I fill in "<min>" for "<min_field>"
    And I fill in "<max>" for "<max_field>"
    Then I should see error "<error>" for "<max_field>"
  Examples:
    | min_field                 | max_field                 | min     | max  | error                                                                                        |
    | Right Ascension Min (deg) | Right Ascension Max (deg) | 20      | 10   | This field should be a number greater than or equal to 20 and less than 360.                 |
    | Right Ascension Min (deg) | Right Ascension Max (deg) | 33.3    | 10.5 | This field should be a number greater than or equal to 33.3 and less than 360.               |
    | Right Ascension Min (deg) | Right Ascension Max (deg) | 0       | -1   | This field should be a number greater than or equal to 0 and less than 360.                  |
    | Declination Min (deg)     | Declination Max (deg)     | -45     | -50  | This field should be a number greater than or equal to -45 and less than or equal to 90.     |
    | Declination Min (deg)     | Declination Max (deg)     | 12.1234 | -50  | This field should be a number greater than or equal to 12.1234 and less than or equal to 90. |
    | Declination Min (deg)     | Declination Max (deg)     | 0       | -91  | This field should be a number greater than or equal to 0 and less than or equal to 90.       |

  @javascript
  Scenario Outline: I cannot submit rectangular search if form has errors (required errors)
    And I select the "Rectangular" tab
    And I press "Search SkyMapper"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field                     | error                   |
    | Right Ascension Min (deg) | This field is required. |
    | Right Ascension Max (deg) | This field is required. |
    | Declination Min (deg)     | This field is required. |
    | Declination Max (deg)     | This field is required. |

  @javascript
  Scenario: I submit perform rectangular search if form has errors (select required errors)
    And I select the "Rectangular" tab
    And I press "Search SkyMapper"
    Then I should see error "This field is required." for "SkyMapper Survey"

