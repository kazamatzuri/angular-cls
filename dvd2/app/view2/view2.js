'use strict';

angular.module('myApp.view2', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/view2', {
    templateUrl: 'view2/view2.html',
    controller: 'View2Ctrl'
  });
}])

.controller('View2Ctrl',['$scope','StoreFactory',function($scope,StoreFactory) {
	//$scope.items = [];
    $scope.Stores;
    getStores();

    function getStores() {
        StoreFactory.getStores()
            .then(function (response) {
                $scope.stores = response.data.children;
            }, function (error) {
                $scope.status = 'Unable to load DVD data: ' + error.message;
            });
    }

}]);