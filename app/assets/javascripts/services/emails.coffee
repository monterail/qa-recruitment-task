angular.module('BornApp').service 'Emails', ($http) ->
  base = "api/users"

  send: (user, subject, content) ->
      $http.post("#{base}/#{user.id}/emails", user: user, subject: subject, content: content)


