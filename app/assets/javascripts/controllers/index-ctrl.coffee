angular.module('BornApp').controller 'IndexCtrl', ($scope, UsersList, users, currentUser) ->
  $scope.currentUser = currentUser.data
  $scope.users = users.data

  usersGroups = UsersList.todayBirthdays($scope.users)
  $scope.todayBirthdays = usersGroups[0]
  $scope.nextBirthdays = usersGroups[1]
