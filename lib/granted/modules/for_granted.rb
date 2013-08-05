module Granted
  module ForGranted
    extend ActiveSupport::Concern

    included do
    end

    def grant(right)
      Granted::Granter.new
                      .grant
                      .right(right)
                      .on(self)
    end

    def revoke(right)
      Granted::Granter.new
                      .revoke
                      .right(right)
                      .on(self)
    end

    module ClassMethods
      def grantable(*rights, grantees)
        [rights].flatten.each do |right|
          register_right(right, grantees[:to])
        end
      end

      private

      def register_right(right, grantees)
        [grantees].flatten.each do |grantee|
          setup_grantee(right, grantee)
          setup_self(right, grantee)
        end
      end

      def setup_grantee(right, grantee)
        name_sym = name.pluralize.underscore.to_sym
        rel_name = "#{right}able_#{name_sym}".to_sym
        grantee.has_many :grants, as: :grantee, class_name: 'Granted::Grant'
        grantee.has_many rel_name, source: :subject, source_type: name, class_name: name, through: :grants
        grantee.send :include, Granted::Grantee
      end

      def setup_self(right, grantee)
        name_sym = grantee.name.pluralize.underscore.to_sym
        rel_name = "#{right}_#{name_sym}"
        has_many :grants, as: :subject, class_name: 'Granted::Grant'
        has_many rel_name, source: :grantee, source_type: grantee.name, class_name: grantee.name, through: :grants
      end
    end
  end
end
