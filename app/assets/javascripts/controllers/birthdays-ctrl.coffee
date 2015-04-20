angular.module('BornApp').controller 'BirthdaysCtrl', ($scope, User, users, current_user) ->
  $scope.current_user = current_user.data
  $scope.users = users.data
