guard :test do
  watch(%r{^lib/wherewolf/(.+)\.rb$})           { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^test/(.+)_test\.rb$})                    { |m| "lib/wherewolf/#{m[1]}.rb" }
end
