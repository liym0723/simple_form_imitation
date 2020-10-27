module SimpleFormImitation
  module Components
    module Labels
      extend ActiveSupport::Concern #  module ClassMethods

      module ClassMethods
        def translate_required_html
           "<abbr title='#{translate_required_text}'>#{translate_required_mark}</abbr>"
        end

        def translate_required_text
          "required"
        end

        def translate_required_mark
         "*"
        end
      end

      def label(wrapper_options = nil)

        label_options = merge_wrapper_options(label_html_options, wrapper_options)

        # "@builder -> #<SimpleFormImitation::FormBuilder:0x00000000094cd2c8>"
        # "attribute_name ->name"
        @builder.label(attribute_name, label_text, label_options)

      end


      def label_text
        # "html_escape(raw_label_text) -> Your username please"
        # "required_label_text -> <abbr title=\"required\">*</abbr>"
        # "options[:label] -> Your username please"

        # html_escape 转义下 避免特殊字符
        text = options[:label_text] || SimpleForm.label_text.call(html_escape(raw_label_text), required_label_text, options[:label].present?)
        text.to_s.strip.html_safe
      end


      def raw_label_text
        options[:label] || label_translation
      end

      # 必填 选则不同的 text
      def required_label_text
        self.class.translate_required_html.dup
      end


      # First check labels translation and then human attribute name.
      # 首先检查标签翻译，然后检查人员属性名称。
      def label_translation
        "name"
      end

      # 获取到自定义
      #<%= f.input :name,label: 'Your username please', error: 'NAME is mandatory', label_html: { class: 'my_class' } %>
      def label_html_options
        label_html_classes = SimpleFormImitation.additional_classes_for(:label) {
          [input_type]
        }

        html_options_for(:label, label_html_classes)
      end

    end
  end
end
