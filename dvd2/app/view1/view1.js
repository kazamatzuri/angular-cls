'use strict';

angular.module('myApp.view1', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/view1', {
    templateUrl: 'view1/view1.html',
    controller: 'View1Ctrl'
  });
}])

.controller('View1Ctrl', ['$scope','DVDFactory',function($scope,DVDFactory) {
	//$scope.items = [];
    $scope.DVDS;
    getDVDs();

    function getDVDs() {
        DVDFactory.getDVDs()
            .then(function (response) {
                $scope.DVDS = response.data.children;
            }, function (error) {
                $scope.status = 'Unable to load DVD data: ' + error.message;
            });
    }

}]);    