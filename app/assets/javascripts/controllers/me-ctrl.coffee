angular.module('BornApp').controller 'MeCtrl', ($scope, User, current_user) ->
  $scope.user = current_user.data

  $scope.update = ->
    User.update_me($scope.user)
