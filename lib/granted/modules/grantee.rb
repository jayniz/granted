module Granted
  module Grantee
    extend ActiveSupport::Concern
      def grant(right)
        Granted::Granter.new
                        .grant
                        .right(right)
                        .to(self)
      end

      def revoke(right)
        Granted::Granter.new
                        .revoke
                        .right(right)
                        .to(self)
      end
  end
end
