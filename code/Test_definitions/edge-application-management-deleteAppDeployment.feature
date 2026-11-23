Feature: CAMARA Edge Application Management API, vwip - Operation deleteAppDeployment
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  #
  # Testing assets:
  # * An appId of a submitted application and the values used in the submitApp operation.
  # * A deployment instantiated by createAppDeployment operation.
  #
  # References to OAS spec schemas refer to schemas specified in edge-application-management.yaml
  Background: Common deleteAppDeployment setup
    Given an environment at "apiRoot"
    And the resource "/edge-application-management/vwip/deployments/{appDeploymentId}"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
  # Success scenarios
  @eam_deleteAppDeployment_01_generic_success_scenario_async
  Scenario: Delete an existing application deployment with mandatory parameter ("appDeploymentId")
    Given there are application deployments running
    And the request path parameter {appDeploymentId} is set to a valid application deployment ID
    When the request "deleteAppDeployment" is sent
    Then the response status code is 202
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body is empty
  # Errors
  # Error 404
  @eam_deleteAppDeployment_404.1_invalid_parameter
  Scenario: Error response for deleting a non-existing application deployment
    Given there are application deployments running
    And the request path parameter {appDeploymentId} is set to an invalid application deployment ID
    When the request "deleteAppDeployment" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
  # Error 401
  @eam_deleteAppDeployment_401.1_missing_access_token
  Scenario: Missing access token
    Given the header "Authorization" is not included
    When the request "deleteAppDeployment" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
  # Error 403
  @eam_deleteAppDeployment_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include the required scope
    When the request "deleteAppDeployment" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text
