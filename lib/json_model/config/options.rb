# frozen_string_literal: true

module JsonModel
  module Config
    module Options
      # @return [Hash]
      def defaults
        @defaults ||= {}
      end

      # @return [Hash]
      def settings
        @settings ||= {}
      end

      # @param [Symbol] name
      # @param [Object] default
      # @param [Proc, nil] transformation
      def option(name, default: nil, &transformation)
        define_method(name) { settings[name] }
        define_method("#{name}=") do |value|
          settings[name] = transformation.nil? ? value : transformation.call(value)
        end
        module_function(name)
        module_function("#{name}=")

        defaults[name] = transformation.nil? ? default : transformation.call(default)
        settings[name] = defaults[name]
      end
    end
  end
end
