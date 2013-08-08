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

    def rights(*rights)
      accept(rights: [rights].flatten)
    end

    def right(right)
      rights(right)
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
      @rights  ||= options[:rights]
      finalize
    end

    def finalize
      return self unless @grantee and @subject and @rights and @action
      @rights.map do |right|
        clazz = GrantClassFactory.get(right)
        selector = clazz.grantee(@grantee).subject(@subject)
        case @action.to_sym
        when :grant  then give_grant(selector)
        when :revoke then revoke_grant(selector)
        else raise "Invalid action @action"
        end
      end
    end

    def revoke_grant(selector)
      return true unless g = selector.first
      g.destroy
    end

    def give_grant(selector)
      selector.first_or_create
    end

  end
end
