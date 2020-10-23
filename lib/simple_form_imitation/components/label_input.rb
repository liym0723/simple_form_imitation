module SimpleFormImitation
  module Components
    module LabelInput
      extend ActiveSupport::Concern # 用来规范 model 代码逻辑。


      included do
        include SimpleFormImitation::Components::Labels
      end

      def label_input(wrapper_options = nil)
        if options[:label] == false
          # deprecated component -> 翻译 启用的组件
          deprecated_component(:input, wrapper_options)
        else
          deprecated_component(:label, wrapper_options) + deprecated_component(:input, wrapper_options)
        end
      end


      def deprecated_component(namespace, wrapper_options = nil)
        method = method(namespace)

        # "label === #<Method: SimpleForm::Inputs::StringInput(SimpleForm::Components::Labels)#label>"
        # "input === #<Method: SimpleForm::Inputs::StringInput#input>"

        # 每一个类型都单独写了 input
        # label 就用的共同的 base  include SimpleFormImitation::Components::LabelInput # label

        if method.arity.zero?
          method.call
        else
          method.call(wrapper_options)
        end

      end
    end
  end
end
