# frozen_string_literal: true

module Decidim
  module ModulableRegistration
    module Admin
      class ModulableRegistrationController < Decidim::ModulableRegistration::Admin::ApplicationController
        layout "decidim/admin/settings"
        before_action :authorized?

        private

        def authorized?
          enforce_permission_to :read, :modulable_registration
        end
      end
    end
  end
end
