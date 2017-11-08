require 'sqlite3'

require 'kitsune/hash'

module Kitsune
  module Graph

    class SQLite3Edges
      include Kitsune::Graph::ExtendedEdges

      N = Kitsune::Nodes

      attr_accessor :db

      def self.init(db)
        query = <<~QUERY
          CREATE TABLE edges (
            edge varchar(32) primary key,
            head varchar(32),
            tail varchar(32)
          );
        QUERY

        db.execute query
      end

      def initialize(db)
        @db = db
        @db.results_as_hash = true

        @insert_ps = @db.prepare 'INSERT INTO edges (edge, head, tail) VALUES (:edge, :head, :tail);'
        @has_ps = @db.prepare 'SELECT COUNT(*) FROM edges WHERE edge = :edge;'
      end

      def create_edge(head, tail)
        edge_node = Kitsune::Hash.list_hash([head, tail])
        edge = { edge: edge_node, head: head, tail: tail }

        @insert_ps.execute(ascii_8bit_hash(edge))
        edge_node
      end

      def get_edges(edge)
        edges = [edge].flatten
        query = "SELECT head, tail, edge FROM edges WHERE edge IN (#{placeholders edges.size});"
        @db.execute(query, ascii_8bit_array(edges))
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
        @db.execute(query, ascii_8bit_array(params))
      end

      def has_edge(edge)
        edge_count = @has_ps.execute(ascii_8bit_hash({ edge: edge })).to_a[0][0]
        throw "More than one edge for #{edge.to_hex}" if edge_count > 1

        edge_count.positive?
      end

      private
      def placeholders(size)
        Array.new(size, '?').join ', '
      end

      def ascii_8bit_array(params)
        params.map { |v| v.force_encoding(Encoding::ASCII_8BIT) }
      end

      def ascii_8bit_hash(params)
        params.map { |k, v| [k, v.force_encoding(Encoding::ASCII_8BIT)] }.to_h
      end
    end

  end
end
