class AddRegistrationFieldsToDecidimOrganization < ActiveRecord::Migration[6.0]
  def up
    add_column :decidim_organizations, :registration_fields, :jsonb, default: {}
  end

  def down
    remove_column :decidim_organizations, :registration_fields, :jsonb
  end
end
