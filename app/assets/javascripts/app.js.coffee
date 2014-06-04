BookApp = angular.module("BookApp", [])

BookApp.controller("BooksCtrl", ["$scope", "$http", ($scope, $http) ->
	console.log "inside of the controller"
	$scope.books = []

	$http.get("/books.json").success (data)->
		$scope.books = data

	])