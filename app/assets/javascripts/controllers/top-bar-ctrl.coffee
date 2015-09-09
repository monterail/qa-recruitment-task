angular.module('BornApp').controller 'TopBarCtrl', ($scope, currentUser, Rails) ->
  $scope.currentUser = currentUser.data

  $scope.logout_url = Rails.logout_url
  $scope.authentic_url = Rails.authentic_url
  $scope.vacations_url = Rails.vacations_url
  $scope.eating_url = Rails.eating_url
