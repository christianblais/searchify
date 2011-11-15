module Searchify
  module Controller
    def self.included(base)
      base.class_eval do
        include InstanceMethods
      end

      Searchify::Config.configure!
    end

    module InstanceMethods
      def searchify_scopes
        params.except(*Searchify::Config.scope_exclusion)
      end
    end
  end
end