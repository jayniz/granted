require 'granted'
require 'granted/db/migrations/create_grants'

namespace :granted do
  desc 'Create the grants table'
  task create_migration: :environment do
    to_dir = File.join(Rails.root, "db", "migrate")
    from   = CreateGrants.filename
    to     = File.join(to_dir, "#{Time.now.strftime("%Y%M%d%H%I%S")}_#{File.basename(from)}")
    puts "Creating #{to}"
    FileUtils.mkdir_p(to_dir)
    FileUtils.cp(from, to)
  end

end

