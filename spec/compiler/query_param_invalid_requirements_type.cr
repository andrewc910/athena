require "../spec_helper"

class CompileController < ART::Controller
  @[ARTA::Get(path: "/")]
  @[ARTA::QueryParam("all", requirements: "foo")]
  def action(all : Bool) : Int32
    123
  end
end

ART.run
