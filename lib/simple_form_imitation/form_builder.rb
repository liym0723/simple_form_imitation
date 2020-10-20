
require 'simple_form_imitation/map_type'
# 表单生成器
module SimpleFormImitation
  class FormBuilder < ActionView::Helpers::FormBuilder
    extend ActiveSupport::Autoload # 引入延时加载
    # attr_reader -> 提供读取方法
    # template, object_name 在 ActionView::Helpers::FormBuilder 中初始化了
    attr_reader :wrapper, :object, :template, :object_name

    extend MapType # 加载映射
    include SimpleFormImitation::Inputs # 加载inputs

    map_type :string, to: SimpleFormImitation::Inputs::StringInput


    def initialize(*)
      super
      # @object -> 对象
      # convert_to_model -> 对象转换成 Model 或 model_name 进行处理
      # @object -> User
      @object = convert_to_model(@object)
      @defaults = options[:defaults]
      @wrapper = SimpleFormImitation.wrapper(options[:wrapper] || SimpleFormImitation.default_wrapper)

    end

    # 根据 字段类型， 渲染出不同的内容
    #

    # call 调用block. &block 代码块
    def input attribute_name, options = {}, &block
      # deep_dup -> 拷贝hash
      # deep_merge -> 合并hash 并返回
      # deep_dup.deep_merge 拷贝hash 并合并hash， 返回一个新的hash
      options = @defaults.deep_dup.deep_merge(options) if @defaults # 默认样式存在的话

      # 根据 name 获取到 inputs 类型 获取到类型
      # #<SimpleFormImitation::Inputs::StringInput:0x0000000009199188>
      input = find_input(attribute_name, options, &block)


      # 获取到类型 接下来就是需要获取到包装器了(wrapper)

      # "wrapper -> #<SimpleFormImitation::Wrappers::Root:0x0000000006f9b5b8>"
      wrapper = find_wrapper(input.input_type, options)

      wrapper.render input
    end

    # Find an input based on the attribute name. 根据属性名称查找对应类型
    def find_input attribute_name, options = {}, &block
      column = find_attribute_column(attribute_name) # -> ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::MysqlString

      input_type = default_input_type(attribute_name, column, options) # :string


      # 查询 并创建 inputs 实例对象出来
      find_mapping(input_type).new(self, attribute_name, column, input_type, options)
    end

    def find_attribute_column attribute_name
      # has_attribute?(name) -> object 是否存在 name 这个code
      return unless @object.has_attribute?(attribute_name)

      if @object.respond_to?(:type_for_attribute)
        # type_for_attribute  -> 返回具有给定名称的属性类型
        @object.type_for_attribute(attribute_name.to_s) # -> <ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::MysqlString:0x00000000094dd880
      elsif @object.respond_to?(:column_for_attribute)
        # column_for_attribute 返回指定属性的列对象
        # person.column_for_attribute(:name) -> #<ActiveRecord::ConnectionAdapters::Column:0x007ff4ab083980 @name="name", @sql_type="varchar(255)", @null=true, ...>
        @object.column_for_attribute(attribute_name)
      end
    end

    def default_input_type attribute_name, column, options = {}
      return options[:as].to_sym if options[:as] # 如果提供了类型 就不需要去猜测
      return :select if options[:collection]
      input_type = column.try(:type) # 通过find_attribute_column 获取到数据库的字段类型
      case input_type
        when :timestamp
          :datetime
        when :string, :citext, nil
          case attribute_name.to_s
            when /(?:\b|\W|_)password(?:\b|\W|_)/  then :password
            when /(?:\b|\W|_)time_zone(?:\b|\W|_)/ then :time_zone
            when /(?:\b|\W|_)country(?:\b|\W|_)/   then :country
            when /(?:\b|\W|_)email(?:\b|\W|_)/     then :email
            when /(?:\b|\W|_)phone(?:\b|\W|_)/     then :tel
            when /(?:\b|\W|_)url(?:\b|\W|_)/       then :url
            else
              # 是否是文件类型
              file_method?(attribute_name) ? :file : (input_type || :string)
          end
        else
          input_type
      end

    end

    # 判断是否是文件类型
    def file_method?(attribute_name)
      @object.respond_to?("#{attribute_name}_attachment") ||
          @object.respond_to?("remote_#{attribute_name}_url") ||
          @object.respond_to?("#{attribute_name}_attacher") ||
          @object.respond_to?("#{attribute_name}_file_name")
    end

    # 尝试查找映射 mapping -> 映射
    # 尝试查找映射。 它遵循以下规则：
    # 1. 如果成功， 他将尝试查找注册的映射
      # 尝试在对象范围内查找具有相同名称的替代品
      # 或使用找到的映射
    # 2. 如果不是 退回到 input_type input
    # 3. 如果不是 退回到 SimpleForm::Inputs::#{input_type}Input
    # input_type = string -> return SimpleForm::Inputs::StringInput
    def find_mapping(input_type)
      # self.class.mappings[input_type] -> SimpleForm::Inputs::StringInput

      # 根据 type 找到对应的input
      self.class.mappings[input_type]
    end


    # 查找包装器
    def find_wrapper input_type, options
      wrapper
    end
  end
end

