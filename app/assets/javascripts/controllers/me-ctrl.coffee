angular.module('BornApp').controller 'MeCtrl', ($scope, $state, $stateParams, currentUser, User, Notification) ->
  $scope.user = currentUser.data

  $scope.update = ->
    User.updateMe($scope.user)
      .success ->
        $state.go("auth.index")
        Notification.create({ message: 'User profile updated', type: 'success', image: $scope.user.profile_photo, timeout: 3000 })
