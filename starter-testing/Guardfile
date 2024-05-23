notification :tmux, 
  color_location: 'status-left-bg',
  default_message_format: '%s >> %s',
  display_message: true, 
  line_separator: ' > ',
  timeout: 5

guard :rspec, cmd: 'script/rspec' do
  watch('.rspec') { 'spec' }
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" || 'spec' }
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb') { 'spec' }
  watch(%r{^test/support/.+$}) { 'spec' }
end

guard 'cucumber', cmd: 'script/cucumber' do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$}) { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
  watch(%r{^test/support/.+$}) { 'features' }
end
