angular.module('BornApp').controller 'UserCtrl', ($scope, $rootScope, celebrant, currentUser, User, Birthday) ->
  $scope.currentUser = currentUser.data
  $scope.celebrant = celebrant.data
  $scope.newProposition = {
    celebrant_id: $scope.celebrant.id
  }
  $scope.isEditingAbout = false
  $scope.previousAbout = $scope.celebrant.about

  $scope.toggleEditingAbout = ->
    $scope.celebrant.about = $scope.previousAbout
    $scope.isEditingAbout = !$scope.isEditingAbout

  $scope.updateAbout = ->
    User.update($scope.celebrant)
    .success (user) ->
      $scope.celebrant.about = user.about
      $scope.isEditingAbout = false
      $scope.previousAbout = $scope.celebrant.about


  $scope.updateIfCovered = ->
    if $scope.celebrant.covered
      Birthday.markAsCovered($scope.celebrant.id)
    else
      Birthday.markAsUncovered($scope.celebrant.id)
