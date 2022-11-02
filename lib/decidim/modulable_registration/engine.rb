# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module ModulableRegistration
    # This is the engine that runs on the public interface of modulable_registration.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::ModulableRegistration

      routes do
        # Add engine routes here
        # resources :modulable_registration
        # root to: "modulable_registration#index"
      end

      initializer "ModulableRegistration.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "decidim_modulable_registration.extends" do
        require "decidim/extends/models/organization_extend"
        require "decidim/extends/forms/registration_form_extend"
        require "decidim/extends/commands/create_registration_extend"

        config.to_prepare do
          Decidim::Organization.include OrganizationExtend
          Decidim::RegistrationForm.include RegistrationFormExtend
          Decidim::CreateRegistration.include CreateRegistrationExtend
        end
      end
    end
  end
end
