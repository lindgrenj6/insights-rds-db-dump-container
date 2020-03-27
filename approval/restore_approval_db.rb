#!/usr/bin/env ruby
# frozen_string_literal: true

RUNNER = 'kubectl' # change to oc if that is what you use.

raise 'Wrong project, change your oc project to `approval-prod`' unless `#{RUNNER} config current-context`.match?(/^approval-prod.*/)
raise 'dump file required as first argument' unless ARGV.first

system("#{RUNNER} create -f #{__dir__}/resources/approval_restorer.yml")

until `#{RUNNER} get pod -l app=restorer --no-headers | wc -l`.to_i == 1
  puts 'Database restore pod still baking, waiting 5s...'
  sleep 5
end

path = ARGV.first
puts "Copying #{path} up to approval-db-restore..."
system("#{RUNNER} cp #{path} approval-db-restore:/tmp/#{path}")

puts 'Restoring db...'
system("#{RUNNER} exec -it approval-db-restore -- /bin/restore_db.sh #{ARGV.first}")

puts 'Deleting restore pod...'
system("#{RUNNER} delete -f #{__dir__}/resources/approval_restorer.yml")

puts 'Database restored.'
