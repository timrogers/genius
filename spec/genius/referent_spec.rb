require 'spec_helper'

describe Genius::Referent do
  before { Genius.access_token = ENV['GENIUS_ACCESS_TOKEN'] }

  describe ".find" do
    it "raises an error" do
      expect { described_class.find("foo") }.to raise_error(/cannot be loaded by its ID/)
    end
  end

  context ".where", vcr: { cassette_name: "referent-where" } do
    subject(:referents) { described_class.where(web_page_id: 10347) }

    it { is_expected.to be_a(Array) }

    context "first" do
      subject(:referent) { referents.first }

      its(:id) { is_expected.to eq(6913377) }
      its(:url) { is_expected.to eq("http://genius.com/6913377/docs.genius.com") }
      its(:song_id) { is_expected.to be_nil }
      its(:annotator_id) { is_expected.to eq(1821545) }
      its(:fragment) { is_expected.to eq("Making Requests") }
      its(:range) { is_expected.to include("start", "startOffset") }
      its(:annotatable) { is_expected.to include("title" => "Genius API") }
      its(:classification) { is_expected.to eq("accepted") }
      its(:song) { is_expected.to be_nil }

      describe "#annotations" do
        subject(:annotations) { referent.annotations }

        its(:count) { is_expected.to eq(1) }

        context "first" do
          subject { annotations.first }

          its(:id) { is_expected.to eq(6913377) }
          it { is_expected.to be_a(Genius::Annotation) }
        end
      end

      describe "#reload" do
        subject(:reload) { referent.reload }

        it "raises an error" do
          expect { reload }.to raise_error(/cannot be reloaded/)
        end
      end
    end
  end
end
