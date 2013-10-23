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
    And I should see "Query returned <count> objects."
    And I should see radial search parameters with values ("<ra>", "<dec>", "<sr>")
    And I should see results for catalogue "<catalogue>" as "<results>" in all pages with limit "50"
  Examples:
    | survey             | catalogue | ra        | dec      | sr   | results                    | count |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | 0.5  | skymapper_point_query_fs_1 | 272   |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | 2    | skymapper_point_query_fs_3 | 1000  |
    | Main Survey        | ms        | 178.83871 | -1.18844 | 0.15 | skymapper_point_query_ms_1 | 488   |
    | Main Survey        | ms        | 178.83871 | -1.18844 | 0.5  | skymapper_point_query_ms_3 | 1000  |

  @javascript
  Scenario Outline: I perform radial search using filters (FS)
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
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see radial search parameters with values ("178.83871", "-1.18844", "0.5")
    And I should see search parameter "<min_filter_field>" as "<min_filter>"
    And I should see search parameter "<max_filter_field>" as "<max_filter>"
    And I should see results for catalogue "fs" as "<results>" in all pages with limit "50"
  Examples:
    | min_filter_field | max_filter_field | min_filter | max_filter | results                             | count |
    | U min            | U max            | 50         |            | skymapper_point_query_fs_u_filter_1 | 96    |
    | U min            | U max            |            | 1000       | skymapper_point_query_fs_u_filter_2 | 248   |
    | U min            | U max            | 50         | 1000       | skymapper_point_query_fs_u_filter_3 | 72    |
    | V min            | V max            | 50         |            | skymapper_point_query_fs_v_filter_1 | 96    |
    | V min            | V max            |            | 1000       | skymapper_point_query_fs_v_filter_2 | 248   |
    | V min            | V max            | 50         | 1000       | skymapper_point_query_fs_v_filter_3 | 72    |
    | G min            | G max            | 50         |            | skymapper_point_query_fs_g_filter_1 | 170   |
    | G min            | G max            |            | 1000       | skymapper_point_query_fs_g_filter_2 | 221   |
    | G min            | G max            | 50         | 1000       | skymapper_point_query_fs_g_filter_3 | 119   |
    | R min            | R max            | 50         |            | skymapper_point_query_fs_r_filter_1 | 237   |
    | R min            | R max            |            | 1000       | skymapper_point_query_fs_r_filter_2 | 202   |
    | R min            | R max            | 50         | 1000       | skymapper_point_query_fs_r_filter_3 | 167   |
    | I min            | I max            | 50         |            | skymapper_point_query_fs_i_filter_1 | 265   |
    | I min            | I max            |            | 1000       | skymapper_point_query_fs_i_filter_2 | 195   |
    | I min            | I max            | 50         | 1000       | skymapper_point_query_fs_i_filter_3 | 188   |
    | Z min            | Z max            | 50         |            | skymapper_point_query_fs_z_filter_1 | 268   |
    | Z min            | Z max            |            | 1000       | skymapper_point_query_fs_z_filter_2 | 189   |
    | Z min            | Z max            | 50         | 1000       | skymapper_point_query_fs_z_filter_3 | 185   |

  @javascript
  Scenario Outline: I perform radial search using filters (MS)
    And I select the "Radial" tab
    And I select "Main Survey" from "SkyMapper survey"
    And I fill in "178.83871" for "Right ascension (deg)"
    And I fill in "-1.18844" for "Declination (deg)"
    And I fill in "0.15" for "Search radius (deg)"
    And I fill in "<min_filter>" for "<min_filter_field>"
    And I fill in "<max_filter>" for "<max_filter_field>"
    And I fake search request for catalogue "ms" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see radial search parameters with values ("178.83871", "-1.18844", "0.15")
    And I should see search parameter "<min_filter_field>" as "<min_filter>"
    And I should see search parameter "<max_filter_field>" as "<max_filter>"
    And I should see results for catalogue "ms" as "<results>" in all pages with limit "50"
  Examples:
    | min_filter_field | max_filter_field | min_filter | max_filter | results                             | count |
    | U min            | U max            | 0.1        |            | skymapper_point_query_ms_u_filter_1 | 372   |
    | U min            | U max            |            | 1          | skymapper_point_query_ms_u_filter_2 | 365   |
    | U min            | U max            | 0.1        | 1          | skymapper_point_query_ms_u_filter_3 | 249   |
    | V min            | V max            | 0.1        |            | skymapper_point_query_ms_v_filter_1 | 372   |
    | V min            | V max            |            | 1          | skymapper_point_query_ms_v_filter_2 | 365   |
    | V min            | V max            | 0.1        | 1          | skymapper_point_query_ms_v_filter_3 | 249   |
    | G min            | G max            | 0.1        |            | skymapper_point_query_ms_g_filter_1 | 438   |
    | G min            | G max            |            | 1          | skymapper_point_query_ms_g_filter_2 | 274   |
    | G min            | G max            | 0.1        | 1          | skymapper_point_query_ms_g_filter_3 | 224   |
    | R min            | R max            | 0.1        |            | skymapper_point_query_ms_r_filter_1 | 454   |
    | R min            | R max            |            | 1          | skymapper_point_query_ms_r_filter_2 | 131   |
    | R min            | R max            | 0.1        | 1          | skymapper_point_query_ms_r_filter_3 | 97    |
    | I min            | I max            | 0.1        |            | skymapper_point_query_ms_i_filter_1 | 466   |
    | I min            | I max            |            | 1          | skymapper_point_query_ms_i_filter_2 | 70    |
    | I min            | I max            | 0.1        | 1          | skymapper_point_query_ms_i_filter_3 | 48    |
    | Z min            | Z max            | 0.1        |            | skymapper_point_query_ms_z_filter_1 | 446   |
    | Z min            | Z max            |            | 1          | skymapper_point_query_ms_z_filter_2 | 72    |
    | Z min            | Z max            | 0.1        | 1          | skymapper_point_query_ms_z_filter_3 | 30    |

  @javascript
  Scenario Outline: I perform radial search using all filters
    And I select the "Radial" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fill in "<filter_min>" for "U min"
    And I fill in "<filter_max>" for "U max"
    And I fill in "<filter_min>" for "V min"
    And I fill in "<filter_max>" for "V max"
    And I fill in "<filter_min>" for "G min"
    And I fill in "<filter_max>" for "G max"
    And I fill in "<filter_min>" for "R min"
    And I fill in "<filter_max>" for "R max"
    And I fill in "<filter_min>" for "I min"
    And I fill in "<filter_max>" for "I max"
    And I fill in "<filter_min>" for "Z min"
    And I fill in "<filter_max>" for "Z max"
    And I fake search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see radial search parameters with values ("<ra>", "<dec>", "<sr>")
    And I should see search parameter "U min" as "<filter_min>"
    And I should see search parameter "U max" as "<filter_max>"
    And I should see search parameter "V min" as "<filter_min>"
    And I should see search parameter "V max" as "<filter_max>"
    And I should see search parameter "G min" as "<filter_min>"
    And I should see search parameter "G max" as "<filter_max>"
    And I should see search parameter "R min" as "<filter_min>"
    And I should see search parameter "R max" as "<filter_max>"
    And I should see search parameter "I min" as "<filter_min>"
    And I should see search parameter "I max" as "<filter_max>"
    And I should see search parameter "Z min" as "<filter_min>"
    And I should see search parameter "Z max" as "<filter_max>"
    And I should see results for catalogue "<catalogue>" as "<results>" in all pages with limit "50"
  Examples:
    | survey             | catalogue | ra        | dec      | sr   | filter_min | filter_max | results                             | count |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | 0.5  | 50         | 1000       | skymapper_point_query_fs_filter_all | 26    |
    | Main Survey        | ms        | 178.83871 | -1.18844 | 0.15 | 0.1        | 1          | skymapper_point_query_ms_filter_all | 3     |

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
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see radial search parameters with values ("<ra>", "<dec>", "<sr>")
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
    And I wait for "Fetching results..."
    And I should see "There was an error fetching the results."
    And I should see radial search parameters with values ("<ra>", "<dec>", "<sr>")
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
    | field                 | value        |
    | Right ascension (deg) | 0            |
    | Right ascension (deg) | 359.99999999 |
    | Right ascension (deg) | 123.12345678 |
    | Declination (deg)     | -90          |
    | Declination (deg)     | 90           |
    | Declination (deg)     | 12.12345678  |
    | Search radius (deg)   | 0.00000001   |
    | Search radius (deg)   | 10           |
    | Search radius (deg)   | 1.23456      |
    | Search radius (deg)   | 1.12345678   |
    | U min                 | -100000000   |
    | U min                 | 000000000    |
    | U min                 | 1.12345678   |
    | U max                 | -100000000   |
    | U max                 | 000000000    |
    | U max                 | 1.12345678   |
    | V min                 | -100000000   |
    | V min                 | 000000000    |
    | V min                 | 1.12345678   |
    | V max                 | -100000000   |
    | V max                 | 000000000    |
    | V max                 | 1.12345678   |
    | G min                 | -100000000   |
    | G min                 | 000000000    |
    | G min                 | 1.12345678   |
    | G max                 | -100000000   |
    | G max                 | 000000000    |
    | G max                 | 1.12345678   |
    | R min                 | -100000000   |
    | R min                 | 000000000    |
    | R min                 | 1.12345678   |
    | R max                 | -100000000   |
    | R max                 | 000000000    |
    | R max                 | 1.12345678   |
    | I min                 | -100000000   |
    | I min                 | 000000000    |
    | I min                 | 1.12345678   |
    | I max                 | -100000000   |
    | I max                 | 000000000    |
    | I max                 | 1.12345678   |
    | Z min                 | -100000000   |
    | Z min                 | 000000000    |
    | Z min                 | 1.12345678   |
    | Z max                 | -100000000   |
    | Z max                 | 000000000    |
    | Z max                 | 1.12345678   |

  @javascript
  Scenario Outline: I cannot submit radial search if form has errors
    And I select the "Radial" tab
    And I fill in "<value>" for "<field>"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field                 | value       | error                                                                                    |
    | Right ascension (deg) | -1          | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right ascension (deg) | 360         | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right ascension (deg) | 1.123456789 | This field should be a number with 8 decimal places.                                     |
    | Right ascension (deg) | 7abc        | This field should be a number greater than or equal to 0 and less than 360.              |
    | Right ascension (deg) | 7abc        | This field should be a number with 8 decimal places.                                     |
    | Declination (deg)     | -91         | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination (deg)     | 91          | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination (deg)     | 1.123456789 | This field should be a number with 8 decimal places.                                     |
    | Declination (deg)     | 7abc        | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination (deg)     | 7abc        | This field should be a number with 8 decimal places.                                     |
    | Search radius (deg)   | 0           | This field should be a number greater than 0 and less than or equal to 10.               |
    | Search radius (deg)   | 11          | This field should be a number greater than 0 and less than or equal to 10.               |
    | Search radius (deg)   | 1.123456789 | This field should be a number with 8 decimal places.                                     |
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
  Scenario Outline: Max fields should not display errors if min fields are less than or not a number
    And I select the "Radial" tab
    And I fill in "<min>" for "<min_field>"
    And I fill in "<max>" for "<max_field>"
    Then I should not see any errors for "<max_field>"
  Examples:
    | min_field | max_field | min        | max        |
    | U min     | U max     | 0.12345678 | 0.12345679 |
    | U min     | U max     | 500        | 1000       |
    | U min     | U max     | -1000      | -500       |
    | U min     | U max     | 7abc       | -500       |
    | V min     | V max     | 0.12345678 | 0.12345679 |
    | V min     | V max     | 500        | 1000       |
    | V min     | V max     | -1000      | -500       |
    | V min     | V max     | 7abc       | -500       |
    | G min     | G max     | 0.12345678 | 0.12345679 |
    | G min     | G max     | 500        | 1000       |
    | G min     | G max     | -1000      | -500       |
    | G min     | G max     | 7abc       | -500       |
    | R min     | R max     | 0.12345678 | 0.12345679 |
    | R min     | R max     | 500        | 1000       |
    | R min     | R max     | -1000      | -500       |
    | R min     | R max     | 7abc       | -500       |
    | I min     | I max     | 0.12345678 | 0.12345679 |
    | I min     | I max     | 500        | 1000       |
    | I min     | I max     | -1000      | -500       |
    | I min     | I max     | 7abc       | -500       |
    | Z min     | Z max     | 0.12345678 | 0.12345679 |
    | Z min     | Z max     | 500        | 1000       |
    | Z min     | Z max     | -1000      | -500       |
    | Z min     | Z max     | 7abc       | -500       |

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
