angular.module('BornApp').service 'UsersList', ->

  todayBirthdays: (users) ->
    actualDate = new Date
    arrayToReturn = _.partition users, (user) ->
     user.birthday_day == actualDate.getDate() && user.birthday_month == actualDate.getMonth() + 1
