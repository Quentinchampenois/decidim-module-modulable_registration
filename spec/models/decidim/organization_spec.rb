# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Organization do
    subject(:organization) { build(:organization, registration_fields: registration_fields) }

    let(:registration_fields) do
      {
        "enabled" => true,
        "birth_date" => true
      }
    end

    it { is_expected.to be_valid }
    it { is_expected.to be_versioned }

    describe "#activated_registration_field?" do
      it "returns the value of given key" do
        expect(subject).to be_activated_registration_field(:birth_date)
      end

      context "when given key doesn't exist in hash" do
        it "returns falsey" do
          expect(subject).not_to be_activated_registration_field(:unknown)
        end
      end

      context "when value for given key is nil" do
        let(:registration_fields) do
          {
            "enabled" => true,
            "birth_date" => nil
          }
        end

        it "returns falsey" do
          expect(subject).not_to be_activated_registration_field(:birth_date)
        end
      end
    end
  end
end
