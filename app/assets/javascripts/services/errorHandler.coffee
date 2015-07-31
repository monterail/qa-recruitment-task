angular.module('BornApp').factory 'errorHandler', ($rootScope) ->
  occur: (errormessage) ->
    $rootScope.$broadcast("userUpdateError", { message: errormessage })
