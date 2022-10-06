# frozen_string_literal: true

require "active_support/concern"

module RegistrationFormExtend
  extend ActiveSupport::Concern

  included do
    attribute :birth_date, Decidim::Attributes::LocalizedDate
    attribute :minimum_age, Virtus::Attribute::Boolean

    validates :birth_date, presence: true, if: :birth_date?
    validates :minimum_age, acceptance: true, if: :minimum_age?

    private

    def birth_date?
      current_organization.registration_fields_enabled? && current_organization.activated_registration_field?(:birth_date)
    end

    def minimum_age?
      current_organization.registration_fields_enabled? && current_organization.activated_registration_field?(:minimum_age)
    end
  end
end
