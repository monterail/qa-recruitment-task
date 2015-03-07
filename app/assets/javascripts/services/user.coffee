angular.module('BornApp').service 'User', ($http, Rails) ->
  base = '//#{Rails.host}/api/v1/users'

  index: ->
    $http.get(base)
  update: (user) ->
    $http.put('#{base}/#{user.id}', user: user)
  show: (id) ->
    $http.get('#{base}/#{id}')
