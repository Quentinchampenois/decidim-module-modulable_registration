# frozen_string_literal: true

require "spec_helper"

module Decidim
  module ModulableRegistration
    module Admin
      describe UpdateRegistrationFields do
        let(:organization) { create(:organization, registration_fields: {}) }
        let(:user) { create :user, :admin, :confirmed, organization: organization }

        let(:registration_fields_enabled) { true }
        let(:birth_date) { true }
        let(:minimum_age) { true }
        let(:form_params) do
          {
            "registration_fields_enabled" => registration_fields_enabled,
            "birth_date" => birth_date,
            "minimum_age" => minimum_age
          }
        end
        let(:form) do
          ModulableRegistrationForm.from_params(
            form_params
          ).with_context(
            current_user: user,
            current_organization: organization
          )
        end
        let(:command) { described_class.new(form) }

        describe "call" do
          context "when the form is not valid" do
            before do
              expect(form).to receive(:invalid?).and_return(true)
            end

            it "broadcasts invalid" do
              expect { command.call }.to broadcast(:invalid)
            end

            it "doesn't update the registration fields" do
              expect do
                command.call
                organization.reload
              end.not_to change(organization, :registration_fields)
            end
          end

          context "when the form is valid" do
            it "broadcasts ok" do
              expect { command.call }.to broadcast(:ok)
            end

            it "updates the organization registration fields" do
              command.call
              organization.reload

              expect(organization.registration_fields).to eq({ "enabled" => true, "birth_date" => true, "minimum_age" => true })
            end
          end
        end
      end
    end
  end
end
