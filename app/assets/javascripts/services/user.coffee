angular.module('BornApp').service 'User', ($http, Rails) ->
  base = "/api/users"

  index: ->
    $http.get(base)
  withoutBirthday: ->
    $http.get("#{base}/unset")
  show: (id) ->
    $http.get("#{base}/#{id}")
  updateMe: (user) ->
    $http.put("#{base}/me", user: user)
  update: (user) ->
    $http.put("#{base}/#{user.id}", user: user)
  me: ->
    $http.get("#{base}/me")
