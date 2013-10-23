Feature: Radial search
  In order to get radial search results
  As a user
  I want to search using point queries

  Background:
    Given I am on the home page

  @javascript
  Scenario Outline: I perform radial search
    And I select the "Radial" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fake search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I wait for "Fetching results..."
    And I should see radial search parameters with values ("<ra>", "<dec>", "<sr>")
    And I should see "Query returned <count> objects."
    And I should see results for catalogue "<catalogue>" as "<results>" in all pages with limit "50"
  Examples:
    | survey             | catalogue | ra        | dec      | sr   | results                    | count |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | 0.5  | skymapper_point_query_fs_1 | 272   |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | 2    | skymapper_point_query_fs_3 | 1000  |
    | Main Survey        | ms        | 178.83871 | -1.18844 | 0.15 | skymapper_point_query_ms_1 | 488   |
    | Main Survey        | ms        | 178.83871 | -1.18844 | 0.5  | skymapper_point_query_ms_3 | 1000  |

  @javascript
  Scenario Outline: I perform radial search using filters
    And I select the "Radial" tab
    And I select "Five-Second Survey" from "SkyMapper survey"
    And I fill in "178.83871" for "Right ascension (deg)"
    And I fill in "-1.18844" for "Declination (deg)"
    And I fill in "0.5" for "Search radius (deg)"
    And I fill in "<min_filter>" for "<min_filter_field>"
    And I fill in "<max_filter>" for "<max_filter_field>"
    And I fake search request for catalogue "fs" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I should see radial search parameters with values ("178.83871", "-1.18844", "0.5")
    And I should see search parameter "<min_filter_field>" as "<min_filter>"
    And I should see search parameter "<max_filter_field>" as "<max_filter>"
    And I should see "Query returned <count> objects."
    And I should see results for catalogue "fs" as "<results>" in all pages with limit "50"
  Examples:
    | min_filter_field | max_filter_field | min_filter | max_filter | results                          | count |
    | U min            | U max            | 50         |            | skymapper_point_query_u_filter_1 | 96    |
    | U min            | U max            |            | 1000       | skymapper_point_query_u_filter_2 | 248   |
    | U min            | U max            | 50         | 1000       | skymapper_point_query_u_filter_3 | 72    |
    | V min            | V max            | 50         |            | skymapper_point_query_v_filter_1 | 96    |
    | V min            | V max            |            | 1000       | skymapper_point_query_v_filter_2 | 248   |
    | V min            | V max            | 50         | 1000       | skymapper_point_query_v_filter_3 | 72    |
    | G min            | G max            | 50         |            | skymapper_point_query_g_filter_1 | 170   |
    | G min            | G max            |            | 1000       | skymapper_point_query_g_filter_2 | 221   |
    | G min            | G max            | 50         | 1000       | skymapper_point_query_g_filter_3 | 119   |
    | R min            | R max            | 50         |            | skymapper_point_query_r_filter_1 | 237   |
    | R min            | R max            |            | 1000       | skymapper_point_query_r_filter_2 | 202   |
    | R min            | R max            | 50         | 1000       | skymapper_point_query_r_filter_3 | 167   |
    | I min            | I max            | 50         |            | skymapper_point_query_i_filter_1 | 265   |
    | I min            | I max            |            | 1000       | skymapper_point_query_i_filter_2 | 195   |
    | I min            | I max            | 50         | 1000       | skymapper_point_query_i_filter_3 | 188   |
    | Z min            | Z max            | 50         |            | skymapper_point_query_Z_filter_1 | 268   |
    | Z min            | Z max            |            | 1000       | skymapper_point_query_Z_filter_2 | 189   |
    | Z min            | Z max            | 50         | 1000       | skymapper_point_query_Z_filter_3 | 185   |

  @javascript
  Scenario Outline: I perform radial search returns empty
    And I select the "Radial" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
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
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
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
    | field                 | value      |
    | Right ascension (deg) | 0          |
    | Right ascension (deg) | 359.99999  |
    | Right ascension (deg) | 123.45678  |
    | Declination (deg)     | -90        |
    | Declination (deg)     | 90         |
    | Declination (deg)     | 12.34567   |
    | Search radius (deg)   | 0.00001    |
    | Search radius (deg)   | 10         |
    | Search radius (deg)   | 1.23456    |
    | U min                 | -100000000 |
    | U min                 | 000000000  |
    | U min                 | 1.23456789 |
    | U max                 | -100000000 |
    | U max                 | 000000000  |
    | U max                 | 1.23456789 |
    | V min                 | -100000000 |
    | V min                 | 000000000  |
    | V min                 | 1.23456789 |
    | V max                 | -100000000 |
    | V max                 | 000000000  |
    | V max                 | 1.23456789 |
    | G min                 | -100000000 |
    | G min                 | 000000000  |
    | G min                 | 1.23456789 |
    | G max                 | -100000000 |
    | G max                 | 000000000  |
    | G max                 | 1.23456789 |
    | R min                 | -100000000 |
    | R min                 | 000000000  |
    | R min                 | 1.23456789 |
    | R max                 | -100000000 |
    | R max                 | 000000000  |
    | R max                 | 1.23456789 |
    | I min                 | -100000000 |
    | I min                 | 000000000  |
    | I min                 | 1.23456789 |
    | I max                 | -100000000 |
    | I max                 | 000000000  |
    | I max                 | 1.23456789 |
    | Z min                 | -100000000 |
    | Z min                 | 000000000  |
    | Z min                 | 1.23456789 |
    | Z max                 | -100000000 |
    | Z max                 | 000000000  |
    | Z max                 | 1.23456789 |

  @javascript
  Scenario Outline: I cannot submit radial search if form has errors
    And I select the "Radial" tab
    And I fill in "<value>" for "<field>"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field                 | value       | error                                                                                    |
    | Right ascension (deg) | -1          | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right ascension (deg) | 360         | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right ascension (deg) | 1.123456    | This field should be a number with 5 decimal places.                                     |
    | Right ascension (deg) | 7abc        | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right ascension (deg) | 7abc        | This field should be a number with 5 decimal places.                                     |
    | Declination (deg)     | -91         | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination (deg)     | 91          | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination (deg)     | 1.123456    | This field should be a number with 5 decimal places.                                     |
    | Declination (deg)     | 7abc        | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination (deg)     | 7abc        | This field should be a number with 5 decimal places.                                     |
    | Search radius (deg)   | 0           | This field should be a number greater than 0 and less than or equal to 10.               |
    | Search radius (deg)   | 11          | This field should be a number greater than 0 and less than or equal to 10.               |
    | Search radius (deg)   | 7abc        | This field should be a number greater than 0 and less than or equal to 10.               |
    | U min                 | 1.123456789 | This field should be a number with 8 decimal places.                                     |
    | U min                 | 7abc        | This field should be a number with 8 decimal places.                                     |
    | U max                 | 1.123456789 | This field should be a number with 8 decimal places.                                     |
    | U max                 | 7abc        | This field should be a number with 8 decimal places.                                     |
    | V min                 | 1.123456789 | This field should be a number with 8 decimal places.                                     |
    | V min                 | 7abc        | This field should be a number with 8 decimal places.                                     |
    | V max                 | 1.123456789 | This field should be a number with 8 decimal places.                                     |
    | V max                 | 7abc        | This field should be a number with 8 decimal places.                                     |
    | G min                 | 1.123456789 | This field should be a number with 8 decimal places.                                     |
    | G min                 | 7abc        | This field should be a number with 8 decimal places.                                     |
    | G max                 | 1.123456789 | This field should be a number with 8 decimal places.                                     |
    | G max                 | 7abc        | This field should be a number with 8 decimal places.                                     |
    | R min                 | 1.123456789 | This field should be a number with 8 decimal places.                                     |
    | R min                 | 7abc        | This field should be a number with 8 decimal places.                                     |
    | R max                 | 1.123456789 | This field should be a number with 8 decimal places.                                     |
    | R max                 | 7abc        | This field should be a number with 8 decimal places.                                     |
    | I min                 | 1.123456789 | This field should be a number with 8 decimal places.                                     |
    | I min                 | 7abc        | This field should be a number with 8 decimal places.                                     |
    | I max                 | 1.123456789 | This field should be a number with 8 decimal places.                                     |
    | I max                 | 7abc        | This field should be a number with 8 decimal places.                                     |
    | Z min                 | 1.123456789 | This field should be a number with 8 decimal places.                                     |
    | Z min                 | 7abc        | This field should be a number with 8 decimal places.                                     |
    | Z max                 | 1.123456789 | This field should be a number with 8 decimal places.                                     |
    | Z max                 | 7abc        | This field should be a number with 8 decimal places.                                     |

  @javascript
  Scenario Outline: Max fields should display not display errors if min fields are less than
    And I select the "Radial" tab
    And I fill in "<min>" for "<min_field>"
    And I fill in "<max>" for "<max_field>"
    Then I should not see any errors for "<max_field>"
  Examples:
    | min_field | max_field | min        | max        |
    | U min     | U max     | 0.12345678 | 0.12345679 |
    | U min     | U max     | 500        | 1000       |
    | U min     | U max     | -1000      | -500       |
    | V min     | V max     | 0.12345678 | 0.12345679 |
    | V min     | V max     | 500        | 1000       |
    | V min     | V max     | -1000      | -500       |
    | G min     | G max     | 0.12345678 | 0.12345679 |
    | G min     | G max     | 500        | 1000       |
    | G min     | G max     | -1000      | -500       |
    | R min     | R max     | 0.12345678 | 0.12345679 |
    | R min     | R max     | 500        | 1000       |
    | R min     | R max     | -1000      | -500       |
    | I min     | I max     | 0.12345678 | 0.12345679 |
    | I min     | I max     | 500        | 1000       |
    | I min     | I max     | -1000      | -500       |
    | Z min     | Z max     | 0.12345678 | 0.12345679 |
    | Z min     | Z max     | 500        | 1000       |
    | Z min     | Z max     | -1000      | -500       |

  @javascript
  Scenario Outline: Max fields should display error if min fields are greater than or equal to
    And I select the "Radial" tab
    And I fill in "<min>" for "<min_field>"
    And I fill in "<max>" for "<max_field>"
    Then I should see error "<error>" for "<max_field>"
  Examples:
    | min_field | max_field | min        | max            | error                                                  |
    | U min     | U max     | 0          | 0              | This field should be a number greater than 0.          |
    | U min     | U max     | 0.12345678 | 0.012345678    | This field should be a number greater than 0.12345678. |
    | U min     | U max     | 1000       | 999.99999999   | This field should be a number greater than 1000.       |
    | U min     | U max     | -1000      | -1000.00000001 | This field should be a number greater than -1000.      |
    | V min     | V max     | 0          | 0              | This field should be a number greater than 0.          |
    | V min     | V max     | 0.12345678 | 0.012345678    | This field should be a number greater than 0.12345678. |
    | V min     | V max     | 1000       | 999.99999999   | This field should be a number greater than 1000.       |
    | V min     | V max     | -1000      | -1000.00000001 | This field should be a number greater than -1000.      |
    | G min     | G max     | 0          | 0              | This field should be a number greater than 0.          |
    | G min     | G max     | 0.12345678 | 0.012345678    | This field should be a number greater than 0.12345678. |
    | G min     | G max     | 1000       | 999.99999999   | This field should be a number greater than 1000.       |
    | G min     | G max     | -1000      | -1000.00000001 | This field should be a number greater than -1000.      |
    | R min     | R max     | 0          | 0              | This field should be a number greater than 0.          |
    | R min     | R max     | 0.12345678 | 0.012345678    | This field should be a number greater than 0.12345678. |
    | R min     | R max     | 1000       | 999.99999999   | This field should be a number greater than 1000.       |
    | R min     | R max     | -1000      | -1000.00000001 | This field should be a number greater than -1000.      |
    | I min     | I max     | 0          | 0              | This field should be a number greater than 0.          |
    | I min     | I max     | 0.12345678 | 0.012345678    | This field should be a number greater than 0.12345678. |
    | I min     | I max     | 1000       | 999.99999999   | This field should be a number greater than 1000.       |
    | I min     | I max     | -1000      | -1000.00000001 | This field should be a number greater than -1000.      |
    | Z min     | Z max     | 0          | 0              | This field should be a number greater than 0.          |
    | Z min     | Z max     | 0.12345678 | 0.012345678    | This field should be a number greater than 0.12345678. |
    | Z min     | Z max     | 1000       | 999.99999999   | This field should be a number greater than 1000.       |
    | Z min     | Z max     | -1000      | -1000.00000001 | This field should be a number greater than -1000.      |

  @javascript
  Scenario Outline: I cannot submit radial search if form has errors (required errors)
    And I select the "Radial" tab
    And I press "Search SkyMapper"
    And I fill in "" for "<field>"
    And I press "Search SkyMapper"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field                 | error                   |
    | Right ascension (deg) | This field is required. |
    | Declination (deg)     | This field is required. |
#| Search radius (deg)   | This field is required. |

  @javascript
  Scenario: I submit perform radial search if form has errors (select required errors)
    And I select the "Radial" tab
    And I press "Search SkyMapper"
    Then I should see error "This field is required." for "SkyMapper survey"
