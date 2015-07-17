angular.module('BornApp').controller 'PropositionCtrl', ($scope, Proposition) ->
  $scope.editPropositionId = null

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

  $scope.backProposition = (proposition) ->
    Proposition.choose(proposition).success (updatedProposition) ->
      index = $scope.celebrant.propositions.current.indexOf(proposition)
      $scope.celebrant.propositions.current.push updatedProposition
      $scope.celebrant.propositions.chosen.splice(index, 1)

