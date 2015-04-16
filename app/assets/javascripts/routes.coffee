angular.module('BornApp').config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'

  $stateProvider
    .state 'index',
      url: '/',
      controller: 'BirthdaysCtrl'
      resolve:
        users: (User) ->
          User.index()
      templateUrl: '/assets/index.html'

    .state 'user',
      url: '/user/:id'
      controller: 'UserCtrl'
      resolve:
        user: ($stateParams, User) ->
          User.edit($stateParams.id)
      templateUrl: '/assets/user.html'
