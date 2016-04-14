(function() {
  'use strict';

  angular.module('app.resources')
    .factory('DemoData', DemoDataFactory);

  /** @ngInject */
  function DemoDataFactory($resource) {
    var base = '/api/v1/demo/providers/:id/:action';
    var DemoData = $resource(base, {action: '@action', id: '@id'});

    DemoData.ec2Flavors = ec2Flavors;
    DemoData.rdsEngines = rdsEngines;
    DemoData.rdsVersions = rdsVersions;
    DemoData.rdsFlavors = rdsFlavors;
    DemoData.ec2Images = ec2Images;
    DemoData.vpcs = vpcs;
    DemoData.subnets = subnets;
    DemoData.zones = zones;
    DemoData.keyNames = keyNames;
    DemoData.securityGroups = securityGroups;
    DemoData.deprovision = deprovision;

    return DemoData;

    function ec2Flavors(id) {
      return DemoData.query({id: id, action: 'ec2_flavors'}).$promise;
    }

    function rdsEngines(id) {
      return DemoData.query({id: id, action: 'rds_engines'}).$promise;
    }

    function rdsVersions(id, engine) {
      return DemoData.query({id: id, action: 'rds_versions', engine: engine}).$promise;
    }

    function rdsFlavors(id, engine, version) {
      return DemoData.query({id: id, action: 'rds_flavors', engine: engine, version: version}).$promise;
    }

    function ec2Images(id) {
      return DemoData.query({id: id, action: 'ec2_images'}).$promise;
    }

    function vpcs(id) {
      return DemoData.query({id: id, action: 'vpcs'}).$promise;
    }

    function subnets(id, vpc_id) {
      return DemoData.query({id: id, action: 'subnets', vpc_id: vpc_id}).$promise;
    }

    function zones(id) {
      return DemoData.query({id: id, action: 'availability_zones'}).$promise;
    }

    function keyNames(id) {
      return DemoData.query({id: id, action: 'key_names'}).$promise;
    }

    function securityGroups(id) {
      return DemoData.query({id: id, action: 'security_groups'}).$promise;
    }

    function deprovision(id, service_id) {
      return DemoData.query({id: id, action: 'deprovision', service_id: service_id}).$promise;
    }
  }
})();
