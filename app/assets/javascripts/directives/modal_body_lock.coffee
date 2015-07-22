angular.module('BornApp').directive 'modalBodyLock', ($rootScope, $state) ->
  restrict: "A"
  link: (scope, elem, attrs) ->
    $rootScope.$on '$stateChangeSuccess', (e, state) ->
      if $state.current.data?.modal
        elem.addClass("modal-open")
      else
        elem.removeClass("modal-open")
