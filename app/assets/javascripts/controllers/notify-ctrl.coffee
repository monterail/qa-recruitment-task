angular.module('BornApp').controller 'NotifyCtrl', ($scope, Notification) ->
  $scope.notifications = Notification.all()
  $scope.close = (notification) ->
    Notification.destroy notification
