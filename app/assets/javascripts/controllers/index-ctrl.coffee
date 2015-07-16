angular.module('BornApp').controller 'IndexCtrl', ($scope, users, currentUser, User) ->
  $scope.currentUser = currentUser.data
  $scope.users = users.data

  User.withoutBirthday().success (users) ->
    $scope.usersWithoutBirthday = users
