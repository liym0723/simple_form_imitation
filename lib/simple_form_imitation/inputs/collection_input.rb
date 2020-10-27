
module SimpleFormImitation
  module Inputs
    class CollectionInput < Base



      # 确定正确的方法以查找集合的标签和值。
      # ＃如果未定义标签或值方法，将尝试根据以下内容查找它们
      # ＃关于可以通过配置的默认标签和值方法
      # ＃SimpleForm.collection_label_methods和
      # ＃SimpleForm.collection_value_methods。
      def detect_collection_methods
        label, value = options.delete(:label_method), options.delete(:value_method)


        # 如果某一个值不存在的话
        unless label && value
          # 查询值
          common_method_for = detect_common_display_methods
          label ||= common_method_for[:label]
          value ||= common_method_for[:value]
        end

        [label, value]
      end

      def detect_common_display_methods

      end
    end

  end
end