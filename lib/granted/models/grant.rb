module Granted
  class Grant < ActiveRecord::Base
    belongs_to :grantee, polymorphic: true
    belongs_to :subject, polymorphic: true

    attr_accessible :grantee, :subject, :right
  end
end
