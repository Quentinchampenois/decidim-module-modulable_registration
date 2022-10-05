# frozen_string_literal: true

require "spec_helper"

def fill_registration_form
  fill_in :registration_user_name, with: "Nikola Tesla"
  fill_in :registration_user_nickname, with: "the-greatest-genius-in-history"
  fill_in :registration_user_email, with: "nikola.tesla@example.org"
  fill_in :registration_user_password, with: "sekritpass123"
  fill_in :registration_user_password_confirmation, with: "sekritpass123"
end

describe "Modulable registration", type: :system do
  let(:organization) { create(:organization, registration_fields: registration_fields) }
  let(:registration_fields) do
    {
      "enabled" => true,
      "birth_date" => true
    }
  end
  let!(:terms_and_conditions_page) { Decidim::StaticPage.find_by(slug: "terms-and-conditions", organization: organization) }

  before do
    switch_to_host(organization.host)
    visit decidim.new_user_registration_path
  end

  context "when signing up" do
    shared_examples_for "disabled registration fields" do
      it "does not display registration fields" do
        expect(page).not_to have_css(".card__modulable_registration")
        expect(page).not_to have_content("More information")
      end
    end

    it "show extra registration fields" do
      within ".card__modulable_registration" do
        expect(page).to have_content("More information")
      end
    end

    context "when registration fields are disabled" do
      let(:organization) { create(:organization, :registration_fields_disabled) }

      it_behaves_like "disabled registration fields"
    end

    context "when registration fields is enabled" do
      context "and all fields are disabled" do
        let(:registration_fields) do
          {
            "enabled" => true,
            "birth_date" => false
          }
        end

        it_behaves_like "disabled registration fields"
      end
    end
  end
end
