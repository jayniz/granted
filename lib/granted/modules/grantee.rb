module Granted
  module Grantee
    extend ActiveSupport::Concern
      def grant(*rights)
        Granted::Granter.new
                        .grant
                        .rights(rights)
                        .to(self)
      end

      def revoke(*rights)
        Granted::Granter.new
                        .revoke
                        .rights(rights)
                        .to(self)
      end

      def grants_for(subject)
        grants.subject(subject).map do |g|
          grant_class_name_to_symbol(g.type)
        end.sort
      end

      private

      def grant_class_name_to_symbol(c)
        # A class name could be Granted::ReadGrant
        # and we want to make :read out of it
        c.underscore[8..-1]  # Remove granted/ prefix
         .chomp('_grant')    # Remove trailing _grant
         .to_sym
      end
  end
end
