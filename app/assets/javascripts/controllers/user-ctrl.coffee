angular.module('BornApp').controller 'UserCtrl', ($scope, jubilat, currentUser, User) ->
  $scope.currentUser = currentUser.data
  $scope.jubilat = jubilat.data
  $scope.newProposition = {
    jubilat_id: $scope.jubilat.id
  }
  $scope.isEditingAbout = false

  $scope.toggleEditingAbout = ->
    $scope.isEditingAbout = !$scope.isEditingAbout

  $scope.updateAbout = ->
    User.update($scope.jubilat).success (user) ->
      $scope.jubilat.about = user.about
      $scope.isEditingAbout = false

  $scope.updateIfDone = ->
    User.update($scope.jubilat).success (user) ->
      $scope.jubilat.done = user.done


