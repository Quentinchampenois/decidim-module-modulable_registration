# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe RegistrationForm do
    subject do
      described_class.from_params(
        attributes
      ).with_context(
        context
      )
    end

    let(:organization) { create(:organization, registration_fields: registration_fields) }
    let(:registration_fields) do
      {
        "enabled" => true,
        "birth_date" => true,
        "minimum_age" => true
      }
    end
    let(:name) { "User" }
    let(:nickname) { "justme" }
    let(:email) { "user@example.org" }
    let(:password) { "S4CGQ9AM4ttJdPKS" }
    let(:password_confirmation) { password }
    let(:tos_agreement) { "1" }
    let(:birth_date) { "01/01/2000" }
    let(:minimum_age) { true }

    let(:attributes) do
      {
        name: name,
        nickname: nickname,
        email: email,
        password: password,
        password_confirmation: password_confirmation,
        tos_agreement: tos_agreement,
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

    context "when registration_fields are disabled" do
      let(:registration_fields) do
        {
          "enabled" => false,
          "birth_date" => true,
          "minimum_age" => true
        }
      end

      it { is_expected.to be_valid }
    end

    describe "birth_date" do
      context "when registration field is disabled" do
        let(:registration_fields) do
          {
            "enabled" => true,
            "birth_date" => false,
            "minimum_age" => true
          }
        end

        it { is_expected.to be_valid }
      end

      context "when birth_date is not a class" do
        let(:birth_date) { "Not a date" }

        it { is_expected.to be_invalid }
      end
    end

    describe "minimum_age" do
      context "when registration field is disabled" do
        let(:registration_fields) do
          {
            "enabled" => true,
            "birth_date" => true,
            "minimum_age" => false
          }
        end

        it { is_expected.to be_valid }
      end

      context "when minimum_age is not checked" do
        let(:minimum_age) { false }

        it { is_expected.to be_invalid }
      end
    end
  end
end
