Feature: CAMARA Edge Application Management API, vwip - Operation getClusters
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  #
  # Testing assets:
  # * An available cluster to get information
  #
  # References to OAS spec schemas refer to schemas specified in edge-application-management.yaml
  Background: Common getClusters setup
    Given an environment at "apiRoot"
    And the resource "/edge-application-management/vwip/clusters"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
  # Success scenarios
  #/clusters	GET 200
  @eam_getClusters_01_generic_success_scenario
  Scenario: Get information of existing clusters
    Given There are at least one cluster available
    When the request "getClusters" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And A list of clusters is returned
    And the response body complies with the OAS schema at "/components/schemas/ClusterInfo"
  #/clusters	GET	200	filtered by region
  @eam_getClusters_02_generic_success_scenario_filtered_by_region
  Scenario: Get information of existing clusters with optional parameters ("region")
    Given There are at least one cluster available
    And the request query parameter "$.region" is set to a valid region
    When the request "getClusters" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And information of clusters of "$.region" is returned
    And the response body complies with the OAS schema at "/components/schemas/ClusterInfo"
  #/clusters	GET	200	filtered by edgeCloudZoneId
  @eam_getClusters_03_generic_success_scenario_filtered_by_edgeCloudZone
  Scenario: Get information of existing clusters with optional parameters ("edgeCloudZoneId")
    Given There are at least one cluster available
    And the request query parameter "$.edgeCloudZoneId" is set to a valid edgeCloudZoneId
    When the request "getClusters" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And information of clusters of "$.edgeCloudZoneId" is returned
    And the response body complies with the OAS schema at "/components/schemas/ClusterInfo"
  #/clusters	GET	200	filtered by clusterRef
  @eam_getClusters_04_generic_success_scenario_filtered_by_clusterRef
  Scenario: Get information of existing clusters with optional parameters ("clusterRef")
    Given There are at least one cluster available
    And the request query parameter "$.clusterRef" is set to a valid clusterRef
    When the request "getClusters" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And information of clusters of "$.edgeCloudZoneId" is returned
    And the response body complies with the OAS schema at "/components/schemas/ClusterInfo"
  #Errors
  # Error 401
  @eam_getClusters_401.1_missing_access_token
  Scenario: Missing access token
    Given the header "Authorization" is not included
    When the request "getClusters" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
  # Errors 403
  @eam_getClusters_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include the required scope
    When the request "getClusters" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text
