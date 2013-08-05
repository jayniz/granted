module Granted
  class Granter
    def initialize
    end

    def to(grantee)
      accept(grantee: grantee)
    end
    
    def from(grantee)
      accept(grantee: grantee)
    end

    def on(subject)
      accept(subject: subject)
    end

    def right(right)
      accept(right: right)
    end

    def grant
      accept(action: :grant)
    end

    def revoke
      accept(action: :revoke)
    end

    private

    def accept(options)
      @action  ||= options[:action]
      @grantee ||= options[:grantee]
      @subject ||= options[:subject]
      @right   ||= options[:right]
      finalize
    end

    def finalize
      return self unless @grantee and @subject and @right and @action
      @selector = Grant.grantee(@grantee).subject(@subject).where(right: @right)
      case @action.to_sym
      when :grant  then give_grant
      when :revoke then revoke_grant
      else raise "Invalid action @action"
      end
    end

    def revoke_grant
      return true unless g = @selector.first
      g.destroy
    end

    def give_grant
      @selector.first_or_create
    end

  end
end
