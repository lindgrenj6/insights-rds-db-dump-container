#!/usr/bin/env ruby
# frozen_string_literal: true

RUNNER = 'kubectl' # change to oc if that is what you use.

raise 'Wrong project, change your oc project to `approval-prod`' unless `#{RUNNER} config current-context`.match?(/^approval-prod.*/)

system("#{RUNNER} create -f #{__dir__}/resources/approval_dumper.yml")

until `#{RUNNER} logs approval-db-dump`.match?(/Ding!/)
  puts 'Database dump still baking, waiting 5s...'
  sleep 5
end

path = `#{RUNNER} logs approval-db-dump`.match(%r{\/tmp\/.*\.sql\.gz}).to_s

puts "Copying #{path} from approval-db-dump down..."
system("#{RUNNER} cp approval-db-dump:#{path} ./#{path.sub('/tmp/', '')}")

puts 'Deleting dump pod...'
system("#{RUNNER} delete -f #{__dir__}/resources/approval_dumper.yml")

puts "Database dump complete. To restore run: 'ruby restore_approval_db.rb ./#{path.sub('/tmp/', '')}'"
