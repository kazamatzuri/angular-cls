'use strict';

angular.module('myApp.sales', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/sales', {
    templateUrl: 'sales/sales.html',
    controller: 'SalesCtrl'
  });
}])

.controller('SalesCtrl', ['$scope','SaleFactory','EmployeeFactory',function($scope,SaleFactory,EmployeeFactory) {
	//$scope.items = [];
    $scope.Sales;
    getSales();

    function getSales() {
        SaleFactory.getSales()
            .then(function (response) {
                $scope.Sales = response.data.children;
            }, function (error) {
                $scope.status = 'Unable to load DVD data: ' + error.message;
            });
    }

}]);    