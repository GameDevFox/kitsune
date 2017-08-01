module Kitsune

  module Graph
    prefix = 'kitsune/graph'

    autoload :ExtendedEdges, "#{prefix}/extended_edges"
    autoload :ExtendedGraph, "#{prefix}/extended_graph"
    autoload :Node, "#{prefix}/node"
    autoload :QueryResult, "#{prefix}/query_result"
    autoload :SQLite3Edges, "#{prefix}/sqlite3_graph"

    autoload :BiDirectionalPathGraph, "#{prefix}/modules/bi_directional_path_graph"
    autoload :CompositeGraph, "#{prefix}/modules/composite_graph"
    autoload :EdgeGraph, "#{prefix}/modules/edge_graph"
    autoload :InversePathGraph, "#{prefix}/modules/inverse_path_graph"
    autoload :RelationshipGraph, "#{prefix}/modules/relationship_graph"
  end

end
