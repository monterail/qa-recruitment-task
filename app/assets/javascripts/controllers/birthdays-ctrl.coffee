angular.module('BornApp').controller 'BirthdaysCtrl', ($scope, User, users) ->
  $scope.users = users.data
