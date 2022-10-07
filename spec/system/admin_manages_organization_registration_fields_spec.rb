# frozen_string_literal: true

require "spec_helper"

describe "Admin manages organization registration fields", type: :system do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization: organization) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  it "creates a new item in submenu" do
    visit decidim_admin.edit_organization_path

    within ".secondary-nav" do
      expect(page).to have_content("Registration fields")
    end
  end

  context "when accessing modulable registration" do
    before do
      visit decidim_modulable_registration.root_path
    end

    it "displays the form" do
      within "#modulable_registration" do
        expect(page).to have_content("Manage your registration form")
      end
    end

    it "allows to enable registration fields" do
      within ".registration_fields" do
        expect(page).to have_content("Enable registration fields")
      end

      within ".extra_registration_fields" do
        expect(page).to have_content("Enable birth date field")
        expect(page).to have_content("Enable minimum age checkbox condition")
      end
    end

    context "when form is valid" do
      it "flashes a success message" do
        page.check("modulable_registration[registration_fields_enabled]")
        page.check("modulable_registration[birth_date]")
        page.check("modulable_registration[minimum_age]")

        find("*[type=submit]").click
        expect(page).to have_content("Organization successfully updated !")
      end
    end
  end
end
