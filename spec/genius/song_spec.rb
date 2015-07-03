require 'spec_helper'

describe Genius::Song do
  before { Genius.access_token = ENV['GENIUS_ACCESS_TOKEN'] }

  describe ".search", vcr: { cassette_name: "song-search-the-hills" } do
    let(:query) { "The Hills" }
    subject(:results) { Genius::Song.search(query) }

    its(:length) { is_expected.to eq(20) }

    context "first result" do
      subject { results.first }

      its(:title) { is_expected.to eq("The Hills") }
    end
  end

  context "Migos's Versace", vcr: { cassette_name: "song-176872" } do
    subject(:song) { described_class.find("176872") }

    its(:id) { is_expected.to eq(176872) }
    its(:url) { is_expected.to eq("http://genius.com/Migos-versace-lyrics") }
    its(:title) { is_expected.to eq("Versace") }

    its(:media) do
      is_expected.to eq([{ "type" => "video",
                           "provider" => "youtube",
                           "url" => "http://www.youtube.com/watch?v=rF-hq_CHNH0" }])
    end

    its(:description_annotation) { is_expected.to be_a(Hash) }
    its(:annotation_count) { is_expected.to eq(1) }
    its(:tracking_paths) { is_expected.to be_nil }
    its(:description) { is_expected.to include("the song blew up") }
    its(:bop_url) { is_expected.to be_nil }
    its(:header_image_url) { is_expected.to start_with("http://images.rapgenius.com/") }
    its(:lyrics_updated_at) { is_expected.to be_nil }
    its(:updated_by_human_at) { is_expected.to be_nil }
    its(:pyongs_count) { is_expected.to eq(198) }
    its(:stats) { is_expected.to include("pageviews" => 2256108) }

    its(:current_user_metadata) do
      is_expected.to eq("interactions" => { "pyong"=> false },
                        "permissions" => %w(moderate_annotations
                                            create_annotation))
    end

    describe "#verified_annotations_by" do
      subject(:verified_annotations_by) { song.verified_annotations_by }

      specify { expect(verified_annotations_by.first).to include("name" => "Migos") }
    end

    describe "#primary_artist" do
      subject { song.primary_artist }

      it { is_expected.to be_a(Genius::Artist) }
      its(:name) { is_expected.to eq("Migos") }
    end

    describe "#featured_artists" do
      subject(:featured_artists) { song.featured_artists }

      its(:length) { is_expected.to eq(1) }
      its(:first) { is_expected.to be_a(Genius::Artist) }

      context "first" do
        subject { featured_artists.first }
        its(:name) { is_expected.to eq("Drake") }
      end
    end

    describe "#writer_artists" do
      subject { song.writer_artists }

      its(:length) { is_expected.to eq(0) }
    end

    describe "#producer_artists" do
      subject(:producer_artists) { song.producer_artists }

      its(:length) { is_expected.to eq(1) }

      context "first" do
        subject { producer_artists.first }

        its(:name) { is_expected.to eq("Zaytoven") }
        it { is_expected.to be_a(Genius::Artist) }
      end
    end

    describe "#reload" do
      subject(:reload) { song.reload }

      it "doesn't raise an error" do
        expect { reload }.not_to raise_error
      end

      it "grabs the data again" do
        expect(song.title).to eq("Versace")
      end
    end
  end

  context "a non-existent song ID", vcr: { cassette_name: "song-bahahaha" } do
    subject(:song) { described_class.find("bahahaha") }

    it "raises an exception" do
      expect { song }.to raise_error(Genius::NotFoundError)
    end
  end
end
