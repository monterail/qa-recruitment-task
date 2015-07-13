angular.module('BornApp').controller 'IndexCtrl', ($scope, users, currentUser, User) ->
  $scope.currentUser = currentUser.data
  $scope.users = users.data

  todayBirthdays = (boolean) ->
    arrayToReturn = _.partition $scope.users, (user) ->
      actualDate = new Date
      return user.birthday_day == actualDate.getDate() and user.birthday_month == actualDate.getMonth() + 1
    if boolean then arrayToReturn[0] else arrayToReturn[1]

  $scope.todayBirthdays = todayBirthdays(true)
  $scope.nextBirthdays = todayBirthdays(false)
