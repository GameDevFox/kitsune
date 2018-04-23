using Kitsune::Refine

class Kitsune::Coders::CommonCoder
  include Kitsune::Nodes
  include Kitsune::System

  def initialize(system)
    @system = system
  end

  command ~[CODE, STRING] do |string|
    escaped_string = string.gsub("\\", "\\\\\\").gsub('"', '\"')
    "\"" + escaped_string + "\""
  end

  command ~[CODE, INTEGER] do |integer|
    integer.to_s
  end

  command ~[CODE, LIST_N] do |list|
    code_list = list.map { |item| @system.execute CODE, item }
    code_list.join("\n")
  end
end
