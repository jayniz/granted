class Document < ActiveRecord::Base
  include Granted::ForGranted

  grantable :read, :write, :delete, to: User

  attr_accessible :content, :name
end
