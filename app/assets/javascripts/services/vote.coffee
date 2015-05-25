angular.module('BornApp').service 'Vote', ($http, Rails) ->
  base = "/api/propositions/"

  vote: (proposition) ->
    $http.post("#{base}/#{proposition.id}/vote")
  unvote: (proposition, vote) ->
    $http.delete("#{base}/#{proposition.id}/vote/#{vote.id}")
