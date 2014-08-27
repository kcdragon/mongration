guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})           { |m| "spec/unit/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')        { "spec" }
  watch(%r{^spec/support/(.+)\.rb$})  { "spec" }
  watch(%r{^spec/fixtures/(.+)\.rb$}) { "spec" }
end
