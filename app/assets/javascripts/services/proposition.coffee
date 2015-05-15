angular.module('BornApp').service 'Proposition', ($http, Rails) ->
  base = "/api"

  create: (proposition) ->
    $http.post("#{base}/propositions", proposition: proposition)
  update: (proposition) ->
    $http.put("#{base}/propositions/#{proposition.id}", proposition: proposition)
  choose: (proposition) ->
    $http.put("#{base}/propositions/#{proposition.id}/choose", proposition: proposition)
