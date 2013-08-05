require 'granted'
require 'granted/db/migrations/create_granted_table'

namespace :granted do
  desc 'Create the grants table'
  task create_table: :environment do
    puts CreateGrantedTable
  end

end

