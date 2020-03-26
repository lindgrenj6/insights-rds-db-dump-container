#!/usr/bin/env ruby
# frozen_string_literal: true

RUNNER = 'kubectl' # change to oc if that is what you use.

raise 'Wrong project, change your oc project to `catalog-prod`' unless `#{RUNNER} config current-context`.match?(/^catalog-prod.*/)
raise 'dump file required as first argument' unless ARGV.first

system("#{RUNNER} create -f ./resources/catalog_restorer.yml")

until `#{RUNNER} get pod -l app=restorer --no-headers | wc -l`.to_i == 1
  puts 'Database restore pod still baking, waiting 5s...'
  sleep 5
end

path = ARGV.first
puts "Copying #{path} up to catalog-db-restore..."
system("#{RUNNER} cp #{path} catalog-db-restore:/tmp/#{path}")

puts 'Restoring db...'
system("#{RUNNER} exec -it catalog-db-restore -- /bin/restore_db.sh #{ARGV.first}")

puts 'Deleting restore pod...'
system("#{RUNNER} delete -f ./resources/catalog_restorer.yml")

puts 'Database restored.'
