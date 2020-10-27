# 验证
module SimpleFormImitation
  module Helpers
    module Validators

      def has_validators?
        # validators_on 列出用于验证特定属性的所有验证器。
        @has_validators ||= attribute_name && object.class.respond_to?(:validators_on)
      end


      def attribute_validators
        object.class.validators_on(attribute_name)
      end


      def find_validator(kind)
        attribute_validators.find{|v| v.kind == kind} if has_validators?
      end


    end
  end
end
