angular.module('BornApp').controller 'MeCtrl', ($scope, currentUser, User) ->
  $scope.user = currentUser.data

  $scope.update = ->
    User.updateMe($scope.user)
