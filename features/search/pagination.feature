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
    And I can see pages from "1" to "10"
    And I cannot press page "«"
    And I cannot press page "‹"
    And I cannot press page "1"
    And I can press pages "2" to "10"
    And I can press page "›"
    And I can press page "»"
    #And I should see results for catalogue "<catalogue>" as "<results>" in page "1" with limit "50"
    Then I select page "last"
    And I can see pages from "11" to "20"
    Then I cannot press page "»"
    Then I cannot press page "›"
    Then I cannot press page "20"
    Then I can press pages "11" to "19"
    Then I can press page "‹"
    Then I can press page "«"
    #And I should see results for catalogue "<catalogue>" as "<results>" in page "20" with limit "50"
    Then I select page "12"
    And I can see pages from "7" to "16"
    Then I can press page "»"
    Then I can press page "›"
    Then I cannot press page "12"
    Then I can press pages "7" to "11"
    Then I can press pages "13" to "16"
    Then I can press page "‹"
    Then I can press page "«"
    #And I should see results for catalogue "<catalogue>" as "<results>" in page "12" with limit "50"
  Examples:
    | survey             | catalogue | ra        | dec      | sr  | results                    | count |
    | Five-Second Survey | fs        | 178.83871 | -1.18844 | 0.5 | skymapper_point_query_2    | 1000  |