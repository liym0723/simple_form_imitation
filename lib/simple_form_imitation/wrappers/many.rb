module SimpleFormImitation
  module Wrappers
    class Many

      attr_reader :namespace, :defaults, :components

      def initialize(namespace, components, defaults = {})
        @namespace  = namespace
        @components = components
        @defaults   = defaults
        @defaults[:tag]   = :div unless @defaults.key?(:tag)
        @defaults[:class] = Array(@defaults[:class])
      end

      def render(input)
        # "input -> #<SimpleFormImitation::Inputs::StringInput:0x0000000009144098>"
        # "input.options -> {:label=>\"Your username please\", :error=>\"NAME is mandatory\"}"
        # "components -> []"

        content = "".html_safe
        options = input.options

        # 拼接 options
        components.each do |component|
          # "component -> #<SimpleFormImitation::Wrappers::Leaf:0x0000000007f6af20>"
          # "component -> #<SimpleFormImitation::Wrappers::Leaf:0x0000000007f6ae30>"
          # "component -> #<SimpleFormImitation::Wrappers::Leaf:0x0000000007f6a8b8>"
          # "component -> #<SimpleFormImitation::Wrappers::Leaf:0x0000000007f6a6d8>"
          # "component -> #<SimpleFormImitation::Wrappers::Leaf:0x0000000007f6a4f8>"
          # "component -> #<SimpleFormImitation::Wrappers::Leaf:0x0000000007f6a2c8>"
          # "component -> #<SimpleFormImitation::Wrappers::Leaf:0x0000000007f69fd0>"
          # "component -> #<SimpleFormImitation::Wrappers::Leaf:0x0000000007f69f58>" # 一个
          # "component -> #<SimpleFormImitation::Wrappers::Single:0x0000000007f69cb0>" # 一组
          # "component -> #<SimpleFormImitation::Wrappers::Single:0x0000000007f69a08>" # 一组

          rendered = component.render(input)
          # safe_concat  如果 可用则用；否则用 concat
          # content.class -> ActiveSupport::SafeBuffer
          #  # 在 Active Support 里也提供了 safe_concat 方法，如果 可用则用；否则用 concat
          # 字符串拼接
          content.safe_concat rendered.to_s if rendered
        end

        wrap(input, options, content)

      end

      def wrap input, options, content
        tag = @defaults[:tag]

        input.template.content_tag(tag, content, options) # -> <tag class=opts>content</tag>
      end

    end
  end
end
