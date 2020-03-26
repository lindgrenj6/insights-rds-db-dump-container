#!/usr/bin/env ruby
# frozen_string_literal: true

RUNNER = 'kubectl' # change to oc if that is what you use.

raise 'Wrong project, change your oc project to `catalog-prod`' unless `#{RUNNER} config current-context`.match?(/^catalog-prod.*/)

system("#{RUNNER} create -f ./resources/catalog_dumper.yml")

until `#{RUNNER} logs catalog-db-dump`.match?(/Ding!/)
  puts 'Database dump still baking, waiting 5s...'
  sleep 5
end

path = `#{RUNNER} logs catalog-db-dump`.match(%r{\/tmp\/.*\.sql\.gz}).to_s

puts "Copying #{path} from catalog-db-dump down..."
system("#{RUNNER} cp catalog-db-dump:#{path} ./#{path.sub('/tmp/', '')}")

puts 'Deleting dump pod...'
system("#{RUNNER} delete -f ./resources/catalog_dumper.yml")

puts "Database dump complete. To restore run: 'ruby restore_db.rb ./#{path.sub('/tmp/', '')}'"
