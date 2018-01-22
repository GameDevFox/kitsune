require 'spec_helper'

using Kitsune::Refine

module GraphSpecHelper
  include Kitsune::Nodes
  
  SIBLING = 'sibling'.to_hex
  PARENT = 'parent'.to_hex
  CHILD = 'child'.to_hex

  SAME = 'same'
  SAME_GROUP = 'same_group'.to_hex
  CHILD_A = 'childA'.to_hex
  CHILD_B = 'childB'.to_hex
  CHILD_C = 'childC'.to_hex
  CHILD_D = 'childD'.to_hex

  NAME = 'name'.to_hex

  def self.create_db
    db = SQLite3::Database.new(':memory:')
    Kitsune::Graph::SQLite3Edges.init db

    db
  end

  def self.sample_edges
    db = create_db

    edges = Kitsune::Graph::SQLite3Edges.new db
    edges.create_edge 'head'.to_hex, 'tail'.to_hex
    edges.create_type 'brother'.to_hex, 'sister'.to_hex, SIBLING
    edges.create_type 'father'.to_hex, 'son'.to_hex, CHILD

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
    edges.create_edge 'another-head'.to_hex, 'tail'.to_hex
    edges
  end

  def self.add_some_edges(edges)
    type_edges = []
    type_edges.push edges.create_type('Alice'.to_hex, 'a'.to_hex, NAME)
    type_edges.push edges.create_type('Bob'.to_hex, 'b'.to_hex, NAME)
    type_edges.push edges.create_type('Robert'.to_hex, 'b'.to_hex, NAME)
    type_edges.push edges.create_type('Chris'.to_hex, 'c'.to_hex, NAME)
    type_edges.push edges.create_type('Alice'.to_hex, 'aa'.to_hex, NAME)
    type_edges
  end
end
