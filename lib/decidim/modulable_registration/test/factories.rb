# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :modulable_registration_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :modulable_registration).i18n_name }
    manifest_name :modulable_registration
    participatory_space { create(:participatory_process, :with_steps) }
  end

  # Add engine factories here
end
