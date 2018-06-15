'use strict';

angular.module('myApp.employees', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/employees', {
    templateUrl: 'employees/employees.html',
    controller: 'EmployeeCtrl'
  });
}])

.controller('EmployeeCtrl', ['$scope','EmployeeFactory',function($scope,EmployeeFactory) {
    $scope.Employees;
    $scope.fireEmployee=fireEmployee;

    getEmployees();


    function getEmployees() {
        EmployeeFactory.getEmployees()
            .then(function (response) {
                $scope.Employees = response.data.children;
            }, function (error) {
                $scope.status = 'Unable to load Employee data: ' + error.message;
            });
    }

    function fireEmployee(id) {
      console.log("callback deleting "+id);
      EmployeeFactory.deleteEmployee(id)
          .then(function (response) {

              //nothing to do
          }, function (error) {
              $scope.status = 'Unable to fire Employee: ' + error.data;
          });   }

}]);
