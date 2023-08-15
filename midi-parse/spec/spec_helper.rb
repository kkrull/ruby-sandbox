#https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # rspec-expectations
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks
  config.mock_with :rspec do |mocks|
    #Avoid mocking or stubbing a non-existant method
    mocks.verify_partial_doubles = true
  end

  # RSpec4 forward compatibility for how shared context works
  config.shared_context_metadata_behavior = :apply_to_host_groups

  begin
    # Enable focusing via :focus metadata, fit, fdescribe, fcontext
    config.filter_run_when_matching :focus

    # Enable --only-failures and --next-failure by storing state
    config.example_status_persistence_file_path = "spec/cli-state-examples.txt"

    # Disallow monkey-patch syntax
    # https://rspec.info/features/3-12/rspec-core/configuration/zero-monkey-patching-mode/
    config.disable_monkey_patching!

    # Enable warnings
    config.warnings = true

    # Verbose output when focused on one spec file, unless formatter already given
    if config.files_to_run.one?
      config.default_formatter = "doc"
    end

    # Print the 10 slowest examples
    config.profile_examples = 10

    # Order randomly, unless using --seed to order deterministically for Heisenbugs)
    config.order = :random
    Kernel.srand config.seed
  end
end
