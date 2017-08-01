require 'sqlite3'

require 'kitsune/hash'

module Kitsune
  module Graph

    class SQLite3Edges

      include Kitsune::Graph::ExtendedEdges

      N = Kitsune::Nodes

      def initialize(db)
        @db = db

        @insert_ps = @db.prepare 'INSERT INTO edges (head, tail, edge) VALUES (?, ?, ?);'
        @has_ps = @db.prepare 'SELECT COUNT(*) FROM edges WHERE edge = :edge;'
      end

      def create_edge(head, tail)
        edge_node = Kitsune::Hash.compound_hash([head, tail])
        edge = [head, tail, edge_node]
        @insert_ps.execute(edge)
        edge
      end

      def get_edges(id)
        ids = Array(id)
        query = "SELECT head, tail, edge FROM edges WHERE edge IN (#{placeholders ids.size});"
        @db.execute query, id
      end

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
        @db.execute query, params
      end

      def has_edge(edge)
        edge_count = @has_ps.execute({edge: edge}).to_a[0][0]
        throw "More than one edge for #{edge.to_hex}" if edge_count > 1

        edge_count.positive?
      end

      def placeholders size
        Array.new(size, '?').join ', '
      end
    end

  end
end
