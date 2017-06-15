'use strict';

angular.module('myApp.employees', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/employees', {
    templateUrl: 'employees/employees.html',
    controller: 'EmployeeCtrl'
  });
}])

.controller('EmployeeCtrl', ['$scope','EmployeeFactory',function($scope,EmployeeFactory) {
	//$scope.items = [];
    $scope.Employees;
    getEmployees();

    function getEmployees() {
        EmployeeFactory.getEmployees()
            .then(function (response) {
                $scope.Employees = response.data.children;
            }, function (error) {
                $scope.status = 'Unable to load Employee data: ' + error.message;
            });
    }

}]);    