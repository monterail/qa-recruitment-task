require 'raven'

Raven.configure do |config|
 config.dsn = ENVied.RAVEN_DSN
 config.tags = { environment: Rails.env }
 config.current_environment = Rails.env
end
