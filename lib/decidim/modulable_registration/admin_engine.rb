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
        # root to: "modulable_registration#index"
      end

      def load_seed
        nil
      end
    end
  end
end
