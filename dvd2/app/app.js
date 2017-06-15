'use strict';



// Declare app level module which depends on views, and components
angular.module('myApp', [
	'ngRoute',
	'ngCookies',
	//'Authentication',
	'myApp.view1',
	'myApp.view2',
	'myApp.sales',
	'myApp.employees',
	'myApp.stock',
	//'myApp.login',
	'myApp.version'
	]).
config(['$locationProvider', '$routeProvider', function($locationProvider, $routeProvider) {
	$locationProvider.hashPrefix('!');

	$routeProvider.otherwise({redirectTo: '/view1'});
}]).
factory('DVDFactory', ['$http', function($http) {

	var urlBase = '/csp/dvd/api/dvds';
	var DVDFactory = {};

	DVDFactory.getDVDs = function () {
		return $http.get(urlBase);
	};

	DVDFactory.getDVD = function (id) {
		return $http.get(urlBase + '/' + id);
	};

	DVDFactory.insertDVD = function (cust) {
		return $http.post(urlBase, cust);
	};

	DVDFactory.updateDVD = function (cust) {
		return $http.put(urlBase + '/' + cust.ID, cust)
	};

	DVDFactory.deleteDVD = function (id) {
		return $http.delete(urlBase + '/' + id);
	};

	return DVDFactory;
}]).
factory('StoreFactory', ['$http', function($http) {

	var urlBase = '/csp/dvd/api/stores';
	var StoreFactory = {};

	StoreFactory.getStores = function () {
		return $http.get(urlBase);
	};

	StoreFactory.getStore = function (id) {
		return $http.get(urlBase + '/' + id);
	};

	return StoreFactory;
}])
.factory('SaleFactory', ['$http', function($http) {

	var urlBase = '/csp/dvd/api/sales';
	var SaleFactory = {};

	SaleFactory.getSales = function () {
		return $http.get(urlBase);
	};

	SaleFactory.getSale = function (id) {
		return $http.get(urlBase + '/' + id);
	};

	return SaleFactory;
}])
.factory('EmployeeFactory', ['$http', function($http) {

	var urlBase = '/csp/dvd/api/employees';
	var EmployeeFactory = {};

	EmployeeFactory.getEmployees = function () {
		return $http.get(urlBase);
	};

	EmployeeFactory.getEmployee = function (id) {
		return $http.get(urlBase + '/' + id);
	};
	
	EmployeeFactory.deleteEmployee = function (id) {
		return $http.delete(urlBase + '/' + id);
	};


	return EmployeeFactory;
}])
.factory('StockFactory', ['$http', function($http) {

	var urlBase = '/csp/dvd/api/stock';
	var StockFactory = {};

	StockFactory.getStock = function (id) {
		return $http.get(urlBase + '/' + id);
	};
	

	return StockFactory;
}])
;



