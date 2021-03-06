module Granted
  module ForGranted
    extend ActiveSupport::Concern

    included do
    end

    def grant(*rights)
      Granted::Granter.new
                      .grant
                      .rights(rights)
                      .on(self)
    end

    def revoke(*rights)
      Granted::Granter.new
                      .revoke
                      .rights(rights)
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
          GrantClassFactory.create(right)
          setup_grantee(right, grantee)
          setup_self(right, grantee)
        end
      end

      def setup_grantee(right, grantee)
        name_sym = name.pluralize.underscore.to_sym
        grants_relation = "#{right}_grants".to_sym

        # Relation to this right's grants
        grantee.has_many grants_relation, as: :grantee, class_name: "Granted::#{right.to_s.camelize}Grant"

        # e.g. User#readable_documents
        rel_name = "#{right}able_#{name_sym}".to_sym
        grantee.has_many rel_name, source: :subject, source_type: name, through: grants_relation
        # grantee.attr_accessible "#{rel_name}_attributes".to_sym
        # grantee.accepts_nested_attributes_for rel_name

        # e.g. User#all_documents
        rel_name = "all_#{name_sym}".to_sym
        grantee.has_many :grants, as: :grantee, class_name: 'Granted::Grant', dependent: :destroy
        grantee.has_many rel_name, source: :subject, source_type: name, through: :grants, uniq: true

        # my_user.grant and my_user.revoke methods
        grantee.send :include, Granted::Grantee
      end

      def setup_self(right, grantee)
        name_sym = grantee.name.pluralize.underscore.to_sym

        # Relation to grants
        grants_relation = "#{right}_grants".to_sym
        has_many grants_relation, as: :subject, class_name: "Granted::#{right.to_s.camelize}Grant", dependent: :destroy

        # e.g. Document#read_users
        rel_name = "#{right}_#{name_sym}".to_sym
        has_many rel_name, source: :grantee, source_type: grantee.name, through: grants_relation
        attr_accessible "#{rel_name}_attributes".to_sym
        accepts_nested_attributes_for rel_name

        # e.g. Document#all_users
        rel_name = "all_#{name_sym}".to_sym
        has_many :grants, as: :subject, class_name: "Granted::Grant", dependent: :destroy
        has_many rel_name, source: :grantee, source_type: grantee.name, through: :grants, uniq: true
      end
    end
  end
end
