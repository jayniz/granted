require 'granted'
require 'granted/db/migrations/create_granted_table'

namespace :granted do
  desc 'Create the grants table'
  task create_migration: :environment do
    to_dir = File.join(Rails.root, "db", "migrate")
    from   = "#{CreateGrantedTable.filename}"
    to     = File.join(to_dir, "#{Time.now.to_i}_#{File.basename(from)}")
    puts "Creating #{to}..."
    FileUtils.mkdir_p(to_dir)
    FileUtils.cp(from, to)
  end

end

