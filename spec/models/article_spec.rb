# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  body       :text
#  subtitle   :string(255)
#  section    :string(255)
#  teaser     :string(255)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string(255)
#  image_id   :integer
#

require 'spec_helper'

describe Article do

  before do
    @article = Article.new(title: 'Ash defeats Gary in Indigo Plateau',
                           subtitle: 'Oak arrives just in time',
                           teaser: 'Ash becomes new Pokemon champion',
                           body: '**Pikachu** wrecks everyone. The End.',
                           section: '/news/',
                           )
    @article.authors << Author.new(name: 'Trainer Mitch')
  end

  subject { @article }

  it { should have_and_belong_to_many :authors }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :section }
  it { should validate_presence_of :authors }

  it { should be_valid }

  it "should be searchable" do
    Article.searchable?.should be_true
  end

  describe "#section" do
    it { @article.section.should be_a_kind_of(Taxonomy) }
    it do
      taxonomy = Taxonomy.new(['News', 'University'])
      @article.section = taxonomy
      @article.section.should eq taxonomy
    end
  end

  describe "#render_body" do
    it "should render the article body with markdown" do
      html = '<p><strong>Pikachu</strong> wrecks everyone. The End.</p>'
      subject.render_body.rstrip.should == html
    end
  end

  describe "#normalize_friendly_id" do
    subject { @article.normalize_friendly_id(@article.title) }

    it "should be lowercased" do
      should match(/[a-z_\d\-]+/)
    end

    it "should contain key words of title" do
      should include('ash')
      should include('defeats')
      should include('gary')
      should include('indigo')
      should include('plateau')
    end

    it "should not have unnecessary words" do
      should_not include('-in-')
    end

    context "long title" do
      subject { @article.normalize_friendly_id('a' * 49 + '-' + 'b' * 50) }
      it { should have_at_most(50).characters }
      it { should_not match(/\-$/) }
    end
  end

  describe "::find_by_section" do
    before do
      Article.create(title: 'What? Squirtle is evolving!',
                     body: 'Squirtle evolved into Wartortle',
                     section: '/news/')
      Article.create(title: 'What? Charmander is evolving!',
                     body: 'Charmander evolved into Charmeleon',
                     section: '/news/university')
      Article.create(title: 'What? Bulbasaur is evolving!',
                     body: 'Bulbasaur evolved into Ivysaur',
                     section: '/sports/')
    end

    subject { Article.find_by_section(Taxonomy.new(['News'])) }

    it "should return all articles with a subsection of the given section" do
      should include(Article.find_by_title('What? Squirtle is evolving!'))
      should include(Article.find_by_title('What? Charmander is evolving!'))
    end

    it "should be chainable with other query methods" do
      articles = Article.find_by_section(Taxonomy.new(['News'])).limit(1)
      articles.should have(1).article
    end
  end

end
