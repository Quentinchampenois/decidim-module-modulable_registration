# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Comments
    describe CreateRegistration do
      describe "call without registration_fields" do
        let(:organization) { create(:organization, :registration_fields_disabled) }

        let(:name) { "Username" }
        let(:nickname) { "nickname" }
        let(:email) { "user@example.org" }
        let(:password) { "Y1fERVzL2F" }
        let(:password_confirmation) { password }
        let(:tos_agreement) { "1" }
        let(:newsletter) { "1" }
        let(:current_locale) { "es" }

        let(:form_params) do
          {
            "user" => {
              "name" => name,
              "nickname" => nickname,
              "email" => email,
              "password" => password,
              "password_confirmation" => password_confirmation,
              "tos_agreement" => tos_agreement,
              "newsletter_at" => newsletter
            }
          }
        end
        let(:form) do
          RegistrationForm.from_params(
            form_params,
            current_locale: current_locale
          ).with_context(
            current_organization: organization
          )
        end
        let(:command) { described_class.new(form) }

        describe "when the form is not valid" do
          before do
            expect(form).to receive(:invalid?).and_return(true)
          end

          it "broadcasts invalid" do
            expect { command.call }.to broadcast(:invalid)
          end

          it "doesn't create a user" do
            expect do
              command.call
            end.not_to change(User, :count)
          end

          context "when the user was already invited" do
            let(:user) { build(:user, email: email, organization: organization) }

            before do
              user.invite!
              clear_enqueued_jobs
            end

            it "receives the invitation email again" do
              expect do
                command.call
                user.reload
              end.to change(User, :count).by(0)
                                         .and broadcast(:invalid)
                .and change(user.reload, :invitation_token)
              expect(ActionMailer::MailDeliveryJob).to have_been_enqueued.on_queue("mailers")
            end
          end
        end

        describe "when the form is valid" do
          it "broadcasts ok" do
            expect { command.call }.to broadcast(:ok)
          end

          it "creates a new user" do
            expect(User).to receive(:create!).with(
              name: form.name,
              nickname: form.nickname,
              email: form.email,
              password: form.password,
              password_confirmation: form.password_confirmation,
              tos_agreement: form.tos_agreement,
              newsletter_notifications_at: form.newsletter_at,
              email_on_notification: true,
              organization: organization,
              accepted_tos_version: organization.tos_version,
              locale: form.current_locale,
              extended_data: {
                birth_date: form.birth_date,
                minimum_age: form.minimum_age
              }
            ).and_call_original

            expect { command.call }.to change(User, :count).by(1)
          end

          describe "when user keeps the newsletter unchecked" do
            let(:newsletter) { "0" }

            it "creates a user with no newsletter notifications" do
              expect do
                command.call
                expect(User.last.newsletter_notifications_at).to eq(nil)
              end.to change(User, :count).by(1)
            end
          end
        end
      end

      describe "registration fields enabled" do
        # Create an organisation with registration fields enabled
        let(:organization) { create(:organization) }

        let(:name) { "Username" }
        let(:nickname) { "nickname" }
        let(:email) { "user@example.org" }
        let(:password) { "Y1fERVzL2F" }
        let(:password_confirmation) { password }
        let(:tos_agreement) { "1" }
        let(:newsletter) { "1" }
        let(:current_locale) { "es" }
        let(:birth_date) { "01/01/2000" }
        let(:minimum_age) { true }

        let(:form_params) do
          {
            "user" => {
              "name" => name,
              "nickname" => nickname,
              "email" => email,
              "password" => password,
              "password_confirmation" => password_confirmation,
              "tos_agreement" => tos_agreement,
              "newsletter_at" => newsletter,
              "birth_date" => birth_date,
              "minimum_age" => minimum_age
            }
          }
        end
        let(:form) do
          RegistrationForm.from_params(
            form_params,
            current_locale: current_locale
          ).with_context(
            current_organization: organization
          )
        end

        let(:command) { described_class.new(form) }

        describe "when the form is valid" do
          it "broadcasts ok" do
            expect { command.call }.to broadcast(:ok)
          end

          it "creates a new user" do
            expect(User).to receive(:create!).with(
              name: form.name,
              nickname: form.nickname,
              email: form.email,
              password: form.password,
              password_confirmation: form.password_confirmation,
              tos_agreement: form.tos_agreement,
              newsletter_notifications_at: form.newsletter_at,
              email_on_notification: true,
              organization: organization,
              accepted_tos_version: organization.tos_version,
              locale: form.current_locale,
              extended_data: {
                birth_date: form.birth_date,
                minimum_age: form.minimum_age
              }
            ).and_call_original

            expect { command.call }.to change(User, :count).by(1)
          end

          context "when the form is supposed valid and the user has a registration field that is empty and so doesn't create the user" do
            describe "when birth_date is mandatory but unchecked" do
              let(:minimum_age) { false }

              it "returns an error" do
                expect do
                  expect { command.call }.to broadcast(:invalid)
                  expect(form.errors.messages[:minimum_age]).to include("must be accepted")
                end.to change(User, :count).by(0)
              end
            end

            describe "when birth_date is mandatory but empty" do
              let(:birth_date) { nil }

              it "returns an error" do
                expect do
                  # Expect messages from command.call to contain "can't be blank"
                  expect { command.call }.to broadcast(:invalid)
                  expect(form.errors.messages[:birth_date]).to include("can't be blank")
                end.to change(User, :count).by(0)
              end
            end

            describe "when both of them are mandatory but empty and unchecked" do
              let(:birth_date) { nil }
              let(:minimum_age) { false }

              it "returns an error" do
                expect do
                  expect { command.call }.to broadcast(:invalid)
                  expect(form.errors.messages[:minimum_age]).to include("must be accepted")
                  expect(form.errors.messages[:birth_date]).to include("can't be blank")
                end.to change(User, :count).by(0)
              end
            end
          end
        end
      end
    end
  end
end
