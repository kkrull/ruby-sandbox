# Ruby Testing Examples

A sandbox environment showing how to use different features in RSpec and Cucumber, as well as how to make the two work
together.

## RSpec features

RSpec scenarios use a variety of helper modules to DRY up test code in each spec.

- Local to one spec file: `spec/has_internal_help_spec.rb`
- Global among all specs: `spec/includes_external_help_spec.rb`
- Universal between RSpec and Cucumber: `spec/includes_shared_help_spec.rb`

These work by calling `RSpec.configure#include` in `spec/spec_helper.rb` (which is automatically required in `.rspec`)
for each module that you want to be available in all the specs.  Note that `.rspec` also adds `test/` to `$LOAD_PATH` so
that specs can `require 'support/shared_module'`.

Other ways of sharing code among specs have some negative consequences:

- If you open up a production class and add methods to it, those methods are around for good and are now available for
  (accidental) use in production code.  This happens even if your test-specific methods are in a file in `spec/`, due to
  the global way in which `require` works.
- `shared_context` works great for specs, but doesn't do much to help in Cucumber scenarios.

## Cucumber features

Cucumber scenarios also use a variety of helper modules for the same reason as you do in RSpec - to DRY up the code.
For example:

- Cucumber-specific helper modules: `features/support/cucumber_helper.rb`
- Universally shared modules between RSpec and Cucumber: `features/get_help.feature`

Cucumber includes modules into the base World object by calling `World( <module> )`.  In order to require a module, its
path must be reachable from one of the entries in `$LOAD_PATH`.  `features/support/env.rb` does this by calling
`Cucumber::LoadPath.add_dirs` with the shared helper directory (`test/`).

## Guard

Look at `Guardfile` to see the files that can trigger running RSpec tests and Cucumber scenarios.  Note the additional
watch patterns for `test/support`, `.rspec` and `spec/spec_helper.rb`.
