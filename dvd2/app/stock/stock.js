'use strict';

angular.module('myApp.stock', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/stock', {
    templateUrl: 'stock/stock.html',
    controller: 'stockCtrl'
  });
}])

.controller('stockCtrl', ['$scope','StoreFactory',function($scope,StoreFactory) {
	//$scope.items = [];
    $scope.Stores;
    $scope.Store;
    
    getStores();


    function getStores() {
            StoreFactory.getStores()
            .then(function (response) {
                $scope.Stores = response.data.children;
                $scope.Store=$scope.Stores[0];
            }, function (error) {
                $scope.status = 'Unable to load Store list: ' + error.message;
            });
    }



}])
.controller('invCtl',['$scope','StockFactory',function($scope,StockFactory){
    $scope.Stock;
    getStock();
      $scope.$watch('Store', function() {
        getStock();
    });
    function getStock() {
        if (typeof($scope.Store)!='undefined'){
        StockFactory.getStock($scope.Store.ID)
            .then(function (response) {
                $scope.Stock = response.data.children;
            }, function (error) {
                $scope.status = 'Unable to load inventory data: ' + error.message;
            });
        }
    }

}])
;    