# frozen_string_literal: true

module Decidim
  module ModulableRegistration
    module Admin
      class ModulableRegistrationForm < Decidim::Form
        include TranslatableAttributes

        attribute :registration_fields_enabled, Virtus::Attribute::Boolean

        attribute :birth_date, Virtus::Attribute::Boolean
        attribute :minimum_age, Virtus::Attribute::Boolean
      end
    end
  end
end
