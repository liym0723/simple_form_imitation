# frozen_string_literal: true
module SimpleFormImitation
  module Generators
    # generate 生成器
    class InstallGenerator < Rails::Generators::Base
      #  存储并返回定义这个类所在的位置
      source_root File.expand_path('../templates', __FILE__)

      def copy_config
        # 复制 initializers 目录
        directory 'config/initializers'
      end

    end
  end
end
