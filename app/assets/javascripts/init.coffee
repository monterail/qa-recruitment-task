app = angular.module 'BornApp', ['ui.router']

app.config ($locationProvider) ->
  $locationProvider.html5Mode false

app.config ($provide, $httpProvider, Rails, $injector) ->
  $provide.factory 'railsAssetsInterceptor', ->
    request: (config) ->
      if assetUrl = Rails.templates[config.url]
        config.url = assetUrl

      config

  $provide.factory 'errorInterceptor', ($q, $rootScope) ->
    responseError : (rejection) ->
      if(rejection.status == 500)
        $rootScope.$broadcast("userUpdateError", { message: "Server Error. Please try again" })
      $q.reject(rejection)

  $httpProvider.interceptors.push 'errorInterceptor'
