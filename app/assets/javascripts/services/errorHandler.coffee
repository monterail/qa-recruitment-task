angular.module('BornApp').factory 'errorHandler', ($rootScope) ->
  occur: ->
    $rootScope.$broadcast("userUpdateError", { message: "Server Error. Please try again" })
