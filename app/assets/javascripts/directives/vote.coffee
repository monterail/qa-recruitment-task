angular.module('BornApp').directive 'vote', (CurrentUser, Proposition)->
  restrict: 'A'
  templateUrl: 'vote.html'
  $scope: {
    proposition: '=vote'
  }
  controller: ($scope) ->
    currentUser = CurrentUser.get()
   
    $scope.vote = (proposition) ->
      Proposition.vote(proposition).success (response) ->
        proposition.rating += 1
        $scope.hasVoted = true

    $scope.unvote = (proposition) ->
      Proposition.unvote(proposition, $scope.getVote(proposition)).success (response) ->
        proposition.rating -= 1
        $scope.hasVoted = false

    $scope.getVote = (proposition) ->
      for vote in proposition.votes
        return vote.id if vote.user_id == currentUser.id
      null

    $scope.hasVoted = $scope.getVote($scope.proposition) != null ? true : false
