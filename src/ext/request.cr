class HTTP::Request
  private FORMATS = {
    "html" => Set{"text/html", "application/xhtml+xml"},
    "txt"  => Set{"text/plain"},
    "css"  => Set{"text/css"},
    "json" => Set{"application/json", "application/x-json"},
  }

  def self.register_format(format : String, mime_types : Indexable(String)) : Nil
    FORMATS[format] = mime_types.to_set
  end

  def self.mime_types(format : String) : Set(String)
    FORMATS[format]? || Set(String).new
  end

  # The `ART::Action` object associated with this request.
  #
  # Will only be set if a route was able to be resolved.
  property! action : ART::ActionBase

  # See `ART::ParameterBag`.
  getter attributes : ART::ParameterBag = ART::ParameterBag.new

  @request_data : HTTP::Params?

  setter request_format : String? = nil

  def format(mime_type : String) : String?
    canonical_mime_type = nil

    if mime_type.includes? ';'
      canonical_mime_type = mime_type.split(';').first.strip
    end

    FORMATS.each do |format, mime_types|
      return format if mime_types.includes? mime_type
      return format if canonical_mime_type && mime_types.includes? canonical_mime_type
    end
  end

  def request_data
    @request_data ||= self.parse_request_data
  end

  def request_format(default : String? = "json") : String?
    if @request_format.nil?
      @request_format = self.attributes.get? "_format", String
    end

    @request_format || default
  end

  private def parse_request_data : HTTP::Params
    HTTP::Params.parse self.body.try(&.gets_to_end) || ""
  end
end
