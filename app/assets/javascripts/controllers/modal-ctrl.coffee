angular.module('BornApp').controller 'ModalCtrl', ($scope, $state, celebrant, Emails, Notification) ->
  $scope.celebrant = celebrant.data

  $scope.sendEmail = ->
    $scope.sending = true
    Emails.send(celebrant.data, $scope.emailSubject, $scope.emailMessage).success ->
      $scope.sending = false
      Notification.create({ message: 'Message has been sent', type: 'success', image: $scope.celebrant.profile_photo, timeout: 3000 })
      $state.go('^')

