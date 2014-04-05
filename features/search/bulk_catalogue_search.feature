Feature: Bulk catalogue search
  In order to get bulk search results
  As a user
  I want to search using bulk point queries

  Background:
    Given I am on the home page

  @javascript
  @not-jenkins
  Scenario Outline: I perform bulk catalogue search downloads csv files
    Given I select the "Bulk Catalogue" tab
    And I select "<survey>" from "SkyMapper survey"
    And I attach the file "<file>" to "File"
    And I select "<type>" from "Download format"
    And I fill in "<sr>" for "Search radius (deg)"
    And I click on Search SkyMapper
    Then I should downloaded csv file "<downloaded_file>"
  Examples:
    | survey             | file                       | sr   | type | downloaded_file                     |
    | Five-Second Survey | skymapper_bulk_valid_1.csv | 0.05 | CSV  | skymapper_bulk_catalogue_query_fs_1 |
    | Main Survey        | skymapper_bulk_valid_1.csv | 0.05 | CSV  | skymapper_bulk_catalogue_query_ms_1 |

  @javascript
  @not-jenkins
  Scenario Outline: I perform bulk catalogue search downloads vo tables
    Given I select the "Bulk Catalogue" tab
    And I select "<survey>" from "SkyMapper survey"
    And I attach the file "<file>" to "File"
    And I select "<type>" from "Download format"
    And I fill in "<sr>" for "Search radius (deg)"
    And I click on Search SkyMapper
    Then I should download xml file "<downloaded_file>"
  Examples:
    | survey             | file                       | sr   | type    | downloaded_file                     |
    | Five-Second Survey | skymapper_bulk_valid_1.csv | 0.05 | VOTable | skymapper_bulk_catalogue_query_fs_1 |
    | Main Survey        | skymapper_bulk_valid_1.csv | 0.05 | VOTable | skymapper_bulk_catalogue_query_ms_1 |

  @javascript
  Scenario Outline: I can submit bulk catalogue search with the follow values
    Given I select the "Bulk Catalogue" tab
    Then I should see link "example"
    And I fill in "<value>" for "<field>"
    Then I should not see any errors for "<field>"
  Examples:
    | field               | value    |
    | Search radius (deg) | 0.000001 |
    | Search radius (deg) | 0.050000 |
    | Search radius (deg) | 0.012345 |

  @javascript
  Scenario Outline: I cannot submit bulk catalogue search if form has errors
    Given I select the "Bulk Catalogue" tab
    And I fill in "<value>" for "<field>"
    Then I should see error "<error>" for "<field>"
  Examples:
    | field               | value     | error                                                                        |
    | Search radius (deg) | 0         | This field should be a number greater than 0 and less than or equal to 0.05. |
    | Search radius (deg) | 0.050001  | This field should be a number greater than 0 and less than or equal to 0.05. |
    | Search radius (deg) | 0.0123456 | This field should be a number with a maximum of 6 decimal places.            |
    | Search radius (deg) | 0abc      | This field should be a number greater than 0 and less than or equal to 0.05. |

  @javascript
  Scenario: I cannot submit bulk catalogue search if csv file has errors
    Given I select the "Bulk Catalogue" tab
    And I select "Five-Second Survey" from "SkyMapper survey"
    And I attach the file "skymapper_bulk_invalid_4.csv" to "File"
    And I select "CSV" from "Download format"
    And I fill in "0.05" for "Search radius (deg)"
    And I click on Search SkyMapper
    Then I should the following list of file errors
  | error                                                                                                          |
  | Line 7: Right ascension should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD. |
  | Line 7: Declination must be greater than or equal to -90 and less then or equal to 90.                         |
  | Line 8: Right ascension must be greater than or equal to 0 and less then 360.                                  |
  | Line 8: Declination must be greater than or equal to -90 and less then or equal to 90.                         |
  | Line 9: Right ascension must be greater than or equal to 0 and less then 360.                                  |
  | Line 9: Declination must be greater than or equal to -90 and less then or equal to 90.                         |
  | Line 10: Right ascension should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD.|
  | Line 10: Declination must be greater than or equal to -90 and less then or equal to 90.                        |
  | Line 11: Right ascension should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD.|
  | Line 11: Declination should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD.    |
  | Line 12: Right ascension can't be blank                                                                        |
  | Line 12: Declination should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD.    |
  | Line 13: Right ascension can't be blank                                                                        |
  | Line 13: Declination can't be blank                                                                            |
  | Line 14: Right ascension should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD.|
  | Line 14: Declination should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD.    |
  | Line 15: Right ascension should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD.|
  | Line 15: Declination should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD.    |
  | Line 16: Right ascension should be a number in one of the following formats HH:MM:SS.S or HH MM SS.S or DDD.DD.|
  | Line 16: Declination should be a number in one of the following formats DD:MM:SS.S or DD MM SS.S or DDD.DD.    |

  @javascript
  Scenario Outline: I cannot submit bulk catalogue search if form has errors (required errors)
    Given I select the "Bulk Catalogue" tab
    And I click on Search SkyMapper
    Then I should see error "<error>" for "<field>"
  Examples:
    | field               | error                   |
    | SkyMapper survey    | This field is required. |
    | File (csv)          | This field is required. |
    | Download format     | This field is required. |
    | Search radius (deg) | This field is required. |

  #SKYM-75
  @javascript
  Scenario Outline: Can submit an Async job
    Given I select the "Bulk Catalogue" tab
    And I select "<survey>" from "SkyMapper survey"
    And I attach the file "<file>" to "File"
    And I select "<type>" from "Download format"
    And I fill in "<sr>" for "Search radius (deg)"
    And I check "Asynchronous Query"
    And I click on Search SkyMapper
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
    | survey             | file                       | sr   | type | downloaded_file                     |
    | Five-Second Survey | skymapper_bulk_valid_1.csv | 0.05 | CSV  | skymapper_bulk_catalogue_query_fs_1 |


  #SKYM-75
  @javascript
  Scenario Outline: Async job won't submit without matching email addresses
    Given I select the "Bulk Catalogue" tab
    And I select "<survey>" from "SkyMapper survey"
    And I attach the file "<file>" to "File"
    And I select "<type>" from "Download format"
    And I fill in "<sr>" for "Search radius (deg)"
    And I check "Asynchronous Query"
    And I click on Search SkyMapper
    And I pause for 1 seconds
    Then I should see "Email address"
    When I fill in "elvis@graceland.org" for "Email address"
    When I fill in "priscilla@graceland.org" for "Confirm email address"
    Then I should see "Email and Confirm Email must match."
    Then the "Submit" button should be disabled
  Examples:
    | survey             | file                       | sr   | type | downloaded_file                     |
    | Five-Second Survey | skymapper_bulk_valid_1.csv | 0.05 | CSV  | skymapper_bulk_catalogue_query_fs_1 |


  #SKYM-75
  @javascript
  @not-jenkins
  Scenario Outline: Can cancel and async job with bad emails and submit a sync job
    Given I select the "Bulk Catalogue" tab
    And I select "<survey>" from "SkyMapper survey"
    And I attach the file "<file>" to "File"
    And I select "<type>" from "Download format"
    And I fill in "<sr>" for "Search radius (deg)"
    And I check "Asynchronous Query"
    And I click on Search SkyMapper
    And I pause for 1 seconds
    Then I should see "Email address"
    When I fill in "elvis@graceland.org" for "Email address"
    When I fill in "priscilla@graceland.org" for "Confirm email address"
    Then I should see "Email and Confirm Email must match."
    Then I press "Cancel"
    And I uncheck "Asynchronous Query"
    And I click on Search SkyMapper
    Then I should downloaded csv file "<downloaded_file>"
  Examples:
    | survey             | file                       | sr   | type | downloaded_file                     |
    | Five-Second Survey | skymapper_bulk_valid_1.csv | 0.05 | CSV  | skymapper_bulk_catalogue_query_fs_1 |


  #SKYM-105
  @javascript
  Scenario Outline: Successfully scheduled and executed async job
    Given I select the "Bulk Catalogue" tab
    And I select "<survey>" from "SkyMapper survey"
    And I attach the file "<file>" to "File"
    And I select "<type>" from "Download format"
    And I fill in "<sr>" for "Search radius (deg)"
    And I check "Asynchronous Query"
    And I click on Search SkyMapper
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
    | survey             | file                       | sr   | type  | start_time              |         end_time        | params                                                         | status      | id      | query_type               |  downloaded_file               |
    | Five-Second Survey |skymapper_bulk_valid_1.csv  | 0.05 | CSV   | 2014-03-27 09:44:44 UTC | 2014-03-27 09:45:47 UTC |  	Search radius: 0.05, File name: skymapper_bulk_valid_1.csv| COMPLETED   | somejob |  	Bulk catalogue search|  skymapper_download_point_query|
