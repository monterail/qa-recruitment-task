angular.module('BornApp').service 'Birthday', ($http, Rails) ->
  base = "/api/birthdays"

  markAsCovered: (celebrant_id) ->
      $http.patch("#{base}/#{celebrant_id}/cover")
  markAsUncovered: (celebrant_id) ->
      $http.patch("#{base}/#{celebrant_id}/uncover")
