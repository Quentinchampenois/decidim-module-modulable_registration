# frozen_string_literal: true

module Decidim
  module ModulableRegistration
    # This is the engine that runs on the public interface of `ModulableRegistration`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::ModulableRegistration::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :modulable_registration do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        root to: "modulable_registration#index"
      end

      initializer "decidim_modulable_registration.admin_mount_routes" do
        Decidim::Core::Engine.routes do
          mount Decidim::ModulableRegistration::AdminEngine, at: "/admin/registration_fields", as: "decidim_modulable_registration"
        end
      end

      initializer "decidim_modulable_registration.admin_settings_menu" do
        Decidim.menu :admin_settings_menu do |menu|
          menu.add_item :modulable_registration,
                        t("decidim.admin.modulable_registration.menu.title"),
                        decidim_modulable_registration.root_path,
                        icon_name: "dashboard",
                        position: 11
        end
      end

      def load_seed
        nil
      end
    end
  end
end
