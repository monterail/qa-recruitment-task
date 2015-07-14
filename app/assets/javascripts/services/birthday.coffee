angular.module('BornApp').service 'Birthday', ($http, Rails) ->
  base = "/api/birthdays"

  markAsCovered: (celebrant_id) ->
      $http.patch("#{base}/#{celebrant_id}/covered")
  markAsUncovered: (celebrant_id) ->
      $http.patch("#{base}/#{celebrant_id}/uncovered")
