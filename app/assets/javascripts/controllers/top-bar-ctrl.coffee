angular.module('BornApp').controller 'TopBarCtrl', ($scope, currentUser, Rails) ->
  $scope.currentUser = currentUser.data

  $scope.logout_url = Rails.logout_url
