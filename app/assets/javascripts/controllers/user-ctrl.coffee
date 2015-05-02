angular.module('BornApp').controller 'UserCtrl', ($scope, User, Proposition, Comment, jubilat, current_user) ->
  $scope.current_user = current_user.data
  $scope.jubilat = jubilat.data
  $scope.newProposition = {}
  $scope.newProposition.jubilat_id = $scope.jubilat.id
  $scope.editCommentId = null
  $scope.editPropositionId = null
  $scope.editingAbout = null

  $scope.editAbout = ->
    $scope.editingAbout = true

  $scope.updateAbout = ->
    User.update($scope.jubilat).success (user) ->
      $scope.jubilat.about = user.about
      $scope.editingAbout = false

  $scope.updateIfDone = ->
    User.update($scope.jubilat).success (user) ->
      $scope.jubilat.done = user.done

  $scope.cancelEditingAbout = ->
    $scope.editingAbout = false

  $scope.editComment = (comment) ->
    $scope.editCommentId = comment.id if $scope.current_user.id == comment.owner.id

  $scope.cancelEditComment = ->
    $scope.editCommentId = null

  $scope.editProposition = (id) ->
    $scope.editPropositionId = id

  $scope.cancelEditProposition = ->
    $scope.editPropositionId = null

  $scope.create = ->
    Proposition.create($scope.newProposition).success (response) ->
      $scope.jubilat.propositions.current.push response
      $scope.newProposition = {}

  for proposition in $scope.jubilat.propositions.current
    proposition.newComment = null

  $scope.comment = (proposition) ->
    Comment.create(proposition.newComment, proposition).success (comment) ->
      comment.owner = current_user.data
      proposition.comments.push comment
      proposition.newComment = {}

  $scope.updateComment = (comment, proposition) ->
    Comment.update(comment, proposition).success (updatedComment) ->
      index = proposition.comments.indexOf(comment)
      proposition.comments.splice(index, 1, updatedComment)
      $scope.editCommentId = null

  $scope.updateProposition = (proposition) ->
    Proposition.update(proposition).success (updatedProposition) ->
      index = $scope.jubilat.propositions.current.indexOf(proposition)
      $scope.jubilat.propositions.current.splice(index, 1, updatedProposition)
      $scope.editPropositionId = null

  $scope.chooseProposition = (proposition) ->
    proposition.year_chosen_in = new Date().getFullYear()
    console.log(new Date().getFullYear())
    Proposition.update(proposition).success (updatedProposition) ->
      index = $scope.jubilat.propositions.current.indexOf(proposition)
      $scope.jubilat.propositions.current.splice(index, 1)
      $scope.jubilat.propositions.chosen.push updatedProposition
