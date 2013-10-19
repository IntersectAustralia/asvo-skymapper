Feature: Pagination
  In order to show pages
  As a user
  I want to use pagination

  Background:
    Given I am on the home page

  @javascript
  Scenario Outline: I perform radial search
    And I select the "Radial" tab
    And I select "<survey>" from "SkyMapper Survey"
    And I fill in "<ra>" for "Right Ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search Radius (deg)"
    And I fake search request for catalogue "<catalogue>" with "<results>"
    And I press "Search SkyMapper"
    Then I should be on the radial search results page
    And I should see radial search parameters with values ("<ra>", "<dec>", "<sr>")
    And I wait for "Fetching results..."
    And I should see "Query returned <count> objects."
    And I should see pages "1" to "10" with page "1" selected given "20" total pages
    And I should see results for catalogue "<catalogue>" as "<results>" in page "1" with limit "50"
    Then I select page "»"
    And I should see pages "11" to "20" with page "20" selected given "20" total pages
    And I should see results for catalogue "<catalogue>" as "<results>" in page "20" with limit "50"
    Then I select page "12"
    And I should see pages "7" to "16" with page "12" selected given "20" total pages
    And I should see results for catalogue "<catalogue>" as "<results>" in page "12" with limit "50"
    Then I select page "‹"
    And I select page "‹"
    And I should see pages "5" to "14" with page "10" selected given "20" total pages
    And I should see results for catalogue "<catalogue>" as "<results>" in page "10" with limit "50"
    Then I select page "›"
    And I should see pages "6" to "15" with page "11" selected given "20" total pages
    And I should see results for catalogue "<catalogue>" as "<results>" in page "11" with limit "50"
  Examples:
    | survey             | catalogue | ra        | dec      | sr  | results                    | count |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | 0.5 | skymapper_point_query_fs_3 | 1000  |