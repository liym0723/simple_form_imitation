module SimpleFormImitation
  module Inputs
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :StringInput
    autoload :TextInput
    autoload :FileInput
    autoload :PasswordInput
    autoload :BooleanInput
    autoload :DateTimeInput
    autoload :HiddenInput
    autoload :CollectionInput
    autoload :CollectionSelectInput

  end
end
