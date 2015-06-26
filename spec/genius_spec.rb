require 'spec_helper'

describe Genius do
  it 'has a version number' do
    expect(Genius::VERSION).not_to be_nil
  end

  describe ".access_token" do
    it "can be set" do
      Genius.access_token = "dummy"
      expect(Genius.access_token).to eq("dummy")
    end
  end

  describe ".text_format" do
    it "defaults to 'plain'" do
      expect(Genius.text_format).to eq("plain")
    end

    it "can be set" do
      Genius.text_format = "html"
      expect(Genius.text_format).to eq("html")
    end
  end
end
