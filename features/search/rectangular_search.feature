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
    And I fill in "<ra_min>" for "Right ascension min (deg)"
    And I fill in "<ra_max>" for "Right ascension max (deg)"
    And I fill in "<dec_min>" for "Declination min (deg)"
    And I fill in "<dec_max>" for "Declination max (deg)"
    And I fake search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    And I should see rectangular search parameters with values ("<ra_min>", "<ra_max>", "<dec_min>", "<dec_max>")
    Then I should be on the rectangular search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see results for catalogue "<catalogue>" as "<results>" in all pages with limit "50"
  Examples:
    | survey             | catalogue | ra_min | ra_max | dec_min | dec_max | results                          | count |
    | Five-Second Survey | fs        | 1.75   | 2.25   | -2.25   | -0.75   | skymapper_rectangular_query_fs_1 | 547   |
    | Five-Second Survey | fs        | 0      | 10     | -2.25   | -0.75   | skymapper_rectangular_query_fs_3 | 1000  |
    | Main Survey        | ms        | 1.975  | 2.025  | -1.525  | -1.475  | skymapper_rectangular_query_ms_1 | 44    |
    | Main Survey        | ms        | 1.75   | 2.25   | -2.25   | -0.75   | skymapper_rectangular_query_ms_3 | 1000  |

  @javascript
  Scenario Outline: I perform rectangular search returns empty
    And I select the "Rectangular" tab
    And I select "<survey>" from "SkyMapper Survey"
    And I fill in "<ra_min>" for "Right ascension min (deg)"
    And I fill in "<ra_max>" for "Right ascension max (deg)"
    And I fill in "<dec_min>" for "Declination min (deg)"
    And I fill in "<dec_max>" for "Declination max (deg)"
    And I fake search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    And I should see rectangular search parameters with values ("<ra_min>", "<ra_max>", "<dec_min>", "<dec_max>")
    Then I should be on the rectangular search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should not see any results
  Examples:
    | survey             | catalogue | ra_min | ra_max | dec_min | dec_max | results                          | count |
    | Five-Second Survey | fs        | 1      | 2      | 1       | 2       | skymapper_rectangular_query_fs_2 | 0     |
    | Main Survey        | ms        | 1      | 2      | 1       | 2       | skymapper_rectangular_query_ms_2 | 0     |

  @javascript
  Scenario Outline: I cannot perform rectangular search if request error
    And I select the "Rectangular" tab
    And I select "<survey>" from "SkyMapper Survey"
    And I fill in "<ra_min>" for "Right ascension min (deg)"
    And I fill in "<ra_max>" for "Right ascension max (deg)"
    And I fill in "<dec_min>" for "Declination min (deg)"
    And I fill in "<dec_max>" for "Declination max (deg)"
    And I fake search request for catalogue "<catalogue>" returns error
    And I press "Search SkyMapper"
    Then I should be on the rectangular search results page
    And I should see rectangular search parameters with values ("<ra_min>", "<ra_max>", "<dec_min>", "<dec_max>")
    And I wait for "Fetching results..."
    And I should see "There was an error fetching the results."
    And I should not see any results
  Examples:
    | survey             | catalogue | ra_min | ra_max | dec_min | dec_max |
    | Five-Second Survey | fs        | 1.75   | 2.25   | -2.25   | -0.75   |
    | Main Survey        | ms        | 1.975  | 2.025  | -1.525  | -1.475  |

  @javascript
  Scenario Outline: I can submit rectangular search with the follow values
    And I select the "Rectangular" tab
    And I fill in "<value>" for "<field>"
    Then I should not see any errors for "<field>"
  Examples:
    | field                     | value     |
    | Right ascension min (deg) | 0         |
    | Right ascension min (deg) | 359.99999 |
    | Right ascension min (deg) | 123.45678 |
    | Right ascension max (deg) | 0         |
    | Right ascension max (deg) | 359.99999 |
    | Right ascension max (deg) | 123.45678 |
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
    | Right ascension min (deg) | -1       | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right ascension min (deg) | 360      | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right ascension min (deg) | 1.123456 | This field should be a number with 5 decimal places.                                     |
    | Right ascension min (deg) | 7abc     | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right ascension min (deg) | 7abc     | This field should be a number with 5 decimal places.                                     |
    | Right ascension max (deg) | -1       | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right ascension max (deg) | 360      | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right ascension max (deg) | 1.123456 | This field should be a number with 5 decimal places.                                     |
    | Right ascension max (deg) | 7abc     | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right ascension max (deg) | 7abc     | This field should be a number with 5 decimal places.                                     |
    | Declination min (deg)     | -91      | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination min (deg)     | 91       | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination min (deg)     | 1.123456 | This field should be a number with 5 decimal places.                                     |
    | Declination min (deg)     | 7abc     | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination min (deg)     | 7abc     | This field should be a number with 5 decimal places.                                     |
    | Declination max (deg)     | -91      | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination max (deg)     | 91       | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination max (deg)     | 1.123456 | This field should be a number with 5 decimal places.                                     |
    | Declination max (deg)     | 7abc     | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination max (deg)     | 7abc     | This field should be a number with 5 decimal places.                                     |

  @javascript
  Scenario Outline: max fields should display not display errors if min fields are less than or equal to
    And I select the "Rectangular" tab
    And I fill in "<min>" for "<min_field>"
    And I fill in "<max>" for "<max_field>"
    Then I should not see any errors for "<max_field>"
  Examples:
    | min_field                 | max_field                 | min       | max       |
    | Right ascension min (deg) | Right ascension max (deg) | 20        | 30        |
    | Right ascension min (deg) | Right ascension max (deg) | 20.12345  | 20.12346  |
    | Declination min (deg)     | Declination max (deg)     | -45       | -35       |
    | Declination min (deg)     | Declination max (deg)     | -45.12345 | -45.12346 |

  @javascript
  Scenario Outline: max fields should display error if min fields are greater than
    And I select the "Rectangular" tab
    And I fill in "<min>" for "<min_field>"
    And I fill in "<max>" for "<max_field>"
    Then I should see error "<error>" for "<max_field>"
  Examples:
    | min_field                 | max_field                 | min     | max  | error                                                                            |
    | Right ascension min (deg) | Right ascension max (deg) | 20      | 10   | This field should be a number greater than 20 and less than 360.                 |
    | Right ascension min (deg) | Right ascension max (deg) | 33.3    | 10.5 | This field should be a number greater than 33.3 and less than 360.               |
    | Right ascension min (deg) | Right ascension max (deg) | 0       | 0    | This field should be a number greater than 0 and less than 360.                  |
    | Declination min (deg)     | Declination max (deg)     | -45     | -50  | This field should be a number greater than -45 and less than or equal to 90.     |
    | Declination min (deg)     | Declination max (deg)     | 12.1234 | -50  | This field should be a number greater than 12.1234 and less than or equal to 90. |
    | Declination min (deg)     | Declination max (deg)     | -90     | -90  | This field should be a number greater than -90 and less than or equal to 90.     |

  @javascript
  Scenario Outline: I cannot submit rectangular search if form has errors (required errors)
    And I select the "Rectangular" tab
    And I press "Search SkyMapper"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field                     | error                   |
    | Right ascension min (deg) | This field is required. |
    | Right ascension max (deg) | This field is required. |
    | Declination min (deg)     | This field is required. |
    | Declination max (deg)     | This field is required. |

  @javascript
  Scenario: I submit perform rectangular search if form has errors (select required errors)
    And I select the "Rectangular" tab
    And I press "Search SkyMapper"
    Then I should see error "This field is required." for "SkyMapper Survey"

