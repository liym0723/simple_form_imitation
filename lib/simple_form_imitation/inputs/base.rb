
require 'active_support/core_ext/string/output_safety'
require 'action_view/helpers'

module SimpleFormImitation
  module Inputs
    class Base
      include ERB::Util # html_escape
      include ActionView::Helpers::TranslationHelper
      extend I18nCache

      include SimpleFormImitation::Components::LabelInput
      include SimpleFormImitation::Components::Labels
      include SimpleFormImitation::Components::Errors

      include SimpleFormImitation::Components::Maxlength
      include SimpleFormImitation::Components::Minlength
      include SimpleFormImitation::Components::MinMax
      include SimpleFormImitation::Components::Pattern
      include SimpleFormImitation::Components::Placeholder
      include SimpleFormImitation::Helpers::Disabled
      include SimpleFormImitation::Helpers::Readonly
      include SimpleFormImitation::Helpers::Validators

      attr_reader :input_type, :options, :attribute_name, :input_html_options, :input_html_classes, :html_classes, :column

      # # @builder ->  #<SimpleForm::FormBuilder:0x0000000007bf8f40>
      delegate :template, :object, :object_name, :lookup_model_names, :lookup_action, to: :@builder

      class_attribute :default_options
      self.default_options = {}

      # def self.enable(*keys)
      #   options = self.default_options.dup
      #   keys.each{|k| options.delete(k)}
      #   self.default_options = options
      # end
      #
      # def self.disable(*keys)
      #   options = self.default_options.dup
      #   keys.each { |key| options[key] = false }
      #   self.default_options = options
      # end
      #
      # enable :hint
      #
      # disable :maxlength, :minlength, :placeholder, :pattern, :min_max


      def initialize(builder, attribute_name, column, input_type, options = {})
        options = options.dup # dup 创建新的实例
        @builder = builder
        @attribute_name = attribute_name
        @column = column
        @input_type = input_type
        # reverse_merge! 反向合并 前者覆盖后者

        @options = options.reverse_merge!(self.class.default_options)

        # "@builder -> #<SimpleFormImitation::FormBuilder:0x00000000095c5630>"
        # "@attribute_name -> name"
        # "@column -> #<ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::MysqlString:0x00000000093f16d8>"
        # "@input_type -> string"
        # "@options -> {:label=>\"Your username please\", :error=>\"NAME is mandatory\"}"
        # "@template -> "


        # "input_html_classes -> [:string, :required]"
        # "input_html_options -> {:class=>[:string, :required], :required=>true, :\"aria-required\"=>true, :\"aria-invalid\"=>true, :maxlength=>255, :minlength=>nil, :placeholder=>nil}"
        @html_classes = SimpleFormImitation.additional_classes_for(:input) {additional_classes}
        @input_html_classes = @html_classes.dup

        # 默认class
        input_html_classes = self.input_html_classes
        if SimpleFormImitation.input_class && input_html_classes.any?
            input_html_classes << SimpleFormImitation.input_class
        end

        @input_html_options = html_options_for(:input, input_html_classes)
      end

      def additional_classes
        @additional_classes ||= [input_type]
      end

      def html_options_for(namespace, css_classes)
        html_options = options["#{namespace}_html".to_sym]
        html_options = html_options ? html_options.dup : {}
        css_classes << html_options[:class] if html_options.key?(:class)
        html_options[:class] = css_classes unless css_classes.empty?
        html_options

      end

      # 拼接 自定义 class
      def merge_wrapper_options(options, wrapper_options)
        if wrapper_options
          wrapper_options = set_input_classes(wrapper_options)

          wrapper_options.merge(options) do |k, oldval, newval|
            case key.to_s
              when "class"
                Array(oldval) + Array(newval)
              when "data","aria"
                oldval.merge(newval)
              else
                newval
            end
          end
        else
          options
        end
      end

      def set_input_classes(wrapper_options)
        wrapper_options = wrapper_options.dup
        error_class     = wrapper_options.delete(:error_class)
        valid_class     = wrapper_options.delete(:valid_class)

        if error_class.present? && has_errors?
          wrapper_options[:class] = "#{wrapper_options[:class] } #{error_class}"
        end

        if valid_class.present? && vaild?
          wrapper_options[:class] = "#{wrapper_options[:class]} #{valid_class}"
        end

        wrapper_options

      end


      def limit

        # "column -> #<ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::MysqlString:0x00000000093e1f80>"
        # "decimal_limit -> 256"
        # "column_limit -> 255"
        if column
          decimal_or_float? ? decimal_limit : column_limit
        end
      end

      def decimal_or_float?
        column.type == :float || column.type == :decimal
      end

      def decimal_limit
        column_limit && (column_limit + 1)
      end

      def column_limit
        column.limit
      end

      def translate_from_namespace(namespace, default = '')
        # 根据 namespace 查找到 translate
        # "model_names -> [\"user\"]"
        # "lookup_action -> new"
        # "reflection_or_attribute_name -> name"
        model_names = lookup_model_names.dup
        #   shift 删除首个 且返回
        while !model_names.empty?

        end
      end

      def i18n_scope
        SimpleFormImitation.i18n_scope
      end

    end
  end
end