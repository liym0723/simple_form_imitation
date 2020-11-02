

module SimpleFormImitation
  module Inputs

    class CollectionRadioButtonsInput < CollectionInput
      # 单选

      def input(wrapper_options = nil)
        label_method, value_method = detect_collection_methods
        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

        # "input_type -> radio_buttons"
        # "attribute_name -> name"
        # "collection -> [[\"YES\", true], [\"NO\", false]]"

        # collection_radio_buttons(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
        @builder.send("collection_#{input_type}", attribute_name, collection, value_method, label_method,input_options, merged_input_options )
      end

    end

  end

end