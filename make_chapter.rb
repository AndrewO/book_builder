require "haml"
require "hashie"
require "nokogiri"

class Chapter < Hashie::Dash
  property :id, required: true
  property :title, required: true
  property :subtitle
  property :locations, default: []
  property :passage
  property :body
end

class Location < Hashie::Dash
  property :where
  property :when
end

def make_chapter(path)
  doc = Nokogiri::HTML(File.read(path))

  Chapter.new(
    id: "ch-#{File.basename(path).to_i}",
    title: doc.xpath("//title").first.content,
    subtitle: get_classification(doc),
    locations: get_locations(doc),
    body: doc.xpath("//body").first.children
  ).tap do |ch|
    ch.passage = get_passage(ch.subtitle)
  end
end

ENGINE = Haml::Engine.new(File.read("chapter.haml"))
def run_template(chapter, engine = ENGINE)
  puts engine.render(chapter)
end

def get_classification(doc)
  if meta = doc.css("meta[name='CLASSIFICATION']").first
    meta["content"]
  end
end

def get_locations(doc)
  if meta = doc.css("meta[name='DESCRIPTION']").first
    meta['content'].split("\n").map do |line|
      where, _when = line.split(',')
      Location.new(where: where, when: _when)
    end
  else
    []
  end
end

def get_passage(title)
  path = "build/passages/#{title}.html"

  if File.exist?(path)
    passage = Nokogiri::HTML(File.read(path))
    passage.css(".footnotes").remove
    passage.css("sup.footnote").remove
    passage.xpath("//body").first.children
  end
end

path = ARGV[0]
run_template(make_chapter(path))
