require "nokogiri"

doc = Nokogiri::HTML(STDIN.read)

doc.css("meta[name='CLASSIFICATION']").each do |meta|
  classification = meta.attr('content').to_s
  puts classification if classification.include?(":") # Simple filtering mechanism. Could be better.
end
