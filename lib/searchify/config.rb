module Searchify
  module Config
    class << self
      attr_accessor :scope_exclusion, :columns

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
          :@columns         => %w( name title abbreviation )
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