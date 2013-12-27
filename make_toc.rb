require "haml"
require "hashie"
require "nokogiri"

class TocItem < Hashie::Dash
  property :type, default: "chapter"
  property :name, required: true
  property :ref, required: true
end

def make_toc_item(path)
  doc = Nokogiri::HTML(File.read(path))
  TocItem.new(
    name: doc.xpath("//title").first.content,
    ref: "ch-#{File.basename(path).to_i}"
  )
end

toc = ARGV.map {|path| make_toc_item(path) }

engine = Haml::Engine.new(File.read("toc.haml"))
puts engine.render(Object.new, {items: toc})
