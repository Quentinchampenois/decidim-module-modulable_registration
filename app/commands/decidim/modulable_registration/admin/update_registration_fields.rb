# frozen_string_literal: true

module Decidim
  module ModulableRegistration
    module Admin
      # A command with all the business logic when managing modulable registration fields in signup form
      class UpdateRegistrationFields < Rectify::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        def initialize(form)
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          update_registration_fields!

          broadcast(:ok)
        end

        private

        attr_reader :form

        def update_registration_fields!
          Decidim.traceability.update!(
            form.current_organization,
            form.current_user,
            registration_fields: registration_fields
          )
        end

        def registration_fields
          {
            "enabled" => form.registration_fields_enabled.presence || false,
            "birth_date" => form.birth_date.presence || false,
            "minimum_age" => form.minimum_age.presence || false
          }
        end
      end
    end
  end
end
