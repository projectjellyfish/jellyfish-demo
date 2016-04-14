(function() {
  'use strict';

  angular.module('app.resources')
    .factory('DemoData', DemoDataFactory);

  /** @ngInject */
  function DemoDataFactory($resource) {
    var base = '/api/v1/demo/providers/:id/:action';
    var DemoData = $resource(base, {action: '@action', id: '@id'});

    DemoData.deprovision = deprovision;

    return DemoData;

    function deprovision(id, service_id) {
      return DemoData.query({id: id, action: 'deprovision', service_id: service_id}).$promise;
    }
  }
})();
