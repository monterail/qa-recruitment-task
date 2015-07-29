angular.module('BornApp').controller 'ModalCtrl', ($scope, currentUser, Emails) ->
  $scope.user = currentUser.data

  $scope.sendEmail = (subject, content) ->
    $scope.sending = true
    Emails.send($scope.user, subject, content).success ->
      $scope.sending = false
