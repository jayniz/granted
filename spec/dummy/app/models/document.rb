class Document < ActiveRecord::Base
  include Granted::ForGranted

  grantable :read, :write, :destroy, to: User

  attr_accessible :content, :name
end
