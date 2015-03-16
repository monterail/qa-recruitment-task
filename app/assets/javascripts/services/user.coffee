angular.module('BornApp').service 'User', ($http, Rails) ->
  base = "/api/users"

  index: ->
    $http.get(base)
  update: (user) ->
    $http.put("#{base}/#{user.id}", user: user)
  show: (id) ->
    $http.get("#{base}/#{id}")
