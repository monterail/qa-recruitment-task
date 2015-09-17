require 'raven'

Raven.configure do |config|
 config.tags = { environment: Rails.env }
 config.current_environment = Rails.env
end
