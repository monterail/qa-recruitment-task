angular.module('BornApp').service 'Comment', ($http, Rails) ->
  base = "/api/users"

  create: (comment, proposition) ->
    $http.post("#{base}/#{proposition.jubilat_id}/propositions/#{proposition.id}/comments", comment: comment)
  update: (comment, proposition) ->
    $http.put("#{base}/#{proposition.jubilat_id}/propositions/#{proposition.id}/comments/#{comment.id}", comment: comment)
