angular.module('BornApp').config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'

  $stateProvider
    .state 'auth',
      url: '',
      abstract: true,
      resolve:
        current_user: (User) ->
          User.me()
      template: '<ui-view/>'

    .state 'auth.index',
      url: '/',
      controller: 'IndexCtrl'
      resolve:
        users: (User) ->
          User.index()
      templateUrl: '/assets/index.html'

    .state 'auth.me',
      url: '/user/me'
      controller: 'MeCtrl'
      templateUrl: '/assets/me.html'

    .state 'auth.user',
      url: '/users/:id'
      controller: 'UserCtrl'
      resolve:
        jubilat: ($stateParams, User) ->
          User.show($stateParams.id)
      templateUrl: '/assets/user.html'

