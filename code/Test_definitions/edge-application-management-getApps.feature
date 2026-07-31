Feature: CAMARA Edge Application Management API, v0.1.0-rc.1 - Operations getApps
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  #
  # Testing assets:
  # * Several Apps submitted in the edge cloud.
  #
  # References to OAS spec schemas refer to schemas specified in edge-application-management.yaml
  Background: Common getApps setup
    Given an environment at "apiRoot"
    And the resource "/edge-application-management/v0.1rc1/apps"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
  # Success scenarios
  @eam_getApps_01_generic_success_scenario
  Scenario: Get information of all existing applications
    Given there are applications submitted by operation submitApp
    When the request "getApps" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And A list of applications with information of them is returned
    And the response body complies with the OAS schema at "/components/schemas/AppManifestInfo"
  # Errors
  # Error 404
  @eam_getApps_404.1_apps_not_found
  Scenario: Get a list of application that the user has permission to view
    Given there are not any application submitted by operation submitApp
    When the request "getApps" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
  # Error 401
  @eam_getApps_401.1_missing_access_token
  Scenario: Missing access token
    Given the header "Authorization" is not included
    When the request "getApps" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
  # Errors 403
  @eam_getApps_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include the required scope
    When the request "getApps" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text
