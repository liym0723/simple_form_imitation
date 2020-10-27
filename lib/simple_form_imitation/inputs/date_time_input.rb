
module SimpleFormImitation
  module Inputs
    class DateTimeInput < Base

      def input(wrapper_options = nil)
        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

        @builder.send(:"#{input_type}_select", attribute_name, options, merged_input_options)
      end

    end
  end

end