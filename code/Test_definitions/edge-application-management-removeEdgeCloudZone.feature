Feature: CAMARA Edge Application Management API, vwip - Operation removeEdgeCloudZone
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  #
  # Testing assets:
  # * An appId of a submitted application and the values used in the submitApp operation.
  # * A deployment instantiated by createAppDeployment operation, with at least one
  #   edgeCloudZoneId that can be removed.
  #
  # References to OAS spec schemas refer to schemas specified in edge-application-management.yaml
  Background: Common removeEdgeCloudZone setup
    Given an environment at "apiRoot"
    And the resource "/edge-application-management/vwip/deployments/{appDeploymentId}/removeEdgeCloudZone"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
  # Properties not explicitly overwritten in the Scenarios can take any values compliant with the schema
    And the request body is set by default to a request body compliant with the request body schema for this operation
  # Success scenarios
  @eam_removeEdgeCloudZone_01_generic_success_scenario
  Scenario: Remove an Edge Cloud Zone from an existing deployment with mandatory parameters
    Given there is a deployment created by operation createAppDeployment
    And the request path parameter "$.appDeploymentId" is set to a valid application deployment ID
    And the request body property "$.edgeCloudZoneId" is set to an edge zone id part of the deployment
    When the request "removeEdgeCloudZone" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/AppDeploymentInfo"
    And the response property "$.edgeCloudZones" does not contain the value provided for "$.edgeCloudZoneId"
  # Error scenarios
  # Error 400
  @eam_removeEdgeCloudZone_400.1_schema_not_compliant
  Scenario: Invalid Argument. Generic Syntax Exception
    Given the request body is set to any value which is not compliant with the request body schema for this operation
    When the request "removeEdgeCloudZone" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text
  @eam_removeEdgeCloudZone_400.2_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the request "removeEdgeCloudZone" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text
  # Error 404
  @eam_removeEdgeCloudZone_404.1_invalid_deployment
  Scenario: Remove an Edge Cloud Zone from a non-existing deployment
    Given the request path parameter "$.appDeploymentId" is set to an invalid application deployment ID
    When the request "removeEdgeCloudZone" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
  @eam_removeEdgeCloudZone_404.2_zone_not_in_deployment
  Scenario: Remove an Edge Cloud Zone not part of the deployment
    Given there is a deployment created by operation createAppDeployment
    And the request path parameter "$.appDeploymentId" is set to a valid application deployment ID
    And the request body property "$.edgeCloudZoneId" is set to a valid edge zone id not part of the deployment
    When the request "removeEdgeCloudZone" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
  # Error 401
  @eam_removeEdgeCloudZone_401.1_missing_access_token
  Scenario: Missing access token
    Given the header "Authorization" is not included
    When the request "removeEdgeCloudZone" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
  # Errors 403
  @eam_removeEdgeCloudZone_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include the required scope
    When the request "removeEdgeCloudZone" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text
