angular.module('BornApp').controller 'IndexCtrl', ($scope, UsersList, users, currentUser, User) ->
  $scope.currentUser = currentUser.data
  $scope.users = users.data

  usersGroups = UsersList.todayBirthdays($scope.users)
  $scope.todayBirthdays = usersGroups[0]
  $scope.nextBirthdays = usersGroups[1]

  MONTHNAMES = [
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
    .groupBy((user) -> MONTHNAMES[user.birthday_month])
    .pairs()
    .value()

  $scope.selectMonth = (month) ->
    if $scope.activeMonth == month
      $scope.activeMonth = null
    else
      $scope.activeMonth = month

  User.withoutBirthday().success (users) ->
    $scope.usersWithoutBirthday = users

  $scope.isCurrentUser = (user) ->
    user.id == currentUser.data.id
