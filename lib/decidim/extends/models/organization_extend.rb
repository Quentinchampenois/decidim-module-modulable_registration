# frozen_string_literal: true

require "active_support/concern"

module OrganizationExtend
  extend ActiveSupport::Concern

  included do
    # If true display registration field in signup form
    def registration_fields_enabled?
      activated_registration_field?(:enabled) && registration_fields.reject { |key| key == "enabled" }.map { |_, value| value }.include?(true)
    end

    # Check if the given value is enabled in registration_fields
    def activated_registration_field?(sym)
      return false if registration_fields[sym.to_s].blank?

      registration_fields[sym.to_s]
    end
  end
end
