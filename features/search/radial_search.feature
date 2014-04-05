Feature: Radial search
  In order to get radial search results
  As a user
  I want to search using point queries

  Background:
    Given I am on the home page

  @javascript
  Scenario Outline: I perform radial search
    Given I select the "Radial" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fake tap search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see radial search parameters with values ("<ra>", "<dec>", "<sr>")
    And I should see results for catalogue "<catalogue>" as "<results>" in all pages with limit "50"
    Then I follow "Back"
    And I should see the "Radial" tab
    And I should see search field "SkyMapper survey" with value "<catalogue>"
    And I should see search field "Right ascension (deg)" with value "<ra>"
    And I should see search field "Declination (deg)" with value "<dec>"
    And I should see search field "Search radius (deg)" with value "<sr>"
  Examples:
    | survey             | catalogue | ra        | dec      | sr   | results                    | count |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | 0.5  | skymapper_point_query_fs_1 | 272   |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | 2    | skymapper_point_query_fs_3 | 1000  |
    | Main Survey        | ms        | 178.83871 | -1.18844 | 0.15 | skymapper_point_query_ms_1 | 488   |
    | Main Survey        | ms        | 178.83871 | -1.18844 | 0.5  | skymapper_point_query_ms_3 | 1000  |

  @javascript
  Scenario Outline: I perform radial search using filters (FS)
    Given I select the "Radial" tab
    And I select "Five-Second Survey" from "SkyMapper survey"
    And I fill in "178.83871" for "Right ascension (deg)"
    And I fill in "-1.18844" for "Declination (deg)"
    And I fill in "0.5" for "Search radius (deg)"
    And I fill in "<min_filter>" for "<min_filter_field>"
    And I fill in "<max_filter>" for "<max_filter_field>"
    And I fake tap search request for catalogue "fs" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see radial search parameters with values ("178.83871", "-1.18844", "0.5")
    And I should see search parameter "<min_filter_field>" as "<min_filter>"
    And I should see search parameter "<max_filter_field>" as "<max_filter>"
    And I should see results for catalogue "fs" as "<results>" in all pages with limit "50"
    Then I follow "Back"
    And I should see the "Radial" tab
    And I should see search field "SkyMapper survey" with value "fs"
    And I should see search field "Right ascension (deg)" with value "178.83871"
    And I should see search field "Declination (deg)" with value "-1.18844"
    And I should see search field "Search radius (deg)" with value "0.5"
    And I should see search field "<min_filter_field>" with value "<min_filter>"
    And I should see search field "<max_filter_field>" with value "<max_filter>"
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
    Given I select the "Radial" tab
    And I select "Main Survey" from "SkyMapper survey"
    And I fill in "178.83871" for "Right ascension (deg)"
    And I fill in "-1.18844" for "Declination (deg)"
    And I fill in "0.15" for "Search radius (deg)"
    And I fill in "<min_filter>" for "<min_filter_field>"
    And I fill in "<max_filter>" for "<max_filter_field>"
    And I fake tap search request for catalogue "ms" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see radial search parameters with values ("178.83871", "-1.18844", "0.15")
    And I should see search parameter "<min_filter_field>" as "<min_filter>"
    And I should see search parameter "<max_filter_field>" as "<max_filter>"
    And I should see results for catalogue "ms" as "<results>" in all pages with limit "50"
    Then I follow "Back"
    And I should see the "Radial" tab
    And I should see search field "SkyMapper survey" with value "ms"
    And I should see search field "Right ascension (deg)" with value "178.83871"
    And I should see search field "Declination (deg)" with value "-1.18844"
    And I should see search field "Search radius (deg)" with value "0.15"
    And I should see search field "<min_filter_field>" with value "<min_filter>"
    And I should see search field "<max_filter_field>" with value "<max_filter>"
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
  Scenario Outline: I perform radial search should allow spaces in filters
    Given I select the "Radial" tab
    And I select "Five-Second Survey" from "SkyMapper survey"
    And I fill in "178.83871" for "Right ascension (deg)"
    And I fill in "-1.18844" for "Declination (deg)"
    And I fill in "0.5" for "Search radius (deg)"
    And I fill in "<min_filter>" for "<min_filter_field>"
    And I fill in "<max_filter>" for "<max_filter_field>"
    And I fake tap search request for catalogue "fs" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see radial search parameters with values ("178.83871", "-1.18844", "0.5")
    And I should see search parameter "<min_filter_field>" as "<clean_min_filter>"
    And I should see search parameter "<max_filter_field>" as "<clean_max_fitler>"
    And I should see results for catalogue "fs" as "<results>" in all pages with limit "50"
    Then I follow "Back"
    And I should see the "Radial" tab
    And I should see search field "SkyMapper survey" with value "fs"
    And I should see search field "Right ascension (deg)" with value "178.83871"
    And I should see search field "Declination (deg)" with value "-1.18844"
    And I should see search field "Search radius (deg)" with value "0.5"
    And I should see search field "<min_filter_field>" with value "<min_filter>"
    And I should see search field "<max_filter_field>" with value "<max_filter>"
  Examples:
    | min_filter_field | max_filter_field | min_filter | max_filter | results                             | count | clean_min_filter | clean_max_fitler |
    | U min            | U max            | 5 0        |            | skymapper_point_query_fs_u_filter_1 | 96    | 50               |                  |
    | U min            | U max            |            | 1 00 0     | skymapper_point_query_fs_u_filter_2 | 248   |                  | 1000             |
    | U min            | U max            | 5   0      | 10   00    | skymapper_point_query_fs_u_filter_3 | 72    | 50               | 1000             |

  @javascript
  Scenario Outline: I perform radial search using all filters
    Given I select the "Radial" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fill in "<min_filter>" for "U min"
    And I fill in "<max_filter>" for "U max"
    And I fill in "<min_filter>" for "V min"
    And I fill in "<max_filter>" for "V max"
    And I fill in "<min_filter>" for "G min"
    And I fill in "<max_filter>" for "G max"
    And I fill in "<min_filter>" for "R min"
    And I fill in "<max_filter>" for "R max"
    And I fill in "<min_filter>" for "I min"
    And I fill in "<max_filter>" for "I max"
    And I fill in "<min_filter>" for "Z min"
    And I fill in "<max_filter>" for "Z max"
    And I fake tap search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see radial search parameters with values ("<ra>", "<dec>", "<sr>")
    And I should see search parameter "U min" as "<min_filter>"
    And I should see search parameter "U max" as "<max_filter>"
    And I should see search parameter "V min" as "<min_filter>"
    And I should see search parameter "V max" as "<max_filter>"
    And I should see search parameter "G min" as "<min_filter>"
    And I should see search parameter "G max" as "<max_filter>"
    And I should see search parameter "R min" as "<min_filter>"
    And I should see search parameter "R max" as "<max_filter>"
    And I should see search parameter "I min" as "<min_filter>"
    And I should see search parameter "I max" as "<max_filter>"
    And I should see search parameter "Z min" as "<min_filter>"
    And I should see search parameter "Z max" as "<max_filter>"
    And I should see results for catalogue "<catalogue>" as "<results>" in all pages with limit "50"
    Then I follow "Back"
    And I should see the "Radial" tab
    And I should see search field "SkyMapper survey" with value "<catalogue>"
    And I should see search field "Right ascension (deg)" with value "<ra>"
    And I should see search field "Declination (deg)" with value "<dec>"
    And I should see search field "Search radius (deg)" with value "<sr>"
    And I should see search field "U min" with value "<min_filter>"
    And I should see search field "U max" with value "<max_filter>"
    And I should see search field "V min" with value "<min_filter>"
    And I should see search field "V max" with value "<max_filter>"
    And I should see search field "G min" with value "<min_filter>"
    And I should see search field "G max" with value "<max_filter>"
    And I should see search field "R min" with value "<min_filter>"
    And I should see search field "R max" with value "<max_filter>"
    And I should see search field "I min" with value "<min_filter>"
    And I should see search field "I max" with value "<max_filter>"
    And I should see search field "Z min" with value "<min_filter>"
    And I should see search field "Z max" with value "<max_filter>"
  Examples:
    | survey             | catalogue | ra        | dec      | sr   | min_filter | max_filter | results                             | count |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | 0.5  | 50         | 1000       | skymapper_point_query_fs_filter_all | 26    |
    | Main Survey        | ms        | 178.83871 | -1.18844 | 0.15 | 0.1        | 1          | skymapper_point_query_ms_filter_all | 3     |

  @javascript
  Scenario Outline: I perform radial search returns empty
    Given I select the "Radial" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fake tap search request for catalogue "<catalogue>" with "<results>"
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
    Given I select the "Radial" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fake tap search request for catalogue "<catalogue>" returns error
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
    Given I select the "Radial" tab
    And I fill in "<value>" for "<field>"
    Then I should not see any errors for "<field>"
  Examples:
    | field                 | value      |
    | Right ascension (deg) | 0          |
    | Right ascension (deg) | 359.999999 |
    | Right ascension (deg) | 00:00:00   |
    | Right ascension (deg) | 23:59:59   |
    | Right ascension (deg) | 00 00 00   |
    | Right ascension (deg) | 23 59 59   |
    | Right ascension (deg) | 359.999999 |
    | Right ascension (deg) | 123.123456 |
    | Declination (deg)     | -90        |
    | Declination (deg)     | 90         |
    | Declination (deg)     | -90:00:00  |
    | Declination (deg)     | 01:00:00   |
    | Declination (deg)     | 01 00 00   |
    | Declination (deg)     | 90:00:00   |
    | Declination (deg)     | 12.123456  |
    | Search radius (deg)   | 0.000001   |
    | Search radius (deg)   | 10         |
    | Search radius (deg)   | 1.23456    |
    | Search radius (deg)   | 1.123456   |
    | U min                 | -100000000 |
    | U min                 | 000000000  |
    | U min                 | 1.123      |
    | U max                 | -100000000 |
    | U max                 | 000000000  |
    | U max                 | 1.123      |
    | V min                 | -100000000 |
    | V min                 | 000000000  |
    | V min                 | 1.123      |
    | V max                 | -100000000 |
    | V max                 | 000000000  |
    | V max                 | 1.123      |
    | G min                 | -100000000 |
    | G min                 | 000000000  |
    | G min                 | 1.123      |
    | G max                 | -100000000 |
    | G max                 | 000000000  |
    | G max                 | 1.123      |
    | R min                 | -100000000 |
    | R min                 | 000000000  |
    | R min                 | 1.123      |
    | R max                 | -100000000 |
    | R max                 | 000000000  |
    | R max                 | 1.123      |
    | I min                 | -100000000 |
    | I min                 | 000000000  |
    | I min                 | 1.123      |
    | I max                 | -100000000 |
    | I max                 | 000000000  |
    | I max                 | 1.123      |
    | Z min                 | -100000000 |
    | Z min                 | 000000000  |
    | Z min                 | 1.123      |
    | Z max                 | -100000000 |
    | Z max                 | 000000000  |
    | Z max                 | 1.123      |

  @javascript
  Scenario Outline: I cannot submit radial search if form has errors
    Given I select the "Radial" tab
    And I fill in "<value>" for "<field>"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field                 | value       | error                                                                                             |
    | Right ascension (deg) | -1          | This field should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD. |
    | Right ascension (deg) | 360         | Value in degrees should be a number greater than or equal to 0 and less than or equal to 360.     |
    | Right ascension (deg) | 1.123456789 | This field should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD. |
    | Right ascension (deg) | 7abc        | This field should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD. |
    | Right ascension (deg) | 7abc        | This field should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD. |
    | Declination (deg)     | -91         | Value in degrees should be a number greater than or equal to -90 and less than or equal to 90.    |
    | Declination (deg)     | -91:00:00   | Value in degrees should be a number greater than or equal to -90 and less than or equal to 90.    |
    | Declination (deg)     | 91          | Value in degrees should be a number greater than or equal to -90 and less than or equal to 90.    |
    | Declination (deg)     | 91:00:00    | Value in degrees should be a number greater than or equal to -90 and less than or equal to 90.    |
    | Declination (deg)     | 1.123456789 | This field should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD. |
    | Declination (deg)     | 7abc        | This field should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD. |
    | Declination (deg)     | 7abc        | This field should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD. |
    | Search radius (deg)   | 0           | This field should be a number greater than 0 and less than or equal to 10.               |
    | Search radius (deg)   | 11          | This field should be a number greater than 0 and less than or equal to 10.               |
    | Search radius (deg)   | 1.123456789 | This field should be a number with a maximum of 6 decimal places.                        |
    | Search radius (deg)   | 7abc        | This field should be a number greater than 0 and less than or equal to 10.               |
    | U min                 | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                        |
    | U min                 | 7abc        | This field should be a number with a maximum of 3 decimal places.                        |
    | U max                 | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                        |
    | U max                 | 7abc        | This field should be a number with a maximum of 3 decimal places.                        |
    | V min                 | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                        |
    | V min                 | 7abc        | This field should be a number with a maximum of 3 decimal places.                        |
    | V max                 | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                        |
    | V max                 | 7abc        | This field should be a number with a maximum of 3 decimal places.                        |
    | G min                 | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                        |
    | G min                 | 7abc        | This field should be a number with a maximum of 3 decimal places.                        |
    | G max                 | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                        |
    | G max                 | 7abc        | This field should be a number with a maximum of 3 decimal places.                        |
    | R min                 | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                        |
    | R min                 | 7abc        | This field should be a number with a maximum of 3 decimal places.                        |
    | R max                 | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                        |
    | R max                 | 7abc        | This field should be a number with a maximum of 3 decimal places.                        |
    | I min                 | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                        |
    | I min                 | 7abc        | This field should be a number with a maximum of 3 decimal places.                        |
    | I max                 | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                        |
    | I max                 | 7abc        | This field should be a number with a maximum of 3 decimal places.                        |
    | Z min                 | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                        |
    | Z min                 | 7abc        | This field should be a number with a maximum of 3 decimal places.                        |
    | Z max                 | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                        |
    | Z max                 | 7abc        | This field should be a number with a maximum of 3 decimal places.                        |

  @javascript
  Scenario Outline: Max fields should not display errors if min fields are less than or not a number
    Given I select the "Radial" tab
    And I fill in "<min>" for "<min_field>"
    And I fill in "<max>" for "<max_field>"
    Then I should not see any errors for "<max_field>"
  Examples:
    | min_field | max_field | min   | max   |
    | U min     | U max     | 0.123 | 0.124 |
    | U min     | U max     | 500   | 1000  |
    | U min     | U max     | -1000 | -500  |
    | U min     | U max     | 7abc  | -500  |
    | V min     | V max     | 0.123 | 0.124 |
    | V min     | V max     | 500   | 1000  |
    | V min     | V max     | -1000 | -500  |
    | V min     | V max     | 7abc  | -500  |
    | G min     | G max     | 0.123 | 0.124 |
    | G min     | G max     | 500   | 1000  |
    | G min     | G max     | -1000 | -500  |
    | G min     | G max     | 7abc  | -500  |
    | R min     | R max     | 0.123 | 0.124 |
    | R min     | R max     | 500   | 1000  |
    | R min     | R max     | -1000 | -500  |
    | R min     | R max     | 7abc  | -500  |
    | I min     | I max     | 0.123 | 0.124 |
    | I min     | I max     | 500   | 1000  |
    | I min     | I max     | -1000 | -500  |
    | I min     | I max     | 7abc  | -500  |
    | Z min     | Z max     | 0.123 | 0.124 |
    | Z min     | Z max     | 500   | 1000  |
    | Z min     | Z max     | -1000 | -500  |
    | Z min     | Z max     | 7abc  | -500  |

  @javascript
  Scenario Outline: Max fields should display error if min fields are greater than or equal to
    Given I select the "Radial" tab
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
    Given I select the "Radial" tab
    And I press "Search SkyMapper"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field                 | error                   |
    | SkyMapper survey      | This field is required. |
    | Right ascension (deg) | This field is required. |
    | Declination (deg)     | This field is required. |
#| Search radius (deg)   | This field is required. |

  @javascript
  Scenario Outline: I can see radial search object details
    Given I select the "Radial" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fake tap search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see radial search parameters with values ("<ra>", "<dec>", "<sr>")
    And I should see results for catalogue "<catalogue>" as "<results>" in all pages with limit "50"
    And I click on the object in row "<row>"
    Then I should see details for the object in row "<row>" with results "<results>"
  Examples:
    | survey             | catalogue | ra        | dec      | sr   | results                    | count | row |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | 0.5  | skymapper_point_query_fs_1 | 272   | 1   |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | 2    | skymapper_point_query_fs_3 | 1000  | 2   |
    | Main Survey        | ms        | 178.83871 | -1.18844 | 0.15 | skymapper_point_query_ms_1 | 488   | 1   |
    | Main Survey        | ms        | 178.83871 | -1.18844 | 0.5  | skymapper_point_query_ms_3 | 1000  | 2   |

  #Numbers with + at front should validate properly
  @javascript
  Scenario Outline: I perform radial search
    Given I select the "Radial" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fake tap search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see results for catalogue "<catalogue>" as "<results>" in all pages with limit "50"
    Then I follow "Back"
    And I should see the "Radial" tab
    And I should see search field "SkyMapper survey" with value "<catalogue>"
    And I should see search field "Right ascension (deg)" with value "<ra>"
    And I should see search field "Declination (deg)" with value "<dec>"
  Examples:
    | survey             | catalogue | ra         | dec      | sr    | results                    | count |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | +0.5  | skymapper_point_query_fs_1 | 272   |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | +2    | skymapper_point_query_fs_3 | 1000  |
    | Main Survey        | ms        | 178.83871 | -1.18844 | +0.15 | skymapper_point_query_ms_1 | 488   |
    | Main Survey        | ms        | 178.83871 | -1.18844 | +0.5  | skymapper_point_query_ms_3 | 1000  |

  #SKYM-92: Show errors
  @javascript
  Scenario Outline: Show error message when there was an error while running query
    Given I select the "Radial" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fake tap search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I wait for "Fetching results..."
    And I should see "There was an error while running query: 'Error while accessing DB'. Please try again later"
  Examples:
    | survey             | catalogue | ra        | dec      | sr    | results                    |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | +0.5  | skymapper_error_in_votable |

  # SKYM-82
  @javascript
  Scenario Outline: Leading zeros are stripped from the parameters when I perform a search
    Given I select the "Radial" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fake tap search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see search parameter "Right ascension:" as "<stripped_ra>"
    And I should see search parameter "Declination:" as "<stripped_dec>"
  Examples:
    | survey             | catalogue | ra           | dec         | sr    | results                    | count | stripped_ra | stripped_dec |
    | Five-Second Survey | fs        | 000178.83871 |  0001.18844 | +0.5  | skymapper_point_query_fs_1 | 272   | 178.83871   | 1.18844      |
    | Five-Second Survey | fs        | 178.83871    | -0000.18844 | +2    | skymapper_point_query_fs_3 | 1000  | 178.83871   | -0.18844     |


  # SKYM-94
  @javascript
  Scenario Outline: I perform a search which returns less than 1000 results, no truncation warning is shown
    Given I select the "Radial" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fake tap search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    Then I should not see "To retrieve all possible results please click the "
  Examples:
    | survey             | catalogue | ra           | dec         | sr    | results                    | count |
    | Five-Second Survey | fs        | 000178.83871 |  0001.18844 | +0.5  | skymapper_point_query_fs_1 | 272   |


  # SKYM-94
  @javascript
  Scenario Outline: I perform a search which returns less 1000 results, a truncation warning is shown
    Given I select the "Radial" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fake tap search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    Then I should see "To retrieve all possible results please click the "
  Examples:
    | survey             | catalogue | ra           | dec         | sr    | results                    | count |
    | Five-Second Survey | fs        | 000178.83871 |  0001.18844 | +0.5  | skymapper_point_query_fs_3 | 1000  |

  # SKYM-97
  @javascript
  Scenario: I am informed of the search limits on the radial search tab
    Given I select the "Radial" tab
    Then I should see "The web interface is limited to displaying the first 1000 results of a query."
    And I should see "The upper limit for results downloaded via the TAP service is 1234 results."


  # SKYM-101
  @javascript
  Scenario Outline: I can search using different formats
    Given I select the "Radial" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fake tap search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
  Examples:
    | survey             | catalogue | ra        | dec         | sr    | results                    | count  |
    | Five-Second Survey | fs        | 11:55:21  |  01:11:18   | +0.5  | skymapper_point_query_fs_1 | 272    |
    | Main Survey        | ms        | 11 55 21  | -01 11 18   | +0.15 | skymapper_point_query_ms_1 | 488    |

  #SKYM-75
  @javascript
  Scenario Outline: Async popup only shows up when form is valid
    Given I select the "Radial" tab
    And I check "Asynchronous Query"
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I press "Search SkyMapper"
    Then I should see error "This field is required." for "Declination (deg)"
    And I should not see "Email address"
    And I fill in "<dec>" for "Declination (deg)"
    And I press "Search SkyMapper"
    And I pause for 1 seconds
    Then I should see "Email address"
  Examples:
    | survey             | catalogue | ra        | dec         | sr    | results                    | count  |
    | Five-Second Survey | fs        | 11:55:21  |  01:11:18   | +0.5  | skymapper_point_query_fs_1 | 272    |

  #SKYM-75
  @javascript
  Scenario Outline: Can submit an Async job
    Given I select the "Radial" tab
    And I check "Asynchronous Query"
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I press "Search SkyMapper"
    And I pause for 1 seconds
    Then I should see "Email address"
    When I fill in "elvis@graceland.org" for "Email address"
    When I fill in "elvis@graceland.org" for "Confirm email address"
    And I press "Submit"
    And I pause for 5 seconds
    Then I should be on the job details view page
    And I reload the page
    And "elvis@graceland.org" should receive 2 emails
    When "elvis@graceland.org" opens the email with subject "New job has been successfully scheduled."
    Then I should see "Your job has been successfully scheduled. You can find status and more details under this" in the email body
    When "elvis@graceland.org" opens the email with subject "Scheduled job finished successfully."
    Then I should see "Your scheduled job has finished successfully. You can download results from" in the email body
  Examples:
    | survey             | catalogue | ra        | dec         | sr    | results                    | count  |
    | Five-Second Survey | fs        | 11:55:21  |  01:11:18   | +0.5  | skymapper_point_query_fs_1 | 272    |

  #SKYM-75
  @javascript
  Scenario Outline: Async job won't submit without matching email addresses
    Given I select the "Radial" tab
    And I check "Asynchronous Query"
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I press "Search SkyMapper"
    And I pause for 1 seconds
    Then I should see "Email address"
    When I fill in "elvis@graceland.org" for "Email address"
    When I fill in "priscilla@graceland.org" for "Confirm email address"
    Then I should see "Email and Confirm Email must match."
    Then the "Submit" button should be disabled
  Examples:
    | survey             | catalogue | ra        | dec         | sr    | results                    | count  |
    | Five-Second Survey | fs        | 11:55:21  |  01:11:18   | +0.5  | skymapper_point_query_fs_1 | 272    |

  #SKYM-75
  @javascript
  Scenario Outline: Can cancel and async job with bad emails and submit a sync job
    Given I select the "Radial" tab
    And I check "Asynchronous Query"
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I press "Search SkyMapper"
    And I pause for 1 seconds
    Then I should see "Email address"
    When I fill in "elvis@graceland.org" for "Email address"
    When I fill in "priscilla@graceland.org" for "Confirm email address"
    Then I should see "Email and Confirm Email must match."
    Then I press "Cancel"
    And I uncheck "Asynchronous Query"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
  Examples:
    | survey             | catalogue | ra        | dec         | sr    | results                    | count  |
    | Five-Second Survey | fs        | 11:55:21  |  01:11:18   | +0.5  | skymapper_point_query_fs_1 | 272    |

  #SKYM-105
  @javascript
  Scenario Outline: Successfully scheduled and executed async job
    Given I select the "Radial" tab
    And I check "Asynchronous Query"
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I press "Search SkyMapper"
    And I pause for 1 seconds
    When I fill in "elvis@graceland.org" for "Email address"
    When I fill in "elvis@graceland.org" for "Confirm email address"
    And I clean fake web
    And I fake tap request to schedule async job
    And I fake tap request to start async job
    And I fake tap request successfully finished
    And I fake download results for async job
    And I press "Submit"
    Then I should be on the job details view page
    And I should see "<start_time>"
    And I should see "<end_time>"
    And I should see "<params>"
    And I should see "<status>"
    And I should see "<id>"
    And I should see "<query_type>"
    And I should see results download button
    And "elvis@graceland.org" should receive 2 emails
    When "elvis@graceland.org" opens the email with subject "New job has been successfully scheduled."
    Then I should see "Your job has been successfully scheduled. You can find status and more details under this" in the email body
    When "elvis@graceland.org" opens the email with subject "Scheduled job finished successfully."
    Then I should see "Your scheduled job has finished successfully. You can download results from" in the email body
    And I click on download results button
    And I should downloaded csv file "<downloaded_file>" with name "<id>.csv"

  Examples:
    | survey             | ra        | dec         | sr    | start_time              |         end_time        | params                                                       | status      | id      | query_type   |  downloaded_file               |
    | Five-Second Survey | 11:55:21  |  01:11:18   | +0.5  | 2014-03-27 09:44:44 UTC | 2014-03-27 09:45:47 UTC | Right ascension: 178.8375, Declination: 1.188333, Radius: 0.5| COMPLETED   | somejob | Radial search|  skymapper_download_point_query|

  #SKYM-105
  @javascript
  Scenario Outline: I can cancel running async job
    Given I select the "Radial" tab
    And I check "Asynchronous Query"
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I press "Search SkyMapper"
    And I pause for 1 seconds
    When I fill in "elvis@graceland.org" for "Email address"
    When I fill in "elvis@graceland.org" for "Confirm email address"
    And I clean fake web
    And I fake tap request to schedule async job
    And I fake tap request to start async job
    And I fake long running async job
    And I press "Submit"
    Then I should be on the job details view page
    And I should see "<start_time>"
    And I should see "<params>"
    And I should see "<status>"
    And I should see "<id>"
    And I should see "<query_type>"
    And I should see cancel button
    And "elvis@graceland.org" should receive 1 emails
    When "elvis@graceland.org" opens the email with subject "New job has been successfully scheduled."
    Then I should see "Your job has been successfully scheduled. You can find status and more details under this" in the email body
    And I click on cancel button
    And I cancel the dialog "Are you sure you want to cancel this job ?"
    Then I should be on the job details view page
    And I click on cancel button
    And I confirm the dialog "Are you sure you want to cancel this job ?"
    Then I should be on the job details view page
    And I should see "Job successfully canceled."
    And I should see "<status_canceled>"
    And I should not see results download button
  Examples:
    | survey             | ra        | dec         | sr    | start_time              |      params                                                       | status      | id      | query_type   | status_canceled |
    | Five-Second Survey | 11:55:21  |  01:11:18   | +0.5  | 2014-03-27 09:44:44 UTC |  Right ascension: 178.8375, Declination: 1.188333, Radius: 0.5    | EXECUTING   | somejob | Radial search| CANCELED        |

  #SKYM-114
  @javascript
  Scenario Outline: Backend error when scheduling a job
    Given I select the "Radial" tab
    And I check "Asynchronous Query"
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra>" for "Right ascension (deg)"
    And I fill in "<sr>" for "Search radius (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I press "Search SkyMapper"
    And I pause for 1 seconds
    When I fill in "elvis@graceland.org" for "Email address"
    When I fill in "elvis@graceland.org" for "Confirm email address"
    And I clean fake web
    And I fake tap error request to schedule async job
    And I press "Submit"
    Then I should be on the radial search page
    And I should see "There was an error when scheduling a job. Please try again later."
  Examples:
    | survey             | ra        | dec         | sr    |
    | Five-Second Survey | 11:55:21  |  01:11:18   | +0.5  |
