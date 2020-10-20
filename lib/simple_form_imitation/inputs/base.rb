

module SimpleFormImitation
  module Inputs
    class Base

      attr_reader :input_type, :options

      # # @builder ->  #<SimpleForm::FormBuilder:0x0000000007bf8f40>
      delegate :template, to: :@builder

      class_attribute :default_options
      self.default_options = {}

      def initialize(builder, attribute_name, column, input_type, options = {})
        options = options.dup # dup 创建新的实例
        @builder = builder
        @attribute_name = attribute_name
        @column = column
        @input_type = input_type

        @options = options.reverse_merge!(self.class.default_options)

      end

    end
  end
end