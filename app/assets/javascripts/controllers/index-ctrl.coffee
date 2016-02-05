angular.module('BornApp').controller 'IndexCtrl', ($scope, UsersList, users, currentUser, User) ->
  $scope.currentUser = currentUser.data
  $scope.users = users.data
  usersGroups = UsersList.todayBirthdays($scope.users)
  $scope.todayBirthdays = usersGroups[0]
  $scope.nextBirthdays = usersGroups[1]
  lastOpenMonth = null
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
    .sortBy((user) -> user.birthday_day)
    .sortBy((user) -> user.birthday_month)
    .groupBy((user) -> MONTHNAMES[user.birthday_month])
    .pairs()
    .value()

  $scope.selectMonth = (month, $event) ->
    selectedMonth = angular.element($event.target.nextElementSibling)
    if angular.isUndefined($scope.activeMonth)
      height = selectedMonth[0].childElementCount * selectedMonth[0].lastElementChild.clientHeight
      selectedMonth.css("max-height", height + 'px')
      lastOpenMonth = selectedMonth
      $scope.activeMonth = month
    else if $scope.activeMonth == month
      lastOpenMonth.css("max-height","0px")
      $scope.activeMonth = null
    else
      lastOpenMonth.css("max-height","0px")
      height = selectedMonth[0].childElementCount * selectedMonth[0].lastElementChild.clientHeight
      selectedMonth.css("max-height", height + 'px')
      lastOpenMonth = selectedMonth
      $scope.activeMonth = month

  User.withoutBirthday().success (users) ->
    $scope.usersWithoutBirthday = users

  $scope.isCurrentUser = (user) ->
    user.id == currentUser.data.id
