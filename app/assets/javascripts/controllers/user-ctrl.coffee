angular.module('BornApp').controller 'UserCtrl', ($scope, User, user) ->
  $scope.user = user.data
  
  $scope.update =  ->
    User.update($scope.user)
