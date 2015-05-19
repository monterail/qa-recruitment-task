angular.module('BornApp').controller 'PropositionCtrl', ($scope, Proposition) ->
  $scope.editPropositionId = null
  $scope.hasVoted = (proposition) ->
    console.log($scope.getVote(proposition))
    if $scope.getVote(proposition) != null
      return true
    else
      return false

  $scope.editProposition = (id) ->
    $scope.editPropositionId = id

  $scope.cancelEditProposition = ->
    $scope.editPropositionId = null

  $scope.createProposition = ->
    Proposition.create($scope.newProposition).success (response) ->
      $scope.celebrant.propositions.current.push response
      $scope.newProposition = {}

  $scope.updateProposition = (proposition) ->
    Proposition.update(proposition).success (updatedProposition) ->
      index = $scope.celebrant.propositions.current.indexOf(proposition)
      $scope.celebrant.propositions.current.splice(index, 1, updatedProposition)
      $scope.editPropositionId = null

  $scope.chooseProposition = (proposition) ->
    Proposition.choose(proposition).success (updatedProposition) ->
      index = $scope.celebrant.propositions.current.indexOf(proposition)
      $scope.celebrant.propositions.current.splice(index, 1)
      $scope.celebrant.propositions.chosen.push updatedProposition

  $scope.vote = (proposition) ->
    Proposition.vote(proposition).success (response) ->
      proposition.rating += 1
      $scope.hasVoted(proposition)

  $scope.unvote = (proposition) ->
    Proposition.unvote(proposition, $scope.getVote(proposition)).success (response) ->
      proposition.rating -= 1
      $scope.hasVoted(proposition)

  $scope.getVote = (proposition) ->
    for vote in proposition.votes
      return vote.id if vote.user_id == $scope.currentUser.id
    return null
