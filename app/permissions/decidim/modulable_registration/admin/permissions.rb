# frozen_string_literal: true

module Decidim
  module ModulableRegistration
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          return permission_action if permission_action.scope != :admin
          return permission_action unless user&.admin?

          allow! if can_access?
          allow! if can_create?

          permission_action
        end

        def can_access?
          permission_action.subject == :modulable_registration &&
            permission_action.action == :read
        end

        def can_create?
          permission_action.subject == :modulable_registration &&
            permission_action.action == :create
        end
      end
    end
  end
end
