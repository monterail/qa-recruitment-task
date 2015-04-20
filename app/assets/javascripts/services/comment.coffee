angular.module('BornApp').service 'Comment', ($http, Rails) ->
  base = "/api/users"

  index: (user_id, proposition_id) ->
    $http.get("#{base}/#{user_id}/propositions/#{proposition_id}/comments")
  create: (comment, proposition) ->
    $http.post("#{base}/#{proposition.jubilat_id}/propositions/#{proposition.id}/comments", comment: comment)
  update: (comment, proposition) ->
    $http.put("#{base}/#{proposition.jubilat_id}/propositions/#{proposition.id}/comments/#{comment.id}", comment: comment)
