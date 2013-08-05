class User < ActiveRecord::Base
  include Granted::ForGranted

  attr_accessible :name
end
