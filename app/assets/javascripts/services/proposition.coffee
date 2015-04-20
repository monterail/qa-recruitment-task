angular.module('BornApp').service 'Proposition', ($http, Rails) ->
  base = "/api/users"

  index: (user_id) ->
    $http.get("#{base}/#{user_id}/propositions")
  create: (proposition) ->
    $http.post("#{base}/#{proposition.jubilat_id}/propositions", proposition: proposition)
  update: (proposition) ->
    $http.put("#{base}/#{proposition.jubilat_id}/propositions/#{proposition.id}", proposition: proposition)
