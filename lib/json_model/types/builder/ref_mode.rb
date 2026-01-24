# frozen_string_literal: true

module JsonModel
  module Types
    module Builder
      module RefMode
        extend(ActiveSupport::Concern)

        # @return [Builder]
        def as_external_ref
          with_ref_mode(JsonModel::RefMode::EXTERNAL)
        end

        # @return [Builder]
        def as_local_ref
          with_ref_mode(JsonModel::RefMode::LOCAL)
        end

        # @param [Symbol] mode
        # @return [Builder]
        def with_ref_mode(mode)
          @ref_mode = mode
          self
        end

        # @return [Symbol]
        def ref_mode
          @ref_mode || JsonModel::RefMode::INLINE
        end
      end
    end
  end
end
