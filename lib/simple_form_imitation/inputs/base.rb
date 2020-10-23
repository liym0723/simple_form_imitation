
require 'active_support/core_ext/string/output_safety'
require 'action_view/helpers'

module SimpleFormImitation
  module Inputs
    class Base
      include ERB::Util # html_escape

      include SimpleFormImitation::Components::LabelInput
      include SimpleFormImitation::Components::Labels
      include SimpleFormImitation::Components::Errors

      attr_reader :input_type, :options, :attribute_name, :input_html_options, :input_html_classes, :html_classes

      # # @builder ->  #<SimpleForm::FormBuilder:0x0000000007bf8f40>
      delegate :template, :object, to: :@builder

      class_attribute :default_options
      self.default_options = {}

      def initialize(builder, attribute_name, column, input_type, options = {})
        options = options.dup # dup 创建新的实例
        @builder = builder
        @attribute_name = attribute_name
        @column = column
        @input_type = input_type

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

    end
  end
end