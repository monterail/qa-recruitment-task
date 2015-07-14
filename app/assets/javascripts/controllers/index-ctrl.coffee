angular.module('BornApp').controller 'IndexCtrl', ($scope, users, currentUser, User) ->
  $scope.currentUser = currentUser.data
  $scope.users = users.data

  User.usersWithoutBirthday().then (users) ->
    $scope.usersWithoutBirthdays = users.data
