angular.module('BornApp').filter 'nextBirthdays', ->
  (persons) ->
    actualDate = new Date()
    arrayToReturn = []
    i = 0
    while i < persons.length
      if persons[i].birthday_day != actualDate.getDate() and persons[i].birthday_month != actualDate.getMonth()+1
        arrayToReturn.push persons[i]
      i++
    return arrayToReturn
