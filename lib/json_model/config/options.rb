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

      def option(name, default: nil, &transformation)
        define_method(name) { settings[name] }
        define_method("#{name}=") do |value|
          settings[name] = transformation.present? ? transformation.call(value) : value
        end
        module_function(name)
        module_function("#{name}=")

        defaults[name] = transformation.present? ? transformation.call(default) : default
        settings[name] = defaults[name]
      end
    end
  end
end
