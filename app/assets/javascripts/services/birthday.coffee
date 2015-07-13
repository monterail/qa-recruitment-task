angular.module('BornApp').service 'Birthday', ($http, Rails) ->
  base = "/api/birthdays"

  mark_as_done: (celebrant_id) ->
      $http.patch("#{base}/#{celebrant_id}/mark_as_done")
  mark_as_undone: (celebrant_id) ->
      $http.patch("#{base}/#{celebrant_id}/mark_as_undone")
