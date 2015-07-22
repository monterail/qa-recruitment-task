.directive 'responseError', (
 $rootScope, $timeout
) ->
  restrict: 'A',
  scope: {}
  templateUrl: 'assets/notification.html'
  link: ($scope, $elem, $attrs) ->
  $scope.message = $attrs('message')
    $scope.$on 'response', (e, params) ->


