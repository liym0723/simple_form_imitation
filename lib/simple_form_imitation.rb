require "simple_form_imitation/version"
require 'action_view'
require 'simple_form_imitation/action_view_extensions/form_helper'
# 仿 simple_form
# TODO 和 simple_form 同时使用时, @@全局变量会被覆盖 必须换掉名称

module SimpleFormImitation
  extend ActiveSupport::Autoload # 引入延时加载
  autoload :Helpers #
  autoload :Wrappers

  eager_autoload do

    autoload :FormBuilder # -> 表格生成器
    autoload :Inputs # -> 输入项
    autoload :Components
  end
  # mattr_reader -> 只可读取
  # mattr_accessor -> 可读 可写


  # simple_form class
  mattr_reader :form_class_imitation
  @@form_class_imitation = :simple_form

  # simple form default class
  mattr_accessor :default_form_class_imitation
  @@default_form_class_imitation = nil


  mattr_accessor :label_text
  @@label_text = ->(label, required, explicit_label) { "#{required} #{label}" }

  # 默认包装器
  mattr_accessor :default_wrapper
  @@default_wrapper = :default
  @@wrappers = {}

  # You can define which elements should obtain additional classes. -> 那些元素获取其他类
  mattr_accessor :generate_additional_classes_for
  @@generate_additional_classes_for = %i[wrapper label input]


  # input 默认class
  mattr_accessor :input_class
  @@input_class = nil

  # 错误的方法
  mattr_accessor :error_method
  @@error_method = :first

  # Define the way to render check boxes / radio buttons with labels.
  #   inline: input + label (default)
  #   nested: label > input
  mattr_accessor :boolean_style
  @@boolean_style = :inline


  mattr_accessor :i18n_scope
  @@i18n_scope = 'simple_form'

  # defaule errorr proc
  mattr_accessor :field_error_proc_imitation
  @@field_error_proc_imitation = proc do |html_tag, instance_tag|
    # proc
    # p = proc {|x,y| x = x, y = y}
    # p.call(1,2) -> x = 1, y = 2
    # p.call([1,2]) -> x = 1, y = 2
    # p.call(1) -> x= 1, y =
    # p.call(1,2,3) -> x = 1, y = 2
    html_tag
  end

  # 检索给定的包装器
  def self.wrapper(name)
    @@wrappers[name.to_s] or "Couldn't find wrapper with name #{name}"
  end

  # 使用SimpleForm::Wrappers::Builder定义一个新的包装器 并给定存储名称
  def self.wrappers(*args, &block)
    if block_given?
      # extract_options! 返回参数中的 hash
      options                 = args.extract_options!
      name                    = args.first || :default
      @@wrappers[name.to_s] =  build(options, &block)
    else
      @@wrappers
    end
  end

  # 使用 SimpleForm::Wrappers::Builder 构架新的包装
  # 初始化的时候 构建包装器
  def self.build(options = {})
    options[:tag] = :div if options[:tag].nil?
    builder = SimpleFormImitation::Wrappers::Builder.new(options)
    yield builder
    SimpleFormImitation::Wrappers::Root.new(builder.to_a, options)
  end

  wrappers class: :input, hint_class: :field_with_hint, error_class: :field_with_errors, valid_class: :field_without_errors do |b|
    # b -> SimpleFormImitation::Wrappers::Builder.new(options)
    # b.use :html5
    #
    # b.use :min_max
    # b.use :maxlength
    # b.use :minlength
    # b.use :placeholder
    # b.optional :pattern
    # b.optional :readonly

    b.use :label_input
    # b.use :hint,  wrap_with: { tag: :span, class: :hint }
    # b.use :error, wrap_with: { tag: :span, class: :error }
  end

  class Error < StandardError; end
  # Your code goes here...

  def self.setup
    @@configured = true
    yield self
  end

  def self.additional_classes_for(component)
    generate_additional_classes_for.include?(component) ? yield : []
  end

end
