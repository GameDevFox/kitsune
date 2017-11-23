require 'sqlite3'

class Kitsune::Graph::SQLite3Edges
  include Kitsune::Graph::ExtendedEdges

  attr_accessor :db

  def self.init(db)
    db.execute <<~EOF
      CREATE TABLE edges (
        edge VARCHAR(32) PRIMARY KEY,
        head VARCHAR(32),
        tail VARCHAR(32)
      );
    EOF
  end

  def initialize(db)
    @db = db
    @db.results_as_hash = true

    @insert_ps = @db.prepare 'INSERT INTO edges (edge, head, tail) VALUES (:edge, :head, :tail);'
    @has_ps = @db.prepare 'SELECT COUNT(*) FROM edges WHERE edge = :edge;'
  end

  # WRITE_EDGE
  def create_edge(head, tail)
    edge_node = Kitsune::Hash.hash_list([head, tail])
    edge = { edge: edge_node, head: head, tail: tail }

    @insert_ps.execute(edge)
    edge_node
  end

  # READ_EDGE - partial
  def get_edges(edge)
    edges = [edge].flatten
    query = "SELECT head, tail, edge FROM edges WHERE edge IN (#{placeholders edges.size});"
    @db.execute(query, edges)
  end

  # SEARCH_EDGE - partial
  def search_edges(head = nil, tail = nil)
    where_clause = nil
    params = []

    if head
      heads = Array(head)
      where_clause = " WHERE head IN (#{placeholders heads.size})"
      params.concat heads
    end

    if tail
      tails = Array(tail)
      prefix = head ? "#{where_clause} AND" : ' WHERE'
      where_clause = "#{prefix} tail IN (#{placeholders tails.size})"
      params.concat tails
    end

    query = "SELECT * FROM edges#{where_clause};"
    @db.execute(query, params)
  end

  def has_edge(edge)
    edge_count = @has_ps.execute({ edge: edge }).to_a[0][0]
    throw "More than one edge for #{edge.to_hex}" if edge_count > 1

    edge_count.positive?
  end

  private
  def placeholders(size)
    Array.new(size, '?').join ', '
  end

end
