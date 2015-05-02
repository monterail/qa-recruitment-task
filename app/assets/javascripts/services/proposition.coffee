angular.module('BornApp').service 'Proposition', ($http, Rails) ->
  base = "/api/users"

  create: (proposition) ->
    $http.post("#{base}/#{proposition.jubilat_id}/propositions", proposition: proposition)
  update: (proposition) ->
    $http.put("#{base}/#{proposition.jubilat_id}/propositions/#{proposition.id}", proposition: proposition)
