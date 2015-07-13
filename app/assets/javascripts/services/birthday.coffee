angular.module('BornApp').service 'Birthday', ($http, Rails) ->
  base = "/api/birthdays"

  markAsDone: (celebrant_id) ->
      $http.patch("#{base}/#{celebrant_id}/mark_as_done")
  markAsUndone: (celebrant_id) ->
      $http.patch("#{base}/#{celebrant_id}/mark_as_undone")
