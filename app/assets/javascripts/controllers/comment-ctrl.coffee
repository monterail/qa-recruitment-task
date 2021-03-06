angular.module('BornApp').controller 'CommentCtrl', ($scope, Comment) ->
  $scope.editCommentId = null

  $scope.editComment = (comment) ->
    $scope.editCommentId = comment.id if $scope.currentUser.id == comment.owner.id

  $scope.cancelEditComment = ->
    $scope.editCommentId = null

  $scope.createComment = (proposition) ->
    Comment.create(proposition.newComment, proposition)
    .success (comment) ->
      $scope.createCommentForm.$setUntouched()
      proposition.comments.push comment
      proposition.newComment = {}

  $scope.updateComment = (comment, proposition) ->
    Comment.update(comment, proposition)
    .success (updatedComment) ->
      index = proposition.comments.indexOf(comment)
      proposition.comments.splice(index, 1, updatedComment)
      $scope.editCommentId = null

  $scope.deleteComment = (comment, proposition) ->
    Comment.destroy(comment, proposition)
    .success (response) ->
      index = proposition.comments.indexOf(comment)
      proposition.comments.splice(index, 1)
