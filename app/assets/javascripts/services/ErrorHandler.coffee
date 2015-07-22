angular.module('BornApp')
.service 'ErrorHandlerService', ( $rootScope ) ->
  response: (options) ->
    if options.action
      $rootScope.$broadcast 'response', options