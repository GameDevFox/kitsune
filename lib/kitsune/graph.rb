module Kitsune::Graph
  prefix = 'kitsune/graph'

  autoload :ExtendedEdges, "#{prefix}/extended_edges"
  autoload :ExtendedGraph, "#{prefix}/extended_graph"
  autoload :Node, "#{prefix}/node"
  autoload :QueryResult, "#{prefix}/query_result"
  autoload :SQLite3Edges, "#{prefix}/sqlite3_edges"
  autoload :System, "#{prefix}/system"

  module_prefix = "#{prefix}/modules"

  # modules
  autoload :BiDirectionalPathGraph, "#{module_prefix}/bi_directional_path_graph"
  autoload :CompositeGraph, "#{module_prefix}/composite_graph"
  autoload :EdgeGraph, "#{module_prefix}/edge_graph"
  autoload :InversePathGraph, "#{module_prefix}/inverse_path_graph"
  autoload :RelationshipGraph, "#{module_prefix}/relationship_graph"
end
