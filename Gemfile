# frozen_string_literal: true

source "https://rubygems.org"

DECIDIM_VERSION = { git: "https://github.com/decidim/decidim", branch: "release/0.26-stable" }
ruby RUBY_VERSION

gem "decidim", DECIDIM_VERSION
gem "decidim-modulable_registration", path: "."

gem "puma", ">= 5.5.1"
gem "bootsnap", "~> 1.4"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "faker", "~> 2.14"
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "4.0.4"
end
