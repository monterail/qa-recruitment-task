angular.module('BornApp').controller 'PropositionCtrl', ($scope, Proposition) ->
  $scope.editPropositionId = null
  $scope.editProposition = (id) ->
    $scope.editPropositionId = id

  $scope.cancelEditProposition = ->
    $scope.editPropositionId = null

  $scope.create = ->
    Proposition.create($scope.newProposition).success (response) ->
      $scope.jubilat.propositions.current.push response
      $scope.newProposition = {}

  $scope.updateProposition = (proposition) ->
    Proposition.update(proposition).success (updatedProposition) ->
      index = $scope.jubilat.propositions.current.indexOf(proposition)
      $scope.jubilat.propositions.current.splice(index, 1, updatedProposition)
      $scope.editPropositionId = null

  $scope.chooseProposition = (proposition) ->
    proposition.year_chosen_in = new Date().getFullYear()
    Proposition.update(proposition).success (updatedProposition) ->
      index = $scope.jubilat.propositions.current.indexOf(proposition)
      $scope.jubilat.propositions.current.splice(index, 1)
      $scope.jubilat.propositions.chosen.push updatedProposition
