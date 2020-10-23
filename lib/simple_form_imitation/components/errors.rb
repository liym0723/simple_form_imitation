module SimpleFormImitation
  module Components
    module Errors

      def error(wrapper_options = nil)
        error_text if has_errors?
      end



      def has_errors?
        # object -> <User:0x0000000009468378
        object_with_errors? || object.nil? && has_custom_error?
      end


      def object_with_errors?
        object && object.respond_to?(:errors) && errors.present?
      end

      def has_custom_error?
       # "options[:error] -> NAME is mandatory"
        options[:error].is_a?(String)
      end

      def errors
        @errors ||= errors_on_attribute
      end

      def errors_on_attribute
        object.errors[attribute_name] || []
      end

      def error_text
        # 如果是一个错误 就取一个， 否则只取第一个
        text = has_custom_error? ? options[:error] : errors.send(error_method)

        # lstrip 去掉前置空格
        # html_safe html格式
        # 错误前缀 错误
        "#{html_escape(options[:error_prefix])} #{html_escape(text)}".lstrip.html_safe

      end

      def error_method
        options[:error_method] || SimpleFormImitation.error_method
      end
    end
  end
end
