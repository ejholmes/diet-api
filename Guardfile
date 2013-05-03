# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', all_after_pass: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb')  { "spec" }

  watch('lib/diet.rb') { "spec" }
  watch(%r{^lib/diet/models/(.+)\.rb$})                    { |m| "spec/entities/#{m[1]}_spec.rb" }
  watch(%r{^lib/diet/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
end
