(function() {
  'use strict';

  angular.module('app.components')
    .run(initFields);

  /** @ngInject */
  function initFields(Forms) {
    Forms.fields('regions', {
      type: 'select',
      templateOptions: {
        label: 'Region',
        options: [
          {label: 'N. Virginia (US-East-1)', value: 'us-east-1', group: 'US'},
          {label: 'N. California (US-West-1)', value: 'us-west-1', group: 'US'},
          {label: 'Oregon (US-West-2)', value: 'us-west-2', group: 'US'},
          {label: 'Ireland (EU-West-1)', value: 'eu-west-1', group: 'Europe'},
          {label: 'Frankfurt (EU-Central-1)', value: 'eu-central-1', group: 'Europe'},
          {label: 'Singapore (AP-Southeast-1)', value: 'ap-southeast-1', group: 'Asia Pacific'},
          {label: 'Sydney (AP-Southeast-2)', value: 'ap-southeast-2', group: 'Asia Pacific'},
          {label: 'Tokyo (AP-Northeast-1)', value: 'ap-northeast-1', group: 'Asia Pacific'},
          {label: 'Sãn Paulo (SA-East-1)', value: 'sa-east-1', group: 'South America'}
        ]
      }
    });

    Forms.fields('instance_sizes', {
      type: 'select',
      templateOptions: {
        label: 'Instance Size',
        options: [
          {label: 'Small', value: 'small'},
          {label: 'Medium', value: 'medium'},
          {label: 'Large', value: 'large'}
        ]
      }
    });

    Forms.fields('cpus', {
      type: 'select',
      templateOptions: {
        label: 'CPUs',
        options: [
          {label: '1', value: '1'},
          {label: '2', value: '2'},
          {label: '3', value: '3'},
          {label: '4', value: '4'},
        ]
      }
    });

    Forms.fields('memory', {
      type: 'select',
      templateOptions: {
        label: 'Memory',
        options: [
          {label: '4 GB', value: '4'},
          {label: '8 GB', value: '8'},
          {label: '16 GB', value: '16'}
        ]
      }
    });

    Forms.fields('operating_systems', {
      type: 'select',
      templateOptions: {
        label: 'Operating System',
        options: [
          {label: 'Amazon Linux', value: 'Amazon Linux'},
          {label: 'RHEL 7', value: 'RHEL 7.1'},
          {label: 'Centos 7', value: 'Centos 7.1'},
          {label: 'Windows', value: 'Windows'},
        ]
      }
    });

    Forms.fields('engines', {
      type: 'select',
      templateOptions: {
        label: 'Engine',
        options: [
          {label: 'MySQL', value: 'MySQL'},
          {label: 'Postgres', value: 'Postgres'},
          {label: 'Microsoft SQL Server', value: 'Microsoft SQL Server'},
          {label: 'Teradata', value: 'Teradata'}
        ]
      }
    });

    Forms.fields('backups', {
      type: 'select',
      templateOptions: {
        label: 'Backup',
        options: [
          {label: 'None', value: 'None'},
          {label: 'Nightly', value: 'Nightly'},
          {label: 'Weekly', value: 'Weekly'},
          {label: 'Monthly', value: 'Monthly'}
        ]
      }
    });

    Forms.fields('environments', {
      type: 'select',
      templateOptions: {
        label: 'Environment',
        options: [
          {label: 'Development', value: 'Development'},
          {label: 'Test', value: 'Test'},
          {label: 'Production', value: 'Production'}
        ]
      }
    });

    /** @ngInject */
    function DemoDataController($scope, DemoData, Toasts) {
      var provider = $scope.formState.provider;
      var action = $scope.options.data.action;

      // Cannot do anything without a provider
      if (angular.isUndefined(provider)) {
        Toasts.warning('No provider set in form state', $scope.options.label);
        return;
      }

      if (!action) {
        Toasts.warning('No action set in field data', $scope.options.label);
        return;
      }

      $scope.to.loading = DemoData[action](provider.id).then(handleResults, handleError);

      function handleResults(data) {
        $scope.to.options = data;
        return data;
      }

      function handleError(response) {
        var error = response.data;

        if (!error.error) {
          error = {
            type: 'Server Error',
            error: 'An unknown server error has occurred.'
          };
        }

        Toasts.error(error.error, [$scope.to.label, error.type].join('::'));

        return response;
      }
    }
  }
})();
