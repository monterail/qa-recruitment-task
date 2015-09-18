RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each, :type => :controller) do
    RailsSso.config.test_mode = true
    default_user = RailsSso.config.profile_mocks['john_uid']
    auth_as(default_user)
  end
end
