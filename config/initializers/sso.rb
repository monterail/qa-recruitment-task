RailsSso.configure do |config|
  # name of oauth2 provider
  config.provider_name = 'hussars'
  # oauth keys for omniauth-example
  config.provider_key = ENV['HUSSARS_KEY']
  config.provider_secret = ENV['HUSSARS_SECRET']
  # path for fetching user data
  config.provider_profile_path = '/api/v1/me'
  # set if you support single sign out
  config.provider_sign_out_path = '/api/v1/me'
  # enable cache (will use Rails.cache store)
  config.use_cache = Rails.application.config.action_controller.perform_caching
end
