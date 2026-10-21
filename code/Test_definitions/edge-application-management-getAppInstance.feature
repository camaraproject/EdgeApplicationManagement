Feature: CAMARA Edge Application Management API, v0.1.0-rc.1 - Operation getAppInstance
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  #
  # Testing assets:
  # * An appId of a submitted application and the values used in the submitApp operation.
  # * An Application instantiated by createAppInstance operation
  # References to OAS spec schemas refer to schemas specified in edge-application-management.yaml
  Background: Common getAppInstance setup
    Given an environment at "apiRoot"
    And the resource "/edge-application-management/v0.1rc1/app-instances/{appInstanceId}"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
  # Success scenarios
  @eam_getAppInstance_01_generic_success_scenario
  Scenario: Get information of an existing application instance
    Given there is an application instance created by operation createAppInstance
    And the path parameter "$.appInstanceId" is set to a valid application instance ID
    When the request "getAppInstance" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/AppInstanceInfo"
    And the response property "$name" has the value provided for createAppInstance
    And the response property "$appId" has the value provided for createAppInstance
    And the response property "$appInstanceId" has the value provided for createAppInstance and used as path parameter
    And the response property "$appProvider" has the value provided for createAppInstance
    And the response property "$edgeCloudZoneId" has the value provided for createAppInstance
  # Errors
  # Error 404
  @eam_getAppInstance_404.1_not_found
  Scenario: Get information of a non-existing application instance
    Given the path parameter "$.appInstanceId" is set to an invalid application instance ID
    When the request "getAppInstance" is sent
    Then the response status code is 404
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
  # Error 401
  @eam_getAppInstance_401.1_missing_access_token
  Scenario: Missing access token
    Given the header "Authorization" is not included
    When the request "getAppInstance" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
  # Error 403
  @eam_getAppInstance_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include the required scope
    When the request "getAppInstance" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text
