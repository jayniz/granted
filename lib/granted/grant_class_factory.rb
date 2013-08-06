module Granted
  class GrantClassFactory
    def self.create(right)
      name = "#{right.to_s.camelize}Grant"
      return if Granted.const_defined?(name)
      clazz = Class.new(Granted::Grant)
      Granted.const_set(name, clazz)
    end

    def self.get(right)
      Granted.const_get("#{right.to_s.camelize}Grant")
    end
  end
end
