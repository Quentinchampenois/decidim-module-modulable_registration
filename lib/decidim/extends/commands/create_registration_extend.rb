# frozen_string_literal: true

require "active_support/concern"

module CreateRegistrationExtend
  extend ActiveSupport::Concern

  included do
    def create_user
      @user = Decidim::User.create!(
        email: form.email,
        name: form.name,
        nickname: form.nickname,
        password: form.password,
        password_confirmation: form.password_confirmation,
        organization: form.current_organization,
        tos_agreement: form.tos_agreement,
        newsletter_notifications_at: form.newsletter_at,
        email_on_notification: true,
        accepted_tos_version: form.current_organization.tos_version,
        locale: form.current_locale,
        extended_data: extended_data
      )
    end

    def extended_data
      {
        birth_date: form.birth_date,
        minimum_age: form.minimum_age
      }
    end
  end
end
