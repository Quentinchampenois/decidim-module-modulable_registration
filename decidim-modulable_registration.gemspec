# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/modulable_registration/version"

Gem::Specification.new do |s|
  s.version = Decidim::ModulableRegistration.version
  s.authors = ["Quentinchampenois"]
  s.email = ["26109239+Quentinchampenois@users.noreply.github.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://decidim.org"
  s.metadata = {
    "bug_tracker_uri" => "https://github.com/decidim/decidim/issues",
    "documentation_uri" => "https://docs.decidim.org/",
    "funding_uri" => "https://opencollective.com/decidim",
    "homepage_uri" => "https://decidim.org",
    "source_code_uri" => "https://github.com/decidim/decidim"
  }
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-modulable_registration"
  s.summary = "A decidim modulable_registration module"
  s.description = "Make your Decidim registration form customizable directly from backoffice."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::ModulableRegistration.version
end
