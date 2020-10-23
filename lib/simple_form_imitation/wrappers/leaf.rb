module SimpleFormImitation
  module Wrappers
    class Leaf < Many # 单个组件
      attr_reader :namespace

      def initialize(namespace, options = {})
        @namespace = namespace
        @options = options
      end


      # input -> SimpleForm::Inputs::StringInput 实例
      def render(input)

        # b.use :placeholder
        # #<SimpleForm::Wrappers::Leaf:0x000000000426daa0 @namespace=:placeholder, @options={}>,
        # ->  @namespace = placeholder


       # m = 12.method("+")
       #    m.call(3)    #=> 15
       #    m.call(20)   #=> 32

       # method.call(@options)

        method = input.method(@namespace)

        # #<Method: SimpleFormImitation::Inputs::StringInput#input>

        if method.arity.zero?
          method.call
        else
          method.call(@options)
        end

       # "<h1>Liym Test -> Leaf.#render</h1>"
      end

    end
  end
end
