# frozen_string_literal: true

require "spec_helper"

module Decidim
  module ModulableRegistration
    module Admin
      describe ModulableRegistrationForm do
        subject do
          described_class.from_params(
            attributes
          ).with_context(
            context
          )
        end

        let(:organization) { create(:organization) }
        let(:registration_fields_enabled) { true }
        let(:birth_date) { true }
        let(:minimum_age) { true }

        let(:attributes) do
          {
            registration_fields_enabled: registration_fields_enabled,
            birth_date: birth_date,
            minimum_age: minimum_age
          }
        end

        let(:context) do
          {
            current_organization: organization
          }
        end

        context "when everything is OK" do
          it { is_expected.to be_valid }
        end
      end
    end
  end
end
