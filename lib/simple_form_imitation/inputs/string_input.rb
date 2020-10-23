module SimpleFormImitation
  module Inputs
    class StringInput < Base

      # 渲染

      def input(wrapper_options = nil)
        input_html_classes.unshift("string") unless string?

       #  merged_input_options = merged_input_options(input_html_options, wrapper_options)

        @builder.text_field(attribute_name, input_html_options)
      end


      def string?
        input_type.to_sym == :string
      end

    end
  end
end
