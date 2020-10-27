
module SimpleFormImitation
  module Components
    module Maxlength

      def maxlength( wrapper_options = nil )
        #  maximum_length_from_validation -> 自定义验证 或 长度验证
        #  limit 数据库长度
        # 1. 自定义长度， 2 验证长度， 3 数据库数据长度
        input_html_options[:maxlength] ||= maximum_length_from_validation || limit
        nil
      end

      def maximum_length_from_validation
        # 自定义长度 或者 长度验证
        maxlength = options[:maxlength]
        if maxlength.is_a?(String) || maxlength.is_a?(Integer)
          # 自定义长度
          maxlength
        else
          # 最大长度
          # ,length:{ maximum: 200}
          length_validator = find_length_validator
          maximum_length_value_from(length_validator)
        end
      end

      def find_length_validator
        find_validator(:length)
      end

      def maximum_length_value_from(length_validator)
        if length_validator
          length_validator.options[:is] || length_validator.options[:maximum]
        end

      end
    end
  end
end
