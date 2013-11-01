Feature: Download Results
  In order to download search results
  As a user
  I want to download the results

  Background:
    Given I am on the home page

  @javascript
  Scenario Outline: I perform radial search and download the results
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
    Then I follow "Download Results"
    And I select "<file_type>" from "Select file type:"
#    And I press "Download"
    And I fake download radial search request for catalogue "<catalogue>" with "<downloaded_file>"

  Examples:
    | survey             | catalogue | ra        | dec      | sr   | results                          | count | file_type | downloaded_file                 |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | 2    | skymapper_web_view_point_query   | 1000  | CSV       | skymapper_download_point_query  |

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

  Examples:
    | survey             | catalogue | ra_min | ra_max | dec_min | dec_max | results                              | count |
    | Five-Second Survey | fs        | 0      | 10     | -2.25   | -0.75   | skymapper_web_view_rectangular_query | 1000  |
