angular.module('BornApp').directive 'vote', (CurrentUser, Proposition)->
  restrict: 'A'
  templateUrl: 'vote.html'
  scope:
    proposition: '=vote'
  controller: ($scope) ->
    currentUser = CurrentUser.get()

    $scope.vote = (proposition) ->
      Proposition.vote(proposition).success (response) ->
        proposition.rating += 1
        proposition.votes.push response
        $scope.hasCurrentUserVoted = true

    $scope.unvote = (proposition) ->
      Proposition.unvote(proposition, $scope.getCurrentUserVote(proposition)).success (response) ->
        proposition.rating -= 1
        index = proposition.votes.indexOf($scope.getCurrentUserVote(proposition))
        proposition.votes.splice(index, 1)
        $scope.hasCurrentUserVoted = false

    $scope.getCurrentUserVote = (proposition) ->
      for vote in proposition?.votes
        return vote if vote.user_id == currentUser.id
      null

    $scope.hasCurrentUserVoted = $scope.getCurrentUserVote($scope.proposition)?
