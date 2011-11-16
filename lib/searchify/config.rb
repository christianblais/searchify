module Searchify
  module Config
    class << self
      attr_accessor :scope_exclusion,
                    :column_names,
                    :scope_awareness,
                    :limit,
                    :search_key,
                    :label_method,
                    :default_action

      def configure(&block)
        @configuration = block
      end

      def configure!
        @configuration.call(self) if @configuration
      end

      protected

      def init!
        @defaults = {
          :@scope_exclusion => %w( controller action format collection term page ),
          :@column_names    => %w( name title abbreviation ),
          :@scope_awareness => true,
          :@limit           => 30,
          :@search_key      => nil,
          :@label_method    => :name,
          :@default_action  => :show
        }
      end

      def reset!
        @defaults.each do |k,v|
          instance_variable_set(k,v)
        end
      end
    end

    init!
    reset!
  end
end