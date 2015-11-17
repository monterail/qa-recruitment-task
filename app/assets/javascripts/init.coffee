app = angular.module 'BornApp', ['ui.router', 'ngAnimate', 'ui.bootstrap']

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

  $provide.factory 'errorInterceptor', ($injector, $q, errorHandler) ->
    $modal = undefined

    responseError : (rejection) ->
      if rejection.status is 500
        errorHandler.occur("Server Error. Please try again")

      if rejection.status is 401
        $modal = $injector.get("$modal")
        $modal.open
          animation: true
          size: "sm"
          controller: "ModalRefreshCtrl"
          templateUrl: "refresh.html"

      $q.reject(rejection)


  $httpProvider.interceptors.push 'railsAssetsInterceptor'
  $httpProvider.interceptors.push 'errorInterceptor'

