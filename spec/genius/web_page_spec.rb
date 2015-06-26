require 'spec_helper'

describe Genius::WebPage do
  before { Genius.access_token = ENV['GENIUS_ACCESS_TOKEN'] }

  describe ".find" do
    it "raises an error" do
      expect { described_class.find("foo") }.to raise_error(/cannot be loaded by its ID/)
    end
  end

  context ".lookup", vcr: { cassette_name: "web_page-lookup" } do
    subject(:web_page) do
      described_class.lookup(raw_annotatable_url: "https://docs.genius.com")
    end

    its(:id) { is_expected.to eq(10347) }
    its(:url) { is_expected.to eq("http://genius.com/docs.genius.com") }
    its(:title) { is_expected.to eq("Genius API") }
    its(:normalized_url) { is_expected.to eq("//docs.genius.com") }
    its(:domain) { is_expected.to eq("docs.genius.com") }
    its(:share_url) { is_expected.to eq("http://genius.it/docs.genius.com") }
    its(:annotation_count) { is_expected.to eq(12) }

    describe "#reload" do
      subject(:reload) { web_page.reload }

      it "raises an error" do
        expect { reload }.to raise_error(/cannot be reloaded/)
      end
    end
  end
end
