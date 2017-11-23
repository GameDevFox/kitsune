require 'spec_helper'

module GraphSpecHelper
  include Kitsune::Nodes
  
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
    edges.create_type 'brother', 'sister', SIBLING
    edges.create_type 'father', 'son', CHILD

    # Set as bi-directional paths
    edges.create_edge BI_DIRECTIONAL_PATHS, INVERSE_PATH
    edges.create_edge BI_DIRECTIONAL_PATHS, SIBLING
    edges.create_edge BI_DIRECTIONAL_PATHS, SAME

    # Set CHILD as the inverse path of PARENT
    edges.create_type PARENT, CHILD, INVERSE_PATH

    # Create bi-directional group and add children
    edges.create_type SAME, SAME_GROUP, BI_DIRECTIONAL_GROUP
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
    type_edges = []
    type_edges.push edges.create_type('Alice', 'a', NAME)
    type_edges.push edges.create_type('Bob', 'b', NAME)
    type_edges.push edges.create_type('Robert', 'b', NAME)
    type_edges.push edges.create_type('Chris', 'c', NAME)
    type_edges.push edges.create_type('Alice', 'aa', NAME)
    type_edges
  end
end
