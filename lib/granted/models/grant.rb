module Granted
  class Grant < ActiveRecord::Base
    belongs_to :grantee, polymorphic: true
    belongs_to :subject, polymorphic: true

    attr_accessible :grantee, :subject, :type

    validates_uniqueness_of :type, scope: [:grantee_id, :grantee_type, :subject_id, :subject_type]

    def self.grantee(grantee)
      where(grantee_id: grantee.id, grantee_type: grantee.class.name)
    end

    def self.subject(subject)
      where(subject_id: subject.id, subject_type: subject.class.name)
    end
  end
end
