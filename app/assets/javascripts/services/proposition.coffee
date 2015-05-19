angular.module('BornApp').service 'Proposition', ($http, Rails) ->
  base = "/api/propositions/"

  create: (proposition) ->
    $http.post(base, proposition: proposition)
  update: (proposition) ->
    $http.put("#{base}/#{proposition.id}", proposition: proposition)
  choose: (proposition) ->
    $http.put("#{base}/#{proposition.id}/choose", proposition: proposition)
  vote: (proposition) ->
    $http.post("#{base}/#{proposition.id}/vote")
  unvote: (proposition, vote_id) ->
    $http.delete("#{base}/#{proposition.id}/vote/#{vote_id}")
