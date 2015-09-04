angular.module('BornApp').directive 'errorNotify', ($rootScope)->
  restrict: 'A'
  templateUrl: 'notification.html'
  link: ($scope) ->
    $scope.closeMessage =  ->
      $scope.showMessage = false

    $rootScope.$on "userUpdateError", (event, args) ->
      $scope.showMessage = true
      $scope.message = args.message

