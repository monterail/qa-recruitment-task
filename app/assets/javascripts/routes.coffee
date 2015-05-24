angular.module('BornApp').config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'

  $stateProvider
    .state 'auth',
      url: '',
      abstract: true,
      controller: 'TopBarCtrl'
      resolve:
        currentUser: (User, CurrentUser) ->
          User.me().then (response) ->
            CurrentUser.set(response)
            response
      templateUrl: '/assets/topbar.html'

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
      url: '/user/:id'
      controller: 'UserCtrl'
      resolve:
        celebrant: ($stateParams, User) ->
          User.show($stateParams.id)
      templateUrl: '/assets/user.html'

