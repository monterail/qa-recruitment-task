app = angular.module 'BornApp', ['ui.router']

app.config ($locationProvider) ->
  $locationProvider.html5Mode false

app.config ($provide, $httpProvider, Rails) ->
  $provide.factory 'railsAssetsInterceptor', ->
    request: (config) ->
      if assetUrl = Rails.templates[config.url]
        config.url = assetUrl

      config

  $httpProvider.interceptors.push 'railsAssetsInterceptor'
