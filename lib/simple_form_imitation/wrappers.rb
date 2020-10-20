module SimpleFormImitation
  module Wrappers
    autoload :Root, 'simple_form_imitation/wrappers/root'
    autoload :Many, 'simple_form_imitation/wrappers/many'
    autoload :Builder, 'simple_form_imitation/wrappers/builder'
    autoload :Single,  'simple_form_imitation/wrappers/single' # 包含一个组件的包装器优化
    autoload :Leaf,    'simple_form_imitation/wrappers/leaf' # 对一个组件的包装器
  end
end