module SimpleFormImitation
  module Wrappers
    class Single < Many # 多个组件

      def initialize(name, wrapper_options = {}, options = {})
        @component = Leaf.new(name, options)

        super(name, [@component], wrapper_options)
      end


      def render(input)
        options = input.options
        if options[namespace] != false
          content = @component.render(input)
          wrap(input, options, content) if content
        end
      end

    end
  end
end
