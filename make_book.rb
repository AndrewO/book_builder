require "haml"

toc = File.read(ARGV[0])
chapters = ARGV[1..-1].to_a.map {|path| File.read(path)}

engine = Haml::Engine.new(File.read("book.haml"))
puts engine.render(Object.new, {toc: toc, chapters: chapters})
