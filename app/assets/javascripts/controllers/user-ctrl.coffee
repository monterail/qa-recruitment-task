angular.module('BornApp').controller 'UserCtrl', ($scope, User, current_user) ->
  $scope.user = current_user.data

  $scope.update = ->
    User.update($scope.user)
