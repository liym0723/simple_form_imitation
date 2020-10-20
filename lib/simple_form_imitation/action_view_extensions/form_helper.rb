module SimpleFormImitation
  module ActionViewExtensions
    module FormHelper
      def test_simple_form_for record, options = {}, &block
        # 重写表单构造器 ActionView::Helpers::FormBuilder
        options[:builder] ||= SimpleFormImitation::FormBuilder

        options[:html] ||= {}
        if options[:html].key? :class
          # 使用自定义class
          options[:html][:class] = [SimpleFormImitation.form_class_imitation,options[:html][:class]].compact # compact -> 去掉 nil
        else
          # 使用默认 class
          options[:html][:class] = [SimpleFormImitation.form_class_imitation, SimpleFormImitation.default_form_class_imitation,].compact
        end

        # 重写 错误的情况，暂时没实现包裹
       with_simple_form_field_error_proc do
          form_for record,options,&block
       end
      end

      private
      def with_simple_form_field_error_proc
        # 从 action view 获取默认的错误代码块
        default_field_error_proc = ::ActionView::Base.field_error_proc
        begin
          # 覆盖 ActionView 的错误代码块
          ::ActionView::Base.field_error_proc = SimpleFormImitation.field_error_proc_imitation
          yield if block_given?
        ensure
          # 一定会执行的, 还原  ActionView 的错误代码块
          ::ActionView::Base.field_error_proc = default_field_error_proc
        end
      end
    end
  end
end


# 加载 FormHelper
ActiveSupport.on_load :action_view do
  ::ActionView::Base.send :include, SimpleFormImitation::ActionViewExtensions::FormHelper
end