# frozen_string_literal: true
require 'active_support/core_ext/class/attribute'

module SimpleFormImitation
  module MapType
    def self.extended(base)
      base.class_attribute :mappings
      base.mappings = {}
    end


    def map_type(*types)
      # extract_options! 把可选参数里的 Hash 部分，萃取出来。
      map_to = types.extract_options![:to]
      raise ArgumentError, "You need to give :to as option to map_type" unless map_to
      # (1..10).each_with_object([]) { |i, a| a << i*2 }  #=> [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
      self.mappings = mappings.merge types.each_with_object({}) { |t, m| m[t] = map_to }
    end
  end
end