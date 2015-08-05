angular.module('BornApp').controller 'ModalCtrl', ($scope, celebrant, Emails) ->

  $scope.sendEmail = ->
    $scope.sending = true
    Emails.send(celebrant.data, $scope.emailSubject, $scope.emailMessage).success ->
      $scope.sending = false
