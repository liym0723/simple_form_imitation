module SimpleFormImitation
  module Wrappers
    class Root < Many

      attr_reader :options
      def initialize(*args)

        super(:wrapper, *args)

        @options = @defaults.except(:tag, :class, :error_class, :hint_class)
      end


      def render(input)
        # input.options.reverse_merge!(@options)
        super
      end

    end
  end
end
