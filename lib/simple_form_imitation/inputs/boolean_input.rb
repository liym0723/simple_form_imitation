
module SimpleFormImitation
  module Inputs
    class BooleanInput < Base

      def input(wrapper_options = nil)
        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
        # nested -> 嵌套包装
        # inline -> 不生成包装
        if nested_boolean_style?
          # 嵌套 TODO 一般不经常用这个属性
        else
          # 不产生包装
          build_check_box(unchecked_value, merged_input_options)
        end
      end


      def nested_boolean_style?
        # Hash.fetch(key, default) -> 取出key的值，没有的情况下默认给一个
        options.fetch(:boolean_style, SimpleFormImitation.boolean_style) == :nested
      end

      # 默认值赋予 0
      def unchecked_value
        options.fetch(:unchecked_value, '0')
      end

      def check_value
        options.fetch(:checked_value, '1')
      end

      def build_check_box unchecked_value, options
        # check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
        @builder.check_box(attribute_name, options, check_value, unchecked_value)
      end
    end
  end

end