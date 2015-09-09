angular.module('BornApp').controller 'PropositionCtrl', ($scope, Proposition) ->
  $scope.editPropositionId = null

  $scope.resetFieldTouched = (form) ->
    form.$setUntouched()

  $scope.editProposition = (id) ->
    $scope.editPropositionId = id

  $scope.isPropositionEmpty = ->
    $scope.celebrant.propositions.chosen.length <= 0

  $scope.cancelEditProposition = ->
    $scope.editPropositionId = null

  $scope.createProposition = ->
    Proposition.create($scope.newProposition)
    .success (response) ->
      $scope.celebrant.propositions.current.push response
      $scope.newProposition = {}

  $scope.updateProposition = (proposition) ->
    Proposition.update(proposition)
    .success (updatedProposition) ->
      index = $scope.celebrant.propositions.current.indexOf(proposition)
      $scope.celebrant.propositions.current.splice(index, 1, updatedProposition)
      $scope.editPropositionId = null

  $scope.deleteProposition = (proposition) ->
    Proposition.destroy(proposition).success (response) ->
      index = $scope.celebrant.propositions.current.indexOf(proposition)
      $scope.celebrant.propositions.current.splice(index, 1)

  $scope.deleteProposition = (proposition) ->
    Proposition.destroy(proposition).success (response) ->
      index = $scope.celebrant.propositions.current.indexOf(proposition)
      $scope.celebrant.propositions.current.splice(index, 1)

  $scope.chooseProposition = (proposition) ->
    Proposition.choose(proposition)
    .success (updatedProposition) ->
      index = $scope.celebrant.propositions.current.indexOf(proposition)
      $scope.celebrant.propositions.current.splice(index, 1)
      $scope.celebrant.propositions.chosen.push updatedProposition

  $scope.unchooseProposition = (proposition) ->
    Proposition.unchoose(proposition)
    .success (updatedProposition) ->
      index = $scope.celebrant.propositions.chosen.indexOf(proposition)
      $scope.celebrant.propositions.current.push updatedProposition
      $scope.celebrant.propositions.chosen.splice(index, 1)
