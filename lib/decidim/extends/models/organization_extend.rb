# frozen_string_literal: true

require "active_support/concern"

module OrganizationExtend
  extend ActiveSupport::Concern

  included do
    def registration_fields_enabled?
      return false if registration_fields["enabled"].blank?

      registration_fields["enabled"]
    end
  end
end

Decidim::Organization.include OrganizationExtend
