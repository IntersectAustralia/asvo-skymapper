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
    And I fill in "<ra>" for "Right Ascension (deg)"
    And I fill in "<dec>" for "Declination (deg)"
    And I fill in "<sr>" for "Search Radius (deg)"
    And I press "Search SkyMapper"
    Then I should see search results "skymapper_point_query_results_1.json" as json
  Examples:
    | survey             | ra       | dec      | sr  |
    | Five-Second Survey | 62.70968 | -1.18844 | 0.5 |

