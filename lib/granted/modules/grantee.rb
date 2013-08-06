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
  end
end
