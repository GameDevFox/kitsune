require 'spec_helper'

module GraphSpecHelper
  N = Kitsune::Nodes

  SIBLING = 'sibling'
  PARENT = 'parent'
  CHILD = 'child'

  SAME = 'same'
  SAME_GROUP = 'same_group'
  CHILD_A = 'childA'
  CHILD_B = 'childB'
  CHILD_C = 'childC'
  CHILD_D = 'childD'

  NAME = 'name'

  def self.create_db
    db = SQLite3::Database.new(':memory:')
    Kitsune::Graph::SQLite3Edges.init db

    db
  end

  def self.sample_edges
    db = create_db

    edges = Kitsune::Graph::SQLite3Edges.new db
    edges.create_edge 'head', 'tail'
    edges.create_rel 'brother', 'sister', SIBLING
    edges.create_rel 'father', 'son', CHILD

    # Set as bi-directional paths
    edges.create_edge N::BI_DIRECTIONAL_PATHS, N::INVERSE_PATH
    edges.create_edge N::BI_DIRECTIONAL_PATHS, SIBLING
    edges.create_edge N::BI_DIRECTIONAL_PATHS, SAME

    # Set CHILD as the inverse path of PARENT
    edges.create_rel PARENT, CHILD, N::INVERSE_PATH

    # Create bi-directional group and add children
    edges.create_rel SAME, SAME_GROUP, N::BI_DIRECTIONAL_GROUP
    edges.create_edge SAME_GROUP, CHILD_A
    edges.create_edge SAME_GROUP, CHILD_B
    edges.create_edge SAME_GROUP, CHILD_C
    edges.create_edge SAME_GROUP, CHILD_D

    edges
  end

  def self.sample_edges_b(edges)
    edges.create_edge 'another-head', 'tail'
    edges
  end

  def self.add_some_edges(edges)
    rel_edges = []
    rel_edges.push edges.create_rel('Alice', 'a', NAME)
    rel_edges.push edges.create_rel('Bob', 'b', NAME)
    rel_edges.push edges.create_rel('Robert', 'b', NAME)
    rel_edges.push edges.create_rel('Chris', 'c', NAME)
    rel_edges.push edges.create_rel('Alice', 'aa', NAME)
    rel_edges
  end
end
