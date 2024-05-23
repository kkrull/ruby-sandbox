When(/^I use a cucumber helper module$/) do
  @help = help_from_cucumber_module
end

When(/^I use a rspec helper module$/) do
  @help = help_from_shared_module
end

Then(/^help should be available$/) do
  expect(@help).to be(:available)
end
