require "./spec_helper"

struct ART::RequestTest < ASPEC::TestCase
  def test_hostname : Nil
    request = ART::Request.new "GET", "/"
    request.hostname.should be_nil

    request = ART::Request.new "GET", "/", HTTP::Headers{"host" => "www.domain.com"}
    request.hostname.should eq "www.domain.com"

    request = ART::Request.new "GET", "/", HTTP::Headers{"host" => "www.domain.com:8080"}
    request.hostname.should eq "www.domain.com"
  end

  # def test_hostname_trusted : Nil
  # end

  @[DataProvider("mime_type_provider")]
  def test_mime_type(format : String, mime_types : Indexable(String)) : Nil
    request = ART::Request.new "GET", "/"
    mime_types.each do |mt|
      request.format(mt).should eq format
    end

    request.class.register_format format, mime_types

    mime_types.each do |mt|
      request.format(mt).should eq format

      if !format.nil?
        mime_types[0].should eq request.mime_type format
      end
    end
  end

  def test_request_format : Nil
    request = ART::Request.new "GET", "/"
    request.request_format.should eq "json"

    request.request_format("html").should eq "html"
    request.request_format("json").should eq "json"

    request = ART::Request.new "GET", "/"
    request.request_format(nil).should be_nil

    request = ART::Request.new "GET", "/"
    request.request_format = "foo"
    request.request_format.should eq "foo"
  end

  def mime_type_provider : Tuple
    {
      {"txt", {"text/plain"}},
      {"js", {"application/javascript", "application/x-javascript", "text/javascript"}},
      {"css", {"text/css"}},
      {"json", {"application/json", "application/x-json"}},
      {"jsonld", {"application/ld+json"}},
      {"xml", {"text/xml", "application/xml", "application/x-xml"}},
      {"rdf", {"application/rdf+xml"}},
      {"atom", {"application/atom+xml"}},
    }
  end

  def test_safe? : Nil
    ART::Request.new("GET", "/").safe?.should be_true
    ART::Request.new("HEAD", "/").safe?.should be_true
    ART::Request.new("OPTIONS", "/").safe?.should be_true
    ART::Request.new("TRACE", "/").safe?.should be_true
    ART::Request.new("POST", "/").safe?.should be_false
    ART::Request.new("PUT", "/").safe?.should be_false
  end
end
