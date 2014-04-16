Feature: Rectangular search
  In order to get rectangular search results
  As a user
  I want to search using rectangle queries

  Background:
    Given I am on the search page

  @javascript
  Scenario Outline: I perform rectangular search
    Given I select the "Rectangular" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra_min>" for "Right ascension min (deg)"
    And I fill in "<ra_max>" for "Right ascension max (deg)"
    And I fill in "<dec_min>" for "Declination min (deg)"
    And I fill in "<dec_max>" for "Declination max (deg)"
    And I fake tap search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the rectangular search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see rectangular search parameters with values ("<ra_min>", "<ra_max>", "<dec_min>", "<dec_max>")
    And I should see results for catalogue "<catalogue>" as "<results>" in all pages with limit "50"
    Then I follow "Back"
    And I should see the "Rectangular" tab
    And I should see search field "SkyMapper survey" with value "<catalogue>"
    And I should see search field "Right ascension min (deg)" with value "<ra_min>"
    And I should see search field "Right ascension max (deg)" with value "<ra_max>"
    And I should see search field "Declination min (deg)" with value "<dec_min>"
    And I should see search field "Declination max (deg)" with value "<dec_max>"
  Examples:
    | survey             | catalogue | ra_min | ra_max | dec_min | dec_max | results                          | count |
    | Five-Second Survey | fs        | 1.75   | 2.25   | -2.25   | -0.75   | skymapper_rectangular_query_fs_1 | 547   |
    | Five-Second Survey | fs        | 0      | 10     | -2.25   | -0.75   | skymapper_rectangular_query_fs_3 | 1000  |
    | Main Survey        | ms        | 1.975  | 2.025  | -1.525  | -1.475  | skymapper_rectangular_query_ms_1 | 44    |
    | Main Survey        | ms        | 1.75   | 2.25   | -2.25   | -0.75   | skymapper_rectangular_query_ms_3 | 1000  |

  @javascript
  Scenario Outline: I perform rectangular search using filters (FS)
    Given I select the "Rectangular" tab
    And I select "Five-Second Survey" from "SkyMapper survey"
    And I fill in "1.75" for "Right ascension min (deg)"
    And I fill in "2.25" for "Right ascension max (deg)"
    And I fill in "-2.25" for "Declination min (deg)"
    And I fill in "-0.75" for "Declination max (deg)"
    And I fill in "<min_filter>" for "<min_filter_field>"
    And I fill in "<max_filter>" for "<max_filter_field>"
    And I fake tap search request for catalogue "fs" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the rectangular search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see rectangular search parameters with values ("1.75", "2.25", "-2.25", "-0.75")
    And I should see search parameter "<min_filter_field>" as "<min_filter>"
    And I should see search parameter "<max_filter_field>" as "<max_filter>"
    And I should see results for catalogue "fs" as "<results>" in all pages with limit "50"
    Then I follow "Back"
    And I should see the "Rectangular" tab
    And I should see search field "SkyMapper survey" with value "fs"
    And I should see search field "Right ascension min (deg)" with value "1.75"
    And I should see search field "Right ascension max (deg)" with value "2.25"
    And I should see search field "Declination min (deg)" with value "-2.25"
    And I should see search field "Declination max (deg)" with value "-0.75"
    And I should see search field "<min_filter_field>" with value "<min_filter>"
    And I should see search field "<max_filter_field>" with value "<max_filter>"
  Examples:
    | min_filter_field | max_filter_field | min_filter | max_filter | results                                   | count |
    | U min            | U max            | 50         |            | skymapper_rectangular_query_fs_u_filter_1 | 156   |
    | U min            | U max            |            | 500        | skymapper_rectangular_query_fs_u_filter_2 | 498   |
    | U min            | U max            | 50         | 500        | skymapper_rectangular_query_fs_u_filter_3 | 107   |
    | V min            | V max            | 50         |            | skymapper_rectangular_query_fs_v_filter_1 | 156   |
    | V min            | V max            |            | 500        | skymapper_rectangular_query_fs_v_filter_2 | 498   |
    | V min            | V max            | 50         | 500        | skymapper_rectangular_query_fs_v_filter_3 | 107   |
    | G min            | G max            | 50         |            | skymapper_rectangular_query_fs_g_filter_1 | 313   |
    | G min            | G max            |            | 500        | skymapper_rectangular_query_fs_g_filter_2 | 434   |
    | G min            | G max            | 50         | 500        | skymapper_rectangular_query_fs_g_filter_3 | 200   |
    | R min            | R max            | 50         |            | skymapper_rectangular_query_fs_r_filter_1 | 448   |
    | R min            | R max            |            | 500        | skymapper_rectangular_query_fs_r_filter_2 | 404   |
    | R min            | R max            | 50         | 500        | skymapper_rectangular_query_fs_r_filter_3 | 305   |
    | I min            | I max            | 50         |            | skymapper_rectangular_query_fs_i_filter_1 | 521   |
    | I min            | I max            |            | 500        | skymapper_rectangular_query_fs_i_filter_2 | 372   |
    | I min            | I max            | 50         | 500        | skymapper_rectangular_query_fs_i_filter_3 | 346   |
    | Z min            | Z max            | 50         |            | skymapper_rectangular_query_fs_z_filter_1 | 530   |
    | Z min            | Z max            |            | 500        | skymapper_rectangular_query_fs_z_filter_2 | 352   |
    | Z min            | Z max            | 50         | 500        | skymapper_rectangular_query_fs_z_filter_3 | 335   |

  @javascript
  Scenario Outline: I perform rectangular search using filters (MS)
    Given I select the "Rectangular" tab
    And I select "Main Survey" from "SkyMapper survey"
    And I fill in "1.975" for "Right ascension min (deg)"
    And I fill in "2.025" for "Right ascension max (deg)"
    And I fill in "-1.525" for "Declination min (deg)"
    And I fill in "-1.475" for "Declination max (deg)"
    And I fill in "<min_filter>" for "<min_filter_field>"
    And I fill in "<max_filter>" for "<max_filter_field>"
    And I fake tap search request for catalogue "ms" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the rectangular search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see rectangular search parameters with values ("1.975", "2.025", "-1.525", "-1.475")
    And I should see search parameter "<min_filter_field>" as "<min_filter>"
    And I should see search parameter "<max_filter_field>" as "<max_filter>"
    And I should see results for catalogue "ms" as "<results>" in all pages with limit "50"
    Then I follow "Back"
    And I should see the "Rectangular" tab
    And I should see search field "SkyMapper survey" with value "ms"
    And I should see search field "Right ascension min (deg)" with value "1.975"
    And I should see search field "Right ascension max (deg)" with value "2.025"
    And I should see search field "Declination min (deg)" with value "-1.525"
    And I should see search field "Declination max (deg)" with value "-1.475"
    And I should see search field "<min_filter_field>" with value "<min_filter>"
    And I should see search field "<max_filter_field>" with value "<max_filter>"
  Examples:
    | min_filter_field | max_filter_field | min_filter | max_filter | results                                   | count |
    | U min            | U max            | 0.1        |            | skymapper_rectangular_query_ms_u_filter_1 | 29    |
    | U min            | U max            |            | 1          | skymapper_rectangular_query_ms_u_filter_2 | 38    |
    | U min            | U max            | 0.1        | 1          | skymapper_rectangular_query_ms_u_filter_3 | 23    |
    | V min            | V max            | 0.1        |            | skymapper_rectangular_query_ms_v_filter_1 | 29    |
    | V min            | V max            |            | 1          | skymapper_rectangular_query_ms_v_filter_2 | 38    |
    | V min            | V max            | 0.1        | 1          | skymapper_rectangular_query_ms_v_filter_3 | 23    |
    | G min            | G max            | 0.1        |            | skymapper_rectangular_query_ms_g_filter_1 | 40    |
    | G min            | G max            |            | 1          | skymapper_rectangular_query_ms_g_filter_2 | 27    |
    | G min            | G max            | 0.1        | 1          | skymapper_rectangular_query_ms_g_filter_3 | 23    |
    | R min            | R max            | 0.1        |            | skymapper_rectangular_query_ms_r_filter_1 | 44    |
    | R min            | R max            |            | 1          | skymapper_rectangular_query_ms_r_filter_2 | 18    |
    | R min            | R max            | 0.1        | 1          | skymapper_rectangular_query_ms_r_filter_3 | 18    |
    | I min            | I max            | 0.1        |            | skymapper_rectangular_query_ms_i_filter_1 | 44    |
    | I min            | I max            |            | 1          | skymapper_rectangular_query_ms_i_filter_2 | 10    |
    | I min            | I max            | 0.1        | 1          | skymapper_rectangular_query_ms_i_filter_3 | 10    |
    | Z min            | Z max            | 0.1        |            | skymapper_rectangular_query_ms_z_filter_1 | 42    |
    | Z min            | Z max            |            | 1          | skymapper_rectangular_query_ms_z_filter_2 | 8     |
    | Z min            | Z max            | 0.1        | 1          | skymapper_rectangular_query_ms_z_filter_3 | 6     |

  @javascript
  Scenario Outline: I perform rectangular search should allow spaces in filters
    Given I select the "Rectangular" tab
    And I select "Five-Second Survey" from "SkyMapper survey"
    And I fill in "1.75" for "Right ascension min (deg)"
    And I fill in "2.25" for "Right ascension max (deg)"
    And I fill in "-2.25" for "Declination min (deg)"
    And I fill in "-0.75" for "Declination max (deg)"
    And I fill in "<min_filter>" for "<min_filter_field>"
    And I fill in "<max_filter>" for "<max_filter_field>"
    And I fake tap search request for catalogue "fs" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the rectangular search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see rectangular search parameters with values ("1.75", "2.25", "-2.25", "-0.75")
    And I should see search parameter "<min_filter_field>" as "<clean_min_filter>"
    And I should see search parameter "<max_filter_field>" as "<clean_max_filter>"
    And I should see results for catalogue "fs" as "<results>" in all pages with limit "50"
    Then I follow "Back"
    And I should see the "Rectangular" tab
    And I should see search field "SkyMapper survey" with value "fs"
    And I should see search field "Right ascension min (deg)" with value "1.75"
    And I should see search field "Right ascension max (deg)" with value "2.25"
    And I should see search field "Declination min (deg)" with value "-2.25"
    And I should see search field "Declination max (deg)" with value "-0.75"
    And I should see search field "<min_filter_field>" with value "<min_filter>"
    And I should see search field "<max_filter_field>" with value "<max_filter>"
  Examples:
    | min_filter_field | max_filter_field | min_filter | max_filter | results                                   | count | clean_min_filter | clean_max_filter |
    | U min            | U max            | 5  0       |            | skymapper_rectangular_query_fs_u_filter_1 | 156   | 50               |                  |
    | U min            | U max            |            | 50  0      | skymapper_rectangular_query_fs_u_filter_2 | 498   |                  | 500              |
    | U min            | U max            | 5  0       | 5  00      | skymapper_rectangular_query_fs_u_filter_3 | 107   | 50               | 500              |

  @javascript
  Scenario Outline: I perform rectangular search using all filters
    Given I select the "Rectangular" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra_min>" for "Right ascension min (deg)"
    And I fill in "<ra_max>" for "Right ascension max (deg)"
    And I fill in "<dec_min>" for "Declination min (deg)"
    And I fill in "<dec_max>" for "Declination max (deg)"
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
    Then I should be on the rectangular search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see rectangular search parameters with values ("<ra_min>", "<ra_max>", "<dec_min>", "<dec_max>")
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
    And I should see the "Rectangular" tab
    And I should see search field "SkyMapper survey" with value "<catalogue>"
    And I should see search field "Right ascension min (deg)" with value "<ra_min>"
    And I should see search field "Right ascension max (deg)" with value "<ra_max>"
    And I should see search field "Declination min (deg)" with value "<dec_min>"
    And I should see search field "Declination max (deg)" with value "<dec_max>"
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
    | survey             | catalogue | ra_min | ra_max | dec_min | dec_max | min_filter | max_filter | results                                   | count |
    | Five-Second Survey | fs        | 1.75   | 2.25   | -2.25   | -0.75   | 50         | 500        | skymapper_rectangular_query_fs_filter_all | 23    |
    | Main Survey        | ms        | 1.975  | 2.025  | -1.525  | -1.475  | 0.1        | 1          | skymapper_rectangular_query_ms_filter_all | 1     |

  @javascript
  Scenario Outline: I perform rectangular search returns empty
    Given I select the "Rectangular" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra_min>" for "Right ascension min (deg)"
    And I fill in "<ra_max>" for "Right ascension max (deg)"
    And I fill in "<dec_min>" for "Declination min (deg)"
    And I fill in "<dec_max>" for "Declination max (deg)"
    And I fake tap search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the rectangular search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see rectangular search parameters with values ("<ra_min>", "<ra_max>", "<dec_min>", "<dec_max>")
    And I should not see any results
  Examples:
    | survey             | catalogue | ra_min | ra_max | dec_min | dec_max | results                          | count |
    | Five-Second Survey | fs        | 1      | 2      | 1       | 2       | skymapper_rectangular_query_fs_2 | 0     |
    | Main Survey        | ms        | 1      | 2      | 1       | 2       | skymapper_rectangular_query_ms_2 | 0     |

  @javascript
  Scenario Outline: I cannot perform rectangular search if request error
    Given I select the "Rectangular" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra_min>" for "Right ascension min (deg)"
    And I fill in "<ra_max>" for "Right ascension max (deg)"
    And I fill in "<dec_min>" for "Declination min (deg)"
    And I fill in "<dec_max>" for "Declination max (deg)"
    And I fake tap search request for catalogue "<catalogue>" returns error
    And I press "Search SkyMapper"
    Then I should be on the rectangular search results page
    And I wait for "Fetching results..."
    And I should see "There was an error fetching the results."
    And I should see rectangular search parameters with values ("<ra_min>", "<ra_max>", "<dec_min>", "<dec_max>")
    And I should not see any results
  Examples:
    | survey             | catalogue | ra_min | ra_max | dec_min | dec_max |
    | Five-Second Survey | fs        | 1.75   | 2.25   | -2.25   | -0.75   |
    | Main Survey        | ms        | 1.975  | 2.025  | -1.525  | -1.475  |

  @javascript
  Scenario Outline: I can submit rectangular search with the follow values
    Given I select the "Rectangular" tab
    And I fill in "<value>" for "<field>"
    Then I should not see any errors for "<field>"
  Examples:
    | field                     | value      |
    | Right ascension min (deg) | 0          |
    | Right ascension min (deg) | 00 00 00   |
    | Right ascension min (deg) | 00:00:00   |
    | Right ascension min (deg) | 23:59:59   |
    | Right ascension min (deg) | 23 59 59   |
    | Right ascension min (deg) | 359.999999 |
    | Right ascension min (deg) | 123.123456 |
    | Right ascension max (deg) | 0          |
    | Right ascension max (deg) | 359.999999 |
    | Right ascension max (deg) | 123.123456 |
    | Declination min (deg)     | -90        |
    | Declination min (deg)     | -90:00:00  |
    | Declination min (deg)     | -90 00 00  |
    | Declination min (deg)     | 90         |
    | Declination min (deg)     | 90 00 00   |
    | Declination min (deg)     | 90:00:00   |
    | Declination min (deg)     | 12.123456  |
    | Declination max (deg)     | -90        |
    | Declination max (deg)     | 90         |
    | Declination max (deg)     | 12.123456  |
    | U min                     | -100000000 |
    | U min                     | 000000000  |
    | U min                     | 1.123      |
    | U max                     | -100000000 |
    | U max                     | 000000000  |
    | U max                     | 1.123      |
    | V min                     | -100000000 |
    | V min                     | 000000000  |
    | V min                     | 1.123      |
    | V max                     | -100000000 |
    | V max                     | 000000000  |
    | V max                     | 1.123      |
    | G min                     | -100000000 |
    | G min                     | 000000000  |
    | G min                     | 1.123      |
    | G max                     | -100000000 |
    | G max                     | 000000000  |
    | G max                     | 1.123      |
    | R min                     | -100000000 |
    | R min                     | 000000000  |
    | R min                     | 1.123      |
    | R max                     | -100000000 |
    | R max                     | 000000000  |
    | R max                     | 1.123      |
    | I min                     | -100000000 |
    | I min                     | 000000000  |
    | I min                     | 1.123      |
    | I max                     | -100000000 |
    | I max                     | 000000000  |
    | I max                     | 1.123      |
    | Z min                     | -100000000 |
    | Z min                     | 000000000  |
    | Z min                     | 1.123      |
    | Z max                     | -100000000 |
    | Z max                     | 000000000  |
    | Z max                     | 1.123      |


  @javascript
  Scenario Outline: I cannot submit rectangular search if form has errors
    Given I select the "Rectangular" tab
    And I fill in "<value>" for "<field>"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field                     | value       | error                                                                                            |
    | Right ascension min (deg) | -1          | This field should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD. |
    | Right ascension min (deg) | 360         | Value in degrees should be in range [0, 360). |
    | Right ascension min (deg) | 1.123456789 | This field should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD. |
    | Right ascension min (deg) | 7abc        | This field should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD. |
    | Right ascension max (deg) | -1          | This field should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD. |
    | Right ascension max (deg) | 360         | This field should be a number greater than or equal to 0 and less than 360. |
    | Right ascension max (deg) | 1.123456789 | This field should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD. |
    | Right ascension max (deg) | 7abc        | This field should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD. |
    | Declination min (deg)     | -91         | Value in degrees should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination min (deg)     | 91          | Value in degrees should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination min (deg)     | 1.123456789 | This field should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD. |
    | Declination min (deg)     | 7abc        | This field should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD. |
    | Declination max (deg)     | -91         | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | Declination max (deg)     | 91          | This field should be a number greater than or equal to -90 and less than or equal to 90.|
    | Declination max (deg)     | 1.123456789 | This field should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD. |
    | Declination max (deg)     | 7abc        | This field should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD. |
    | U min                     | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                          |
    | U min                     | 7abc        | This field should be a number with a maximum of 3 decimal places.                          |
    | U max                     | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                          |
    | U max                     | 7abc        | This field should be a number with a maximum of 3 decimal places.                          |
    | V min                     | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                          |
    | V min                     | 7abc        | This field should be a number with a maximum of 3 decimal places.                          |
    | V max                     | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                          |
    | V max                     | 7abc        | This field should be a number with a maximum of 3 decimal places.                          |
    | G min                     | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                          |
    | G min                     | 7abc        | This field should be a number with a maximum of 3 decimal places.                          |
    | G max                     | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                          |
    | G max                     | 7abc        | This field should be a number with a maximum of 3 decimal places.                          |
    | R min                     | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                          |
    | R min                     | 7abc        | This field should be a number with a maximum of 3 decimal places.                          |
    | R max                     | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                          |
    | R max                     | 7abc        | This field should be a number with a maximum of 3 decimal places.                          |
    | I min                     | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                          |
    | I min                     | 7abc        | This field should be a number with a maximum of 3 decimal places.                          |
    | I max                     | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                          |
    | I max                     | 7abc        | This field should be a number with a maximum of 3 decimal places.                          |
    | Z min                     | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                          |
    | Z min                     | 7abc        | This field should be a number with a maximum of 3 decimal places.                          |
    | Z max                     | 1.123456789 | This field should be a number with a maximum of 3 decimal places.                          |
    | Z max                     | 7abc        | This field should be a number with a maximum of 3 decimal places.                          |

  @javascript
  Scenario Outline: Max fields should not display errors if min fields are less than or not a number
    Given I select the "Rectangular" tab
    And I fill in "<min>" for "<min_field>"
    And I fill in "<max>" for "<max_field>"
    Then I should not see any errors for "<max_field>"
  Examples:
    | min_field                 | max_field                 | min          | max       |
    | Right ascension min (deg) | Right ascension max (deg) | 20           | 30        |
    | Right ascension min (deg) | Right ascension max (deg) | 20.12345     | 20.12346  |
    | Right ascension min (deg) | Right ascension max (deg) | 20.12345abc  | 20.12345  |
    | Right ascension min (deg) | Right ascension max (deg) | 7abc         | 10        |
    | Right ascension min (deg) | Right ascension max (deg) | 7abc         | 0         |
    | Declination min (deg)     | Declination max (deg)     | -45          | -35       |
    | Declination min (deg)     | Declination max (deg)     | -45.12345    | -45.12344 |
    | Declination min (deg)     | Declination max (deg)     | -45.12345abc | -45.12345 |
    | Declination min (deg)     | Declination max (deg)     | 7abc         | 10        |
    | Declination min (deg)     | Declination max (deg)     | 7abc         | 0         |
    | U min                     | U max                     | 0.123        | 0.124     |
    | U min                     | U max                     | 500          | 1000      |
    | U min                     | U max                     | -1000        | -500      |
    | U min                     | U max                     | 7abc         | -500      |
    | V min                     | V max                     | 0.123        | 0.124     |
    | V min                     | V max                     | 500          | 1000      |
    | V min                     | V max                     | -1000        | -500      |
    | V min                     | V max                     | 7abc         | -500      |
    | G min                     | G max                     | 0.123        | 0.124     |
    | G min                     | G max                     | 500          | 1000      |
    | G min                     | G max                     | -1000        | -500      |
    | G min                     | G max                     | 7abc         | -500      |
    | R min                     | R max                     | 0.123        | 0.124     |
    | R min                     | R max                     | 500          | 1000      |
    | R min                     | R max                     | -1000        | -500      |
    | R min                     | R max                     | 7abc         | -500      |
    | I min                     | I max                     | 0.123        | 0.124     |
    | I min                     | I max                     | 500          | 1000      |
    | I min                     | I max                     | -1000        | -500      |
    | I min                     | I max                     | 7abc         | -500      |
    | Z min                     | Z max                     | 0.123        | 0.124     |
    | Z min                     | Z max                     | 500          | 1000      |
    | Z min                     | Z max                     | -1000        | -500      |
    | Z min                     | Z max                     | 7abc         | -500      |

  @javascript
  Scenario Outline: Max fields should display error if min fields are greater than or equal to
    Given I select the "Rectangular" tab
    And I fill in "<min>" for "<min_field>"
    And I fill in "<max>" for "<max_field>"
    Then I should see error "<error>" for "<max_field>"
  Examples:
    | min_field                 | max_field                 | min        | max            | error                                                                                    |
    | Right ascension min (deg) | Right ascension max (deg) | 20         | 10             | This field should be a number greater than 20 and less than 360.                         |
    | Right ascension min (deg) | Right ascension max (deg) | 33.3       | 10.5           | This field should be a number greater than 33.3 and less than 360.                       |
    | Right ascension min (deg) | Right ascension max (deg) | 0          | 0              | This field should be a number greater than 0 and less than 360.                          |
    | Right ascension min (deg) | Right ascension max (deg) | 7abc       | 361            | This field should be a number greater than or equal to 0 and less than 360.              |
    | Declination min (deg)     | Declination max (deg)     | -45        | -50            | This field should be a number greater than -45 and less than or equal to 90.             |
    | Declination min (deg)     | Declination max (deg)     | 12.1234    | -50            | This field should be a number greater than 12.1234 and less than or equal to 90.         |
    | Declination min (deg)     | Declination max (deg)     | -90        | -90            | This field should be a number greater than -90 and less than or equal to 90.             |
    | Declination min (deg)     | Declination max (deg)     | 7abc       | 91             | This field should be a number greater than or equal to -90 and less than or equal to 90. |
    | U min                     | U max                     | 0          | 0              | This field should be a number greater than 0.                                            |
    | U min                     | U max                     | 0.12345678 | 0.012345678    | This field should be a number greater than 0.12345678.                                   |
    | U min                     | U max                     | 1000       | 999.99999999   | This field should be a number greater than 1000.                                         |
    | U min                     | U max                     | -1000      | -1000.00000001 | This field should be a number greater than -1000.                                        |
    | V min                     | V max                     | 0          | 0              | This field should be a number greater than 0.                                            |
    | V min                     | V max                     | 0.12345678 | 0.012345678    | This field should be a number greater than 0.12345678.                                   |
    | V min                     | V max                     | 1000       | 999.99999999   | This field should be a number greater than 1000.                                         |
    | V min                     | V max                     | -1000      | -1000.00000001 | This field should be a number greater than -1000.                                        |
    | G min                     | G max                     | 0          | 0              | This field should be a number greater than 0.                                            |
    | G min                     | G max                     | 0.12345678 | 0.012345678    | This field should be a number greater than 0.12345678.                                   |
    | G min                     | G max                     | 1000       | 999.99999999   | This field should be a number greater than 1000.                                         |
    | G min                     | G max                     | -1000      | -1000.00000001 | This field should be a number greater than -1000.                                        |
    | R min                     | R max                     | 0          | 0              | This field should be a number greater than 0.                                            |
    | R min                     | R max                     | 0.12345678 | 0.012345678    | This field should be a number greater than 0.12345678.                                   |
    | R min                     | R max                     | 1000       | 999.99999999   | This field should be a number greater than 1000.                                         |
    | R min                     | R max                     | -1000      | -1000.00000001 | This field should be a number greater than -1000.                                        |
    | I min                     | I max                     | 0          | 0              | This field should be a number greater than 0.                                            |
    | I min                     | I max                     | 0.12345678 | 0.012345678    | This field should be a number greater than 0.12345678.                                   |
    | I min                     | I max                     | 1000       | 999.99999999   | This field should be a number greater than 1000.                                         |
    | I min                     | I max                     | -1000      | -1000.00000001 | This field should be a number greater than -1000.                                        |
    | Z min                     | Z max                     | 0          | 0              | This field should be a number greater than 0.                                            |
    | Z min                     | Z max                     | 0.12345678 | 0.012345678    | This field should be a number greater than 0.12345678.                                   |
    | Z min                     | Z max                     | 1000       | 999.99999999   | This field should be a number greater than 1000.                                         |
    | Z min                     | Z max                     | -1000      | -1000.00000001 | This field should be a number greater than -1000.                                        |

  @javascript
  Scenario Outline: I cannot submit rectangular search if form has errors (required errors)
    Given I select the "Rectangular" tab
    And I press "Search SkyMapper"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field                     | error                   |
    | SkyMapper survey          | This field is required. |
    | Right ascension min (deg) | This field is required. |
    | Right ascension max (deg) | This field is required. |
    | Declination min (deg)     | This field is required. |
    | Declination max (deg)     | This field is required. |

  @javascript
  Scenario Outline: I can see rectangular search object details
    Given I select the "Rectangular" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra_min>" for "Right ascension min (deg)"
    And I fill in "<ra_max>" for "Right ascension max (deg)"
    And I fill in "<dec_min>" for "Declination min (deg)"
    And I fill in "<dec_max>" for "Declination max (deg)"
    And I fake tap search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the rectangular search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see rectangular search parameters with values ("<ra_min>", "<ra_max>", "<dec_min>", "<dec_max>")
    And I should see results for catalogue "<catalogue>" as "<results>" in all pages with limit "50"
    And I click on the object in row "<row>"
    Then I should see details for the object in row "<row>" with results "<results>"
  Examples:
    | survey             | catalogue | ra_min | ra_max | dec_min | dec_max | results                          | count | row |
    | Five-Second Survey | fs        | 1.75   | 2.25   | -2.25   | -0.75   | skymapper_rectangular_query_fs_1 | 547   | 1   |
    | Five-Second Survey | fs        | 0      | 10     | -2.25   | -0.75   | skymapper_rectangular_query_fs_3 | 1000  | 2   |
    | Main Survey        | ms        | 1.975  | 2.025  | -1.525  | -1.475  | skymapper_rectangular_query_ms_1 | 44    | 1   |
    | Main Survey        | ms        | 1.75   | 2.25   | -2.25   | -0.75   | skymapper_rectangular_query_ms_3 | 1000  | 2   |

  # SKYM-97
  @javascript
  Scenario: I am informed of the search limits on the rectangular search tab
    Given I select the "Radial" tab
    Then I should see "The web interface is limited to displaying the first 1000 results of a query."
    And I should see "The upper limit for results downloaded via the TAP service is 1234 results."

  #SKYM-101
  @javascript
  Scenario Outline: I can search using different formats
    Given I select the "Rectangular" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra_hh_min>" for "Right ascension min (deg)"
    And I fill in "<ra_hh_max>" for "Right ascension max (deg)"
    And I fill in "<dec_dd_min>" for "Declination min (deg)"
    And I fill in "<dec_dd_max>" for "Declination max (deg)"
    And I fake tap search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the rectangular search results page
    And I wait for "Fetching results..."

    And I should see "Query returned <count> objects."
    And I should see rectangular search parameters with values ("<ra_min>", "<ra_max>", "<dec_min>", "<dec_max>")
    And I should see results for catalogue "<catalogue>" as "<results>" in all pages with limit "50"
    And I click on the object in row "<row>"
    Then I should see details for the object in row "<row>" with results "<results>"
  Examples:
    | survey             | catalogue | ra_min | ra_max | dec_min | dec_max | results                          | count | row |ra_hh_min | ra_hh_max| dec_dd_min| dec_dd_max|
    | Five-Second Survey | fs        | 1.75   | 2.25   | -2.25   | -0.75   | skymapper_rectangular_query_fs_1 | 547   | 1   | 00:07:00 | 00:09:00 | -02:15:00 | -00:45:00 |
    | Five-Second Survey | fs        | 0      | 10     | -2.25   | -0.75   | skymapper_rectangular_query_fs_3 | 1000  | 2   | 00:00:00 | 00:40:00 | -02:15:00 | -00:45:00 |
    | Main Survey        | ms        | 1.975  | 2.025  | -1.525  | -1.475  | skymapper_rectangular_query_ms_1 | 44    | 1   | 00:07:54 | 00:08:06 | -01:31:30 | -01:28:30 |
    | Main Survey        | ms        | 1.75   | 2.25   | -2.25   | -0.75   | skymapper_rectangular_query_ms_3 | 1000  | 2   | 00:07:00 | 00:09:00 | -02:15:00 | -00:45:00 |

  @javascript
  Scenario Outline: I can see rectangular search object details for plus in params
    Given I select the "Rectangular" tab
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra_min>" for "Right ascension min (deg)"
    And I fill in "<ra_max>" for "Right ascension max (deg)"
    And I fill in "<dec_min>" for "Declination min (deg)"
    And I fill in "<dec_max>" for "Declination max (deg)"
    And I fake tap search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the rectangular search results page
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see rectangular search parameters with values ("<ra_min_clean>", "<ra_max_clean>", "<dec_min>", "<dec_max>")
    And I should see results for catalogue "<catalogue>" as "<results>" in all pages with limit "50"
    And I click on the object in row "<row>"
    Then I should see details for the object in row "<row>" with results "<results>"
  Examples:
    | survey             | catalogue | ra_min  | ra_max  | dec_min | dec_max | results                          | count | row | ra_min_clean | ra_max_clean |
    | Five-Second Survey | fs        | +1.75   | +2.25   | -2.25   | -0.75   | skymapper_rectangular_query_fs_1 | 547   | 1   | 1.75         | 2.25         |
    | Five-Second Survey | fs        | 0       | +10     | -2.25   | -0.75   | skymapper_rectangular_query_fs_3 | 1000  | 2   | 0            | 10           |
    | Main Survey        | ms        | +1.975  | +2.025  | -1.525  | -1.475  | skymapper_rectangular_query_ms_1 | 44    | 1   | 1.975        | 2.025        |
    | Main Survey        | ms        | +1.75   | +2.25   | -2.25   | -0.75   | skymapper_rectangular_query_ms_3 | 1000  | 2   |  1.75        | 2.25         |

  #SKYM-105
  @javascript
  Scenario Outline: Successfully scheduled and executed async job
    Given I select the "Rectangular" tab
    And I check "Asynchronous Query"
    And I select "<survey>" from "SkyMapper survey"
    And I fill in "<ra_min>" for "Right ascension min (deg)"
    And I fill in "<ra_max>" for "Right ascension max (deg)"
    And I fill in "<dec_min>" for "Declination min (deg)"
    And I fill in "<dec_max>" for "Declination max (deg)"
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
    | survey             | ra_min  | ra_max  | dec_min | dec_max | start_time              |         end_time        | params                                                                                             | status      | id      | query_type          |  downloaded_file               |
    | Five-Second Survey | +1.75   | +2.25   | -2.25   | -0.75   | 2014-03-27 09:44:44 UTC | 2014-03-27 09:45:47 UTC |Right ascension min: 1.75, Right ascension max: 2.25, Declination min: -2.25, Declination max: -0.75| COMPLETED   | somejob |  	Rectangular search|  skymapper_download_point_query|
