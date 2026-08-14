Feature: CAMARA Edge Application Management API, vwip - Operation getEdgeCloudZones
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  #
  # Testing assets:
  # * An available edge Cloud Zones to get information, at least one of which
  #   has Kubernetes clusters available
  #
  # References to OAS spec schemas refer to schemas specified in edge-application-management.yaml
  Background: Common getEdgeCloudZones setup
    Given an environment at "apiRoot"
    And the resource "/edge-application-management/vwip/edge-cloud-zones"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
  # Success scenarios
  #/edge-cloud-zones	GET 200
  @eam_getEdgeCloudZones_01_generic_success_scenario
  Scenario: Get a paginated list of existing edge cloud zones
    Given There are at least one Edge Cloud Zones available
    When the request "getEdgeCloudZones" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/EdgeCloudZoneList"
    And the response property "$.edgeCloudZones" is a list of Edge Cloud Zones
    And the response property "$.pagination" is present and complies with the OAS schema at "/components/schemas/Pagination"
    And any Edge Cloud Zone with Kubernetes clusters includes them in the "$.edgeCloudZones[].clusters" property
  #/edge-cloud-zones	GET	200	filtered by countryCode
  @eam_getEdgeCloudZones_02_success_scenario_filtered_by_countryCode
  Scenario: Get information of existing Edge Cloud Zones with optional parameter ("countryCode")
    Given There are at least one Edge Cloud Zones available
    And the request query parameter "$.countryCode" is set to a valid ISO 3166-1 alpha-2 country code
    When the request "getEdgeCloudZones" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And information of Edge Cloud Zones with "$.countryCode" is returned
    And the response body complies with the OAS schema at "/components/schemas/EdgeCloudZoneList"
  #/edge-cloud-zones	GET	200	filtered by edgeCloudProvider
  @eam_getEdgeCloudZones_03_success_scenario_filtered_by_edgeCloudProvider
  Scenario: Get information of existing Edge Cloud Zones with optional parameter ("edgeCloudProvider")
    Given There are at least one Edge Cloud Zones available
    And the request query parameter "$.edgeCloudProvider" is set to a valid Edge Cloud Provider name
    When the request "getEdgeCloudZones" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And information of Edge Cloud Zones of "$.edgeCloudProvider" is returned
    And the response body complies with the OAS schema at "/components/schemas/EdgeCloudZoneList"
  #/edge-cloud-zones	GET	200	filtered by edgeCloudRegion
  @eam_getEdgeCloudZones_04_success_scenario_filtered_by_edgeCloudRegion
  Scenario: Get information of existing Edge Cloud Zones with optional parameter ("edgeCloudRegion")
    Given There are at least one Edge Cloud Zones available
    And the request query parameter "$.edgeCloudRegion" is set to a valid Edge Cloud Provider-specific region name
    When the request "getEdgeCloudZones" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And information of Edge Cloud Zones of "$.edgeCloudRegion" is returned
    And the response body complies with the OAS schema at "/components/schemas/EdgeCloudZoneList"
  #/edge-cloud-zones	GET	200	filtered by status
  @eam_getEdgeCloudZones_05_success_scenario_filtered_by_status
  Scenario: Get information of existing Edge Cloud Zones with optional parameter ("status")
    Given There are at least one Edge Cloud Zones available
    And the request query parameter "$.status" is set to a valid status
    When the request "getEdgeCloudZones" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And information of Edge Cloud Zones of "$.status" is returned
    And the response body complies with the OAS schema at "/components/schemas/EdgeCloudZoneList"
  #/edge-cloud-zones	GET	200	no status filter returns zones regardless of status
  @eam_getEdgeCloudZones_06_success_scenario_no_status_filter
  Scenario: Get existing Edge Cloud Zones without the optional parameter ("status")
    Given there are Edge Cloud Zones available with different statuses
    When the request "getEdgeCloudZones" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And Edge Cloud Zones with any status are returned
    And the response body complies with the OAS schema at "/components/schemas/EdgeCloudZoneList"
  #/edge-cloud-zones	GET	200	paginated by page and perPage
  @eam_getEdgeCloudZones_07_success_scenario_paginated
  Scenario: Get a specific page of existing Edge Cloud Zones with optional parameters ("page", "perPage")
    Given there are more Edge Cloud Zones available than the requested "perPage" value
    And the request query parameter "$.page" is set to a valid page number
    And the request query parameter "$.perPage" is set to a valid perPage value
    When the request "getEdgeCloudZones" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.pagination.page" has the value provided for "$.page"
    And the response property "$.pagination.perPage" has the value provided for "$.perPage"
    And the response body complies with the OAS schema at "/components/schemas/EdgeCloudZoneList"
  # Error 400
  @eam_getEdgeCloudZones_400.1_invalid_page
  Scenario: Invalid pagination parameter ("page")
    Given the request query parameter "$.page" is set to an invalid page number
    When the request "getEdgeCloudZones" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text
  # Error 401
  @eam_getEdgeCloudZones_401.1_missing_access_token
  Scenario: Missing access token
    Given the header "Authorization" is not included
    When the request "getEdgeCloudZones" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
  # Errors 403
  @eam_getEdgeCloudZones_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include the required scope
    When the request "getEdgeCloudZones" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text
