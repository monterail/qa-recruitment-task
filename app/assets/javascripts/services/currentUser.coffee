angular.module('BornApp').service 'CurrentUser', ($http, Rails, User) ->
  currentUser = {}

  set: (user) ->
    currentUser = user.data

  get: ->
    currentUser

