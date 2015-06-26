require 'spec_helper'

describe Genius::Annotation do
  before { Genius.access_token = ENV['GENIUS_ACCESS_TOKEN'] }

  context "Annotation 6737668", vcr: { cassette_name: "annotation-6737668" } do
    subject(:annotation) { described_class.find("6737668") }

    its(:id) { is_expected.to eq(6737668) }
    its(:url) { is_expected.to eq("http://genius.com/6737668/docs.genius.com") }
    its(:share_url) { is_expected.to eq("http://genius.com/6737668") }
    its(:body) { is_expected.to eq("In this case, 6737668.") }
    its(:comment_count) { is_expected.to eq(0) }
    its(:votes_total) { is_expected.to eq(0) }
    its(:authors) { is_expected.to be_a(Array) }
    its(:verified_by) { is_expected.to be_a(Genius::Account) }
    its(:state) { is_expected.to eq("verified") }
    its(:current_user_metadata) { is_expected.to include("permissions") }

    describe "#reload" do
      subject(:reload) { annotation.reload }

      it "doesn't raise an error" do
        expect { reload }.not_to raise_error
      end

      it "grabs the data again" do
        expect(annotation.id).to eq(6737668)
      end
    end
  end

  context "a non-existent annotation ID", vcr: { cassette_name: "annotation-bahahaha" } do
    subject(:annotation) { described_class.find("bahahaha") }

    it "raises an exception" do
      expect { annotation }.to raise_error(Genius::NotFoundError)
    end
  end
end
