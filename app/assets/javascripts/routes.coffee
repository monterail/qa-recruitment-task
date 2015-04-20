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
      controller: 'BirthdaysCtrl'
      resolve:
        users: (User) ->
          User.index()
      templateUrl: '/assets/index.html'

    .state 'auth.user',
      url: '/user/:id'
      controller: 'UserCtrl'
      templateUrl: '/assets/user.html'

    .state 'birthday',
      url: '/users/:id'
      controller: 'BirthdayCtrl'
      resolve:
        propositions: ($stateParams, Proposition) ->
          Proposition.index($stateParams.id)
        jubilat: ($stateParams, User) ->
          User.show($stateParams.id)
      templateUrl: '/assets/birthday.html'

