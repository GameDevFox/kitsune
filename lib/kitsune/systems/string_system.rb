using Kitsune::Refine

class Kitsune::Systems::StringSystem
  include Kitsune::Nodes
  include Kitsune::System

  def initialize(db, debug = false)
    @db = db
    @debug = debug

    db.results_as_hash = true

    # should we create the table?
    result = db.execute "SELECT COUNT(*) as has_table FROM sqlite_master WHERE type='table' AND name='strings'"
    has_table = result[0]['has_table'].positive?
    create_table unless has_table

    @read = db.prepare 'SELECT string FROM strings WHERE hash = :hash'
    @write = db.prepare 'INSERT INTO strings (hash, string) VALUES (:hash, :string)'
    @search = db.prepare 'SELECT hash, string FROM strings WHERE string LIKE :pattern ESCAPE "\"'
  end

  def create_table
    puts 'Creating "strings" table' if @debug

    @db.execute <<~EOF
      CREATE TABLE strings (
        hash VARCHAR(32) PRIMARY KEY ON CONFLICT IGNORE,
        string TEXT
      );
    EOF
  end

  command ~[READ, STRING] do |hash|
    result = @read.execute({ hash: hash })
    result.next&.dig('string')
  end

  command ~[WRITE, STRING] do |string|
    hash = Kitsune::Hash.sha256(string).to_hex
    @write.execute({ hash: hash, string: string })
    hash
  end

  command ~[SEARCH, STRING] do |pattern|
    escaped_pattern = pattern.gsub('\\', '\\\\\\').gsub('_', '\_').gsub('%', '\%')
    result = @search.execute({ pattern: "%#{escaped_pattern}%" }).to_a
    result.map { |row| [row['hash'], row['string']] }.to_h
  end
end
