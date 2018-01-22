using Kitsune::Refine

class Kitsune::Systems::SQLite3EdgeSystem
  include Kitsune::Nodes
  include Kitsune::System

  def initialize(db)
    @db = db
    db.results_as_hash = true

    # should we create the table?
    result = db.execute "SELECT COUNT(*) as has_table FROM sqlite_master WHERE type='table' AND name='edges'"
    has_table = result[0]['has_table'].positive?
    create_table unless has_table

    @all = @db.prepare 'SELECT * FROM edges;'
    @count = @db.prepare 'SELECT COUNT(*) as count FROM edges;'
    @select_one = @db.prepare 'SELECT * FROM edges WHERE edge = :edge;'
    @insert = @db.prepare 'INSERT INTO edges (edge, head, tail) VALUES (:edge, :head, :tail);'
    @delete = @db.prepare 'DELETE FROM edges WHERE edge = :edge;'
  end

  def create_table
    puts 'Creating "edges" table'
    @db.execute <<~EOF
      CREATE TABLE edges (
        edge VARCHAR(32) PRIMARY KEY ON CONFLICT IGNORE,
        head VARCHAR(32),
        tail VARCHAR(32)
      );
    EOF
  end

  command ~[LIST, EDGE] do
    @all.execute.to_a
  end

  command ~[COUNT, EDGE] do
    @count.execute.to_a[0]['count']
  end

  command ~[READ, EDGE] do |edge_node|
    result = @select_one.execute({ edge: edge_node })
    result.next
  end

  command ~[WRITE, EDGE] do |edge|
    edge[:edge] = ~[edge[:head], edge[:tail]]
    @insert.execute edge
    edge[:edge]
  end

  command ~[DELETE, EDGE] do |edge_node|
    @delete.execute({ edge: edge_node })
  end

  command ~[SEARCH, EDGE] do |criteria|
    values = []
    where_parts = criteria.select { |_, v| v }.map { |k, v|
      vals = Array(v)
      values += vals
      "#{k} IN (#{placeholders vals.size})"
    }
    where_clause = values.size > 0 ? " WHERE #{where_parts.join ' AND '}" : '';

    query = "SELECT * FROM edges#{where_clause};"
    @db.execute(query, values)
  end

  private
  def placeholders(size)
    Array.new(size, '?').join ', '
  end
end
