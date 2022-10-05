# frozen_string_literal: true

require "active_support/concern"

module RegistrationFormExtend
  extend ActiveSupport::Concern

  included do
    attribute :birth_date, Decidim::Attributes::LocalizedDate

    validate :birth_date_validation

    private

    def birth_date_validation
      return unless current_organization.registration_fields_enabled?
      return unless current_organization.activated_registration_field? :birth_date
      return if birth_date.is_a? Date

      errors.add :birth_date, :format, message: "Format must be : 01/01/2000"
    end
  end
end
