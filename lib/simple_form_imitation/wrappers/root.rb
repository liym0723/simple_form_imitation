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


      def html_classes(input, options)

        # "options -> {:label=>\"Your username please\", :error=>\"NAME is mandatory\"}"

        css = options[:wrapper_class] ? Array(options[:wrapper_class]) : @defaults[:class]

        # 根据配置 增加
        css += SimpleFormImitation.additional_classes_for(:wrapper) do
          input.additional_classes
        end

        # 错误信息
        css << html_class(:error_class, options){ input.has_errors?}

        css.compact
      end

      def html_class(key, options)
        css = (options["wrapper_#{key}".to_sym] || @defaults[key])
        css if css && yield
      end

    end
  end
end
