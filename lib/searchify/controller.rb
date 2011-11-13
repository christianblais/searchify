module Searchify
  module Controller
    SCOPE_EXCLUSION = %w( controller action format collection term page )

    def self.included(base)
      base.class_eval do
        include InstanceMethods
      end
    end

    module InstanceMethods
      def searchify_scopes
        params.except(*SCOPE_EXCLUSION)
      end
    end
  end
end