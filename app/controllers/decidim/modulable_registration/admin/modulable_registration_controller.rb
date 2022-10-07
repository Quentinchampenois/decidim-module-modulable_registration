# frozen_string_literal: true

module Decidim
  module ModulableRegistration
    module Admin
      class ModulableRegistrationController < Decidim::ModulableRegistration::Admin::ApplicationController
        layout "decidim/admin/settings"
        before_action :authorized?

        def index
          @form = form(ModulableRegistrationForm).instance
        end

        def create
          enforce_permission_to :create, :modulable_registration

          @form = form(ModulableRegistrationForm).from_params(
            params,
            current_organization: current_organization
          )

          UpdateRegistrationFields.call(@form) do
            on(:ok) do
              flash[:notice] = t(".success")
              render action: "index"
            end

            on(:invalid) do
              flash.now[:alert] = t(".failure")
              render action: "index"
            end
          end
        end

        private

        def authorized?
          enforce_permission_to :read, :modulable_registration
        end
      end
    end
  end
end
