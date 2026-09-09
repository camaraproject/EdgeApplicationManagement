Feature: CAMARA Edge Application Management API, v0.1.0-rc.1 - Operation getAppInstances
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  #
  # Testing assets:
  # * An appId of a submitted application and the values used in the submitApp operation.
  # * An Application instantiated by createAppInstance operation
  # References to OAS spec schemas refer to schemas specified in edge-application-management.yaml
  Background: Common getAppInstances setup
    Given an environment at "apiRoot"
    And the resource "/edge-application-management/v0.1rc1/app-instances"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
  # Success scenarios
  @eam_getAppInstances_01_generic_success_scenario
  Scenario: Get information of all existing application instances
    Given there are application instances created by operation createAppInstance
    When the request "getAppInstances" is sent
    Then the response status code is 200
    And A list of existing app instances is returned
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/AppInstanceInfo"
  @eam_getAppInstances_02_success_scenario_filtered_by_appId
  Scenario: Get application instances info with mandatory parameter ("appId")
    Given there are application instances created by operation createAppInstance
    And the request path parameter "$.appId" is set to a valid application ID
    When the request "getAppInstances" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And information of all existing app instances of given app is returned
    And the response body complies with the OAS schema at "/components/schemas/AppInstanceInfo"
  @eam_getAppInstances_03_success_scenario_filtered_by_region
  Scenario: Get application instances info with mandatory parameter ("region")
    Given there are application instances created by operation createAppInstance
    And the request path parameter "$.region" is set to a valid application ID
    When the request "getAppInstances" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And information of all existing app instances running in the specified region is returned
    And the response body complies with the OAS schema at "/components/schemas/AppInstanceInfo"
  # Errors
  # Error 401
  @eam_getAppInstances_401.1_missing_access_token
  Scenario: Missing access token
    Given the header "Authorization" is not included
    When the request "getAppInstances" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
  # Error 403
  @eam_getAppInstances_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include the required scope
    When the request "getAppInstances" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text
