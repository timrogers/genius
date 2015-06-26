require 'spec_helper'

describe Genius::Artist do
  before { Genius.access_token = ENV['GENIUS_ACCESS_TOKEN'] }

  context "Sia", vcr: { cassette_name: "artist-16775", record: :new_episodes } do
    subject(:artist) { described_class.find("16775") }

    its(:id) { is_expected.to eq(16775) }
    its(:name) { is_expected.to eq("Sia") }
    its(:image_url) { is_expected.to start_with("http://images.rapgenius.com/") }
    its(:url) { is_expected.to eq("http://genius.com/artists/Sia") }
    its(:description) { is_expected.to include("Australian pop and jazz singer") }
    its(:tracking_paths) { is_expected.to include("aggregate", "concurrent") }

    describe "#user" do
      subject { artist.user }

      it { is_expected.to be_a(Genius::Account) }
      its(:name) { is_expected.to eq("Sia") }
    end

    describe "#songs" do
      subject(:songs) { artist.songs }

      its(:length) { is_expected.to eq(20) }

      context "first" do
        subject { songs.first }

        its(:title) { is_expected.to eq("1000 Forms of Fear Tracklist and Album Artwork") }
        it { is_expected.to be_a(Genius::Song) }
      end
    end

    describe "#reload" do
      subject(:reload) { artist.reload }

      it "doesn't raise an error" do
        expect { reload }.not_to raise_error
      end

      it "grabs the data again" do
        expect(artist.name).to eq("Sia")
      end
    end
  end

  context "a non-existent song ID", vcr: { cassette_name: "artist-bahahaha" } do
    subject(:artist) { described_class.find("bahahaha") }

    it "raises an exception" do
      expect { artist }.to raise_error(Genius::NotFoundError)
    end
  end
end
