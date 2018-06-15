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
    $scope.selection=[];

    getDVDs();
    $scope.toggleSelection = function toggleSelection(dvdid) {
    var idx = $scope.selection.indexOf(dvdid);

    // Is currently selected
    if (idx > -1) {
      $scope.selection.splice(idx, 1);
    }

    // Is newly selected
    else {
      $scope.selection.push(dvdid);
    }
  };
    function getDVDs() {
        DVDFactory.getDVDs()
            .then(function (response) {
                $scope.DVDS = response.data.children;
            }, function (error) {
                $scope.status = 'Unable to load DVD data: ' + error.message;
            });
    }

    $scope.addDvd = function addDvd() {
      DVDFactory.insertDVD($scope.dvd).then(function (response) {
          $scope.status = "saved ok";
          getDVDs();
          $scope.dvd="";
           //nothing to do
       }, function (error) {
         console.log(error);
           $scope.status = 'Unable to save DVD: ' + error.data.text;``
       });
    }

    $scope.deleteDvd = function deleteDvd() {
      DVDFactory.deleteDVD($scope.selection).then(function (response) {
          $scope.status = "deleted";
          getDVDs();
           //nothing to do
       }, function (error) {
         console.log(error);
           $scope.status = 'Unable to delete DVD: ' + error.data.text;``
       });
    }

}]);
