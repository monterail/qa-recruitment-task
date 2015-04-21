angular.module('BornApp').controller 'BirthdayCtrl', ($scope, $stateParams, User, Proposition, propositions, Comment, jubilat) ->
  $scope.jubilat = jubilat.data
  $scope.propositions = propositions.data
  $scope.newProposition = {}
  $scope.newProposition.jubilat_id = $stateParams.id
  $scope.newComment = {}
  $scope.editCommentId = null
  $scope.editPropositionId = null
  $scope.personResponsible = null

  User.show($scope.jubilat.person_responsible_id).success (user) ->
    $scope.personResponsible = user

  $scope.editComment = (comment) ->
    $scope.editCommentId = comment.id

  $scope.cancelEditComment = ->
    $scope.editCommentId = null

  $scope.editProposition = (id) ->
    $scope.editPropositionId = id

  $scope.cancelEditProposition = ->
    $scope.editPropositionId = null

  $scope.create = ->
    Proposition.create($scope.newProposition).success (response) ->
      $scope.propositions.push response
      $scope.newProposition = {}

  $scope.getComments = (proposition) ->
    Comment.index($stateParams.id, proposition.id).success (comments) ->
      proposition.comments = comments

  $scope.getComments proposition for proposition in $scope.propositions

  $scope.comment = (comment, proposition) ->
    Comment.create(comment, proposition).success (comment) ->
      proposition.comments.push comment
      $scope.newComment = {}

  $scope.updateComment = (comment, proposition) ->
    Comment.update(comment, proposition).success (updatedComment) ->
      index = proposition.comments.indexOf(comment)
      proposition.comments.splice(index, 1, updatedComment)
      $scope.editCommentId = null

  $scope.updateProposition = (proposition) ->
    Proposition.update(proposition).success (updatedProposition) ->
      index = $scope.propositions.indexOf(proposition)
      $scope.propositions.splice(index, 1, updatedProposition)
      $scope.editPropositionId = null
