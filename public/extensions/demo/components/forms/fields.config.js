(function() {
    'use strict';

    angular.module('app.components')
        .run(initFields);

    /** @ngInject */
    function initFields(Forms) {
        Forms.fields('demo_regions', {
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

        Forms.fields('demo_storage_flavors', {
            type: 'select',
            templateOptions: {
                label: 'Instance Type',
                options: [
                    {label: "High I/O Instance - i2.xlarge", value: "i2.xlarge"},
                    {label: "High I/O Instance  - i2.2xlarge", value: "i2.2xlarge"},
                    {label: "High I/O Instance - i2.4xlarge", value: "i2.4xlarge"},
                    {label: "Dense Storage Instance - d2.xlarge", value: "d2.xlarge"},
                    {label: "Dense Storage Instance - d2.2xlarge", value: "d2.2xlarge"}
                ]
            }
        });

        Forms.fields('demo_software_flavors', {
            type: 'select',
            templateOptions: {
                label: 'Instance Type',
                options: [
                    {label: "Burstable Performance Instance - t2.nano", value: "t2.nano"},
                    {label: "Burstable Performance Instance - t2.micro", value: "t2.micro"},
                    {label: "Burstable Performance Instance - t2.small", value: "t2.small"},
                    {label: "Burstable Performance Instance - t2.medium", value: "t2.medium"},
                    {label: "Burstable Performance Instance - t2.large", value: "t2.large"},
                    {label: "Fixed Performance Instance - m4.large", value: "m4.large"},
                    {label: "Fixed Performance Instance - m4.2xlarge", value: "m4.2xlarge"},
                    {label: "Fixed Performance Instance - m4.4xlarge", value: "m4.4xlarge"}
                ]
            }
        });

        Forms.fields('demo_subnets', {
            type: 'select',
            templateOptions: {
                label: 'Subnet',
                options: [{
                    cidr: "172.31.32.0/20",
                    id: "subnet-7632b14b",
                    label: "subnet-7632b14b (172.31.32.0/20)",
                    name: "172.31.32.0/20",
                    value: "subnet-7632b14b",
                    vpc_id: "vpc-0db5d369"
                },{
                    cidr: "172.31.48.0/20",
                    id: "subnet-6ab35740",
                    label: "subnet-6ab35740 (172.31.48.0/20)",
                    name: "172.31.48.0/20",
                    value: "subnet-6ab35740",
                    vpc_id: "vpc-0db5d369"
                }, {
                    cidr: "172.31.0.0/20",
                    id: "subnet-7981510f",
                    label: "subnet-7981510f (172.31.0.0/20)",
                    name: "172.31.0.0/20",
                    value: "subnet-7981510f",
                    vpc_id: "vpc-0db5d369"
                }, {
                    cidr: "172.31.16.0/20",
                    id: "subnet-82d63dda",
                    label: "subnet-82d63dda (172.31.16.0/20)",
                    name: "172.31.16.0/20",
                    value: "subnet-82d63dda",
                    vpc_id: "vpc-0db5d369"
                }]
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

            switch(action) {
                case 'subnets':
                    $scope.$parent.$watch('model.vpc_id' , function (newValue, oldValue, theScope) {
                        if(newValue !== oldValue) {
                            $scope.to.loading = DemoData[action](provider.id, newValue).then(handleResults, handleError);
                        }
                    });
                    $scope.to.loading = DemoData[action](provider.id, 'none').then(handleResults, handleError);
                    break;
                case 'demoFlavors':
                    $scope.$parent.$watch('model.version' , function (newValue, oldValue, theScope) {
                        if(newValue !== oldValue) {
                            $scope.to.loading = DemoData[action](provider.id, $scope.model.engine, newValue).then(handleResults, handleError);
                        }
                    });
                    $scope.to.loading = DemoData[action](provider.id, 'none', 'none').then(handleResults, handleError);
                    break;
                default:
                    $scope.to.loading = DemoData[action](provider.id).then(handleResults, handleError);
            }

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