angular.module('BornApp').controller 'IndexCtrl', ($scope, UsersList, users, currentUser) ->
  $scope.currentUser = currentUser.data
  $scope.users = users.data

  usersGroups = UsersList.todayBirthdays($scope.users)
  $scope.todayBirthdays = usersGroups[0]
  $scope.nextBirthdays = usersGroups[1]

  $scope.MONTHNAMES = [
    ""
    "January"
    "February"
    "March"
    "April"
    "May"
    "June"
    "July"
    "August"
    "September"
    "October"
    "November"
    "December"
  ]

  $scope.groupedUsers = _.chain($scope.users)
    .sortBy((user) -> user.birthday_month)
    .groupBy((user) -> $scope.MONTHNAMES[user.birthday_month])
    .pairs()
    .value()
