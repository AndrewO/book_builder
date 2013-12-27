require "nokogiri"

doc = Nokogiri::HTML(STDIN.read)

# Remove styles
doc.xpath("//style").remove
doc.xpath("//@style").remove

doc.xpath("//font").each do |node|
  node.name = "span"
  node.remove_attribute("face")
end

doc.css("div[type='FOOTER']").remove

puts doc.to_s
