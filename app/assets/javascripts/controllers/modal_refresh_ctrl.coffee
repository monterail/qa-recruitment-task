angular.module('BornApp').controller 'ModalRefreshCtrl', ($scope, $modalInstance, $window) ->

  $scope.ok = ->
    $window.location.reload()
    $modalInstance.close()

  $scope.cancel = ->
    $modalInstance.dismiss 'cancel'
