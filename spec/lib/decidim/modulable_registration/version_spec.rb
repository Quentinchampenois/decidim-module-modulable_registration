# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe ModulableRegistration do
    subject { described_class }

    it "has version" do
      expect(subject.version).to eq("0.26.3")
    end
  end
end
