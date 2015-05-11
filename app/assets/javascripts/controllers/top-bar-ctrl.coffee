angular.module('BornApp').controller 'TopBarCtrl', ($scope, currentUser) ->
  $scope.currentUser = currentUser.data

