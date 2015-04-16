angular.module('BornApp').service 'User', ($http, Rails) ->
  base = "/api/users"

  index: ->
    $http.get(base)
  update: (user) ->
    $http.put("#{base}/me", user: user)
  me: ->
    $http.get("#{base}/me")
