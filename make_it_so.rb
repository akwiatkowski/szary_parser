require "uri"
require "net/http"
require "yaml"

# gem install nokogiri
require "nokogiri"

uri = "https://web.archive.org/web/20090923112317/http://doskonaleszare.blox.pl/2009/09/Efekt-cieplarniany-podejscie-pierwsze.html"

class SzaryParser
  def initialize(uri)
    @uri = uri
  end

  def body
    @body ||= Net::HTTP.get URI(@uri)
  end

  def post_content
    @post_content ||= begin
      document = Nokogiri::HTML.parse(body)
      document.css("#SkomentujBox")
    end
  end

  def title
    post_content.css(".TytulKomentowanegoWpisu").css("h2").text
  end

  def abstract
    post_content.css(".WstepKomentowanegoWpisu").text
  end

  def content
    post_content.css(".TrescKomentowanegoWpisu").css("p").map(&:text)
  end

  def result
    {
      title: title,
      abstract: abstract,
      content: content
    }
  end
end

parser = SzaryParser.new(uri)
puts parser.result.to_yaml
