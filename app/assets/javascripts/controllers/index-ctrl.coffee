angular.module('BornApp').controller 'IndexCtrl', ($scope, users, current_user) ->
  $scope.current_user = current_user.data
  $scope.users = users.data
