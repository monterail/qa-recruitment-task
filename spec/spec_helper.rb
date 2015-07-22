RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each, :type => :controller) do
    RailsSso.test_mode = true
    default_user = {
      name: 'John Blacksmith',
      email: 'john.blacksmith@example.com',
      uid: '169783'
    }
    auth_as(default_user)
  end
end
