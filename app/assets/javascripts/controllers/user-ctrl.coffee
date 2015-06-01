angular.module('BornApp').controller 'UserCtrl', ($scope, celebrant, currentUser, User) ->
  $scope.currentUser = currentUser.data
  $scope.celebrant = celebrant.data
  $scope.newProposition = {
    celebrant_id: $scope.celebrant.id
  }
  $scope.isEditingAbout = false

  $scope.toggleEditingAbout = ->
    $scope.isEditingAbout = !$scope.isEditingAbout

  $scope.updateAbout = ->
    User.update($scope.celebrant).success (user) ->
      $scope.celebrant.about = user.about
      $scope.isEditingAbout = false

  $scope.updateIfDone = ->
    User.update($scope.celebrant)

