angular.module('BornApp').config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'

  $stateProvider
    .state 'auth',
      url: '',
      abstract: true,
      resolve:
        current_user: (User) ->
          User.edit()
      template: '<ui-view/>'

    .state 'auth.index',
      url: '/',
      controller: 'BirthdaysCtrl'
      resolve:
        users: (User) ->
          User.index()
      templateUrl: '/assets/index.html'

    .state 'auth.user',
      url: '/user/:id'
      controller: 'UserCtrl'
      templateUrl: '/assets/user.html'
