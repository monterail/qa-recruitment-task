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
      templateUrl: 'topbar.html'

    .state 'auth.index',
      url: '/',
      controller: 'IndexCtrl'
      resolve:
        users: (User) ->
          User.index()
      templateUrl: 'index.html'

    .state 'auth.me',
      url: '/user/me'
      controller: 'MeCtrl'
      templateUrl: 'me.html'

    .state 'auth.wrongmaybe',
      url: '/authentic'
      controller: 'MeCtrl'
      templateUrl: 'nope.html'

    .state 'auth.user',
      url: '/user/:id'
      controller: 'UserCtrl'
      resolve:
        celebrant: ($stateParams, User) ->
          User.show($stateParams.id)
      templateUrl: 'user.html'

    .state 'auth.user.userModal',
      url: '/modal'
      templateUrl: 'mail_modal.html'
      controller: 'ModalCtrl'
      data:
        modal: true
