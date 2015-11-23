app = angular.module 'BornApp', ['ui.router', 'ngAnimate']

app.config ($locationProvider) ->
  $locationProvider.html5Mode false

app.config ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = angular.element(document.querySelector('meta[name=csrf-token]')).attr('content')

app.config ($provide, $httpProvider, Rails) ->
  $provide.factory 'railsAssetsInterceptor', ->
    request: (config) ->
      if assetUrl = Rails.templates[config.url]
        config.url = assetUrl

      config

  $provide.factory 'errorInterceptor', ($q, errorHandler) ->
    responseError : (rejection) ->
      if(rejection.status == 500)
        errorHandler.occur("Server Error. Please try again")
      $q.reject(rejection)

  $httpProvider.interceptors.push 'railsAssetsInterceptor'
  $httpProvider.interceptors.push 'errorInterceptor'
