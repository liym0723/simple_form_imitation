
module SimpleFormImitation
  module Inputs
    class CollectionSelectInput < CollectionInput

      def input
        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
        label_method,value_method = detect_collection_methods

        # collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
        @builder.collection_select(attribute_name, collection, value_method, label_method, input_options, merged_input_options)
      end

    end

  end
end