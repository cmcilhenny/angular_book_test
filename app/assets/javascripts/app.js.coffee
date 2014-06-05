BookApp = angular.module("BookApp", [])

BookApp.controller("BooksCtrl", ["$scope", "$http", ($scope, $http) ->
	console.log "inside of the controller"
	$scope.books = []

	$scope.editing = false

	$http.get("/books.json").success (data)->
		$scope.books = data

	$scope.findById = (id) ->
		for book in $scope.books
			if book.id == id
				return book
		return null

	$scope.addBook = ->
		console.log $scope.newBook
		$http.post("/books.json", $scope.newBook).success (data)->
			console.log "BOOK SAVED!!"
			$scope.newBook = {}
			$scope.books.push(data)
	
	$scope.deleteBook = ->
    console.log "delete pushed"
    index = @$index
    console.log @book # @book==this.book (you can use either)
    $http.delete("/books/#{@book.id}.json").success (data) -> #same as "/books/"+@book.id+".json"
    console.log "book deleted"
    $scope.books.splice(this.$index, 1)

  # $scope.editBook = ->
  # 	console.log "edit pushed"
  # 	$scope.value = true
  # 	console.log this.book

  $scope.editBook = (bookId) -> 
  	console.log "editing book #{bookId}"
  	$scope.editing = true
  	$scope.selectedBook = $scope.findById(bookId)

  $scope.updateBook = ->
  	console.log "update pushed"
  	console.log $scope.selectedBook
  	$http.put("/books/#{$scope.selectedBook.id}.json", $scope.selectedBook).success (data)=>
  		console.log "book updated"
  	$scope.selectedBook = null
])

 # below code is needed to get around security tokens to create/update/destroy books
BookApp.config(["$httpProvider", ($httpProvider)->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token').attr('content')
])