module Granted
  module ForGranted
    extend ActiveSupport::Concern

    included do

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
        grantee.has_many rel_name, as: :subject, class_name: name, through: Grant
      end

      def setup_self(right, grantee)
        name_sym = grantee.name.pluralize.underscore.to_sym
        rel_name = "#{right}_#{name_sym}"
        has_many :grants, as: :subject, class_name: 'Granted::Grant'
        has_many rel_name, as: :grantee, class_name: grantee.name, through: Grant
      end
    end
  end
end
