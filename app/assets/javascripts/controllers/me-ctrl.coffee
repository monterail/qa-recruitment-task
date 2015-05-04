angular.module('BornApp').controller 'MeCtrl', ($scope, currentUser, User) ->
  $scope.user = currentUser.data

  $scope.update = ->
    User.update_me($scope.user)
