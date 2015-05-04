angular.module('BornApp').controller 'IndexCtrl', ($scope, users, currentUser) ->
  $scope.currentUser = currentUser.data
  $scope.users = users.data
