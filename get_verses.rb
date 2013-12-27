require "uri"
require "open-uri"
require "nokogiri"

passage = ARGV[0] or raise "Specify the verse range as the first arg"
version = "NRSV" # TODO: make this an option?

uri = URI("http://www.biblegateway.com/passage/")
uri.query = URI.encode_www_form(
  "search" => passage,
  "version" => version
)

doc = Nokogiri::HTML(open(uri))

puts doc.css(".passage").to_s
