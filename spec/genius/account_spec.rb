require 'spec_helper'

describe Genius::Account do
  before { Genius.access_token = ENV['GENIUS_ACCESS_TOKEN'] }

  describe ".find" do
    it "raises an error" do
      expect { described_class.find("foo") }.to raise_error(/cannot be loaded by its ID/)
    end
  end

  context ".me", vcr: { cassette_name: "account-me" } do
    subject(:account) { described_class.me }

    its(:unread_messages_count) { is_expected.to eq(0) }
    its(:artist) { is_expected.to be_nil }
    its(:role_for_display) { is_expected.to eq("editor") }
    its(:unread_main_activity_inbox_count) { is_expected.to eq(36) }
    its(:avatar) { is_expected.to include("medium", "original") }
    its(:about_me) { is_expected.to include("I wanted a RapGenius API") }
    its(:iq) { is_expected.to eq(1691) }
    its(:name) { is_expected.to eq("timrogers") }
    its(:tracking_paths) { is_expected.to eq("aggregate" => "/timrogers") }
    its(:id) { is_expected.to eq(128992) }
    its(:current_user_metadata) { is_expected.to include("permissions") }
    its(:login) { is_expected.to eq("timrogers") }

    describe "#reload" do
      subject(:reload) { account.reload }

      it "raises an error" do
        expect { reload }.to raise_error(/cannot be reloaded/)
      end
    end
  end
end
