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

    describe "#upvote!" do
      subject(:upvote!) { annotation.upvote! }

      it "doesn't raise an error" do
        expect { upvote! }.not_to raise_error
      end

      it "returns true" do
        expect(upvote!).to be(true)
      end
    end

    describe "#unvote!" do
      subject(:unvote!) { annotation.unvote! }

      it "doesn't raise an error" do
        expect { unvote! }.not_to raise_error
      end

      it "returns true" do
        expect(unvote!).to be(true)
      end
    end

    describe "#downvote!" do
      subject(:downvote!) { annotation.downvote! }

      it "doesn't raise an error" do
        expect { downvote! }.not_to raise_error
      end

      it "returns true" do
        expect(downvote!).to be(true)
      end
    end

    context "an annotation belonging to Tim" do
      let(:annotation) { described_class.find("2734383") }

      describe "#update!" do
        let(:payload) do
          {
            annotation: {
              body: {
                markdown: "Getting a visa to work in the United States isn't easy. It " \
                          "might even be more more work than the work you'll be able " \
                          "to once you get it..."
              }
            }
          }
        end

        subject(:update!) { annotation.update!(payload) }

        it "doesn't raise an error" do
          expect { update! }.not_to raise_error
        end

        it "returns the updated annotation" do
          expect(update!).to be_a(Genius::Annotation)
        end
      end

      describe "#destroy!" do
        subject(:destroy!) { annotation.destroy! }

        it "doesn't raise an error" do
          expect { destroy! }.not_to raise_error
        end

        it "returns true" do
          expect(destroy!).to be(true)
        end
      end
    end
  end

  describe "#create!", vcr: { cassette_name: "annotation-create" } do
    subject(:create!) { Genius::Annotation.create!(body) }

    let(:body) do
      {
        annotation: {
          body: {
            markdown: "This has now moved to <https://github.com/timrogers/genius>."
          }
        },
        referent: {
          raw_annotatable_url: "http://timrogers.uk/portfolio/",
          fragment: "Rap Genius gem",
          context_for_display: {
            before_html: '<div class="post">',
            after_html: '<p class="byline">August 2013 - Present</p>'
          }
        },
        web_page: {
          title: "Tim Rogers"
        }
      }
    end

    it "doesn't raise an error" do
      expect { create! }.not_to raise_error
    end

    it "returns the created annotation" do
      expect(create!).to be_a(Genius::Annotation)
    end
  end

  context "a non-existent annotation ID", vcr: { cassette_name: "annotation-bahahaha" } do
    subject(:annotation) { described_class.find("bahahaha") }

    it "raises an exception" do
      expect { annotation }.to raise_error(Genius::NotFoundError)
    end
  end
end
