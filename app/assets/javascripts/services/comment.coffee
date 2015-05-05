angular.module('BornApp').service 'Comment', ($http, Rails) ->
  base = "/api"

  create: (comment, proposition) ->
    $http.post("#{base}/propositions/#{proposition.id}/comments", comment: comment)
  update: (comment, proposition) ->
    $http.put("#{base}/propositions/#{proposition.id}/comments/#{comment.id}", comment: comment)
