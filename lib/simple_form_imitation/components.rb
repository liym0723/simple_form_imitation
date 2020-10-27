# frozen_string_literal: true
module SimpleFormImitation
  # Components are a special type of helpers that can work on their own.
  # For example, by using a component, it will automatically change the
  # output under given circumstances without user input. For example,
  # the disabled helper always need a disabled: true option given
  # to the input in order to be enabled. On the other hand, things like
  # hints can generate output automatically by doing I18n lookups.
  module Components
    extend ActiveSupport::Autoload

    autoload :LabelInput
    autoload :Labels
    autoload :Errors

    autoload :Maxlength
    autoload :Minlength
    autoload :MinMax
    autoload :Pattern
    autoload :Placeholder
  end
end
